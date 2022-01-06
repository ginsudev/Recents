import Orion
import RecentsC
import UIKit

//MARK: - Setting our icon
class SBApplicationInfoHook: ClassHook<SBApplicationInfo> {
    
    func iconClass() -> AnyClass {
        
        //Use our subclass instead of SBApplicationIcon.
        guard target.bundleIdentifier != "com.ginsu.recentsapp" else {
            return NSClassFromString("Recents.RCNTSApplicationIcon")!
        }
        
        return orig.iconClass()
    }
}

class SBIconImageViewHook: ClassHook<SBIconImageView> {
    
    func contentsImage() -> UIImage? {
        let img = orig.contentsImage()
        
        //Hides the default icon image for our app only.
        let icon = target.icon as? SBApplicationIcon
        guard icon?.sbh_iconLibraryItemIdentifier != "com.ginsu.recentsapp" else {
            return nil
        }
        
        return img
    }
}

//MARK: - Recent app cycling and logging
class SpringBoardHook: ClassHook<UIApplication> {
    static var targetName: String = "SpringBoard"
    
    @Property(.nonatomic, .retain) var array = [String]()
    
    func frontDisplayDidChange(_ display: AnyObject?) {
        orig.frontDisplayDidChange(display)
        
        guard let display = display as? SBApplication else {
            return
        }
        
        let first_id  = display.bundleIdentifier as String
        
        let defaults_array = UserDefaults.standard.stringArray(forKey: "Recents_app_bundle_identifiers") ?? ["", "", "", ""]
        
        for i in defaults_array {
            array.append(i)
        }
        
        if !array.contains(first_id) {
            array.insert(first_id, at: 0)
            
            if array.count > 4 {
                let range = 4...(array.endIndex - 1)
                array.removeSubrange(range)
            }
        }
        
        UserDefaults.standard.set(array, forKey: "Recents_app_bundle_identifiers")
        NotificationCenter.default.post(name: NSNotification.Name("Recents_UpdateIcons"), object: nil)
    }
}

class SBLeafIconHook: ClassHook<SBLeafIcon> {
    
    func launchFromLocation(_ arg1: AnyObject, context arg2: AnyObject) {
        if (target.sbh_iconLibraryItemIdentifier == "com.ginsu.recentsapp") {
            
            let controller: SBHIconManager = SBIconController.sharedInstance().iconManager
            SBIconController.sharedInstance().presentLibraryOverlay(forIconManager: controller)
            
            return
            
        } else {
            orig.launchFromLocation(arg1, context: arg2)
        }
    }
    
}
