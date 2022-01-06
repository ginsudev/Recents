import Orion
import RecentsC
import UIKit

//MARK: - Setting our icon
class SBApplicationInfoHook: ClassHook<SBApplicationInfo> {

    func iconClass() -> AnyClass {
        if target.bundleIdentifier == "com.ginsu.recentsapp" {
            return NSClassFromString("Recents.RCNTSApplicationIcon")!
        } else {
            return orig.iconClass()
        }
    }
}

class SBIconImageViewHook: ClassHook<SBIconImageView> {

    func contentsImage() -> UIImage? {
        let img = orig.contentsImage()

        let icon = (target.icon as? SBApplicationIcon)
        if icon?.sbh_iconLibraryItemIdentifier == "com.ginsu.recentsapp" {
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

        if (display != nil && display is SBApplication) {
            
            let first_id: String = (display as! SBApplication).bundleIdentifier
            
            
            let defaults_array = UserDefaults.standard.stringArray(forKey: "Recents_recentApps") ?? ["", "", "", ""]
            
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
            
            UserDefaults.standard.set(array, forKey: "Recents_recentApps")
            NotificationCenter.default.post(name: NSNotification.Name("Recents_UpdateIcons"), object: nil)
        }
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
