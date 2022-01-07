import Orion
import RecentsC
import UIKit

struct localSettings {
    static var isEnabled: Bool!
    static var prefersApplibrary: Bool!
}

struct tweak: HookGroup {}

//MARK: - Setting our icon
class SBApplicationInfoHook: ClassHook<SBApplicationInfo> {
    typealias Group = tweak
    
    func iconClass() -> AnyClass {
        
        //Use our subclass instead of SBApplicationIcon.
        guard target.bundleIdentifier != "com.ginsu.recentsapp" else {
            return NSClassFromString("Recents.RCNTSApplicationIcon")!
        }
        
        return orig.iconClass()
    }
}

class SBIconImageViewHook: ClassHook<SBIconImageView> {
    typealias Group = tweak

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
    typealias Group = tweak
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
        }
        
        if array.count > 10 {
            let range = 10...(array.endIndex - 1)
            array.removeSubrange(range)
        }
        
        NSLog("[RecentsApp]: \(array)")
        
        UserDefaults.standard.set(array, forKey: "Recents_app_bundle_identifiers")
        NotificationCenter.default.post(name: NSNotification.Name("Recents_UpdateIcons"), object: nil)
    }
}

class SBLeafIconHook: ClassHook<SBLeafIcon> {
    typealias Group = tweak

    func launchFromLocation(_ arg1: AnyObject, context arg2: AnyObject) {
        if (target.sbh_iconLibraryItemIdentifier == "com.ginsu.recentsapp") {
            
            if localSettings.prefersApplibrary {
                let controller: SBHIconManager = SBIconController.sharedInstance().iconManager
                SBIconController.sharedInstance().presentLibraryOverlay(forIconManager: controller)
            } else {
                let keyWindow = UIApplication.shared.windows.first(where: {$0.isKeyWindow})
                let rootVC = keyWindow?.rootViewController
                let recentsVC = RCNTSViewController()
                rootVC?.present(recentsVC, animated: true, completion: nil)
            }
            
            return
            
        } else {
            orig.launchFromLocation(arg1, context: arg2)
        }
    }
}

//MARK: - Prefs

func readPrefs() {
    
    let path = "/var/mobile/Library/Preferences/com.ginsu.recentsprefs.plist"
    
    if (!FileManager().fileExists(atPath: path)) {
        try? FileManager().copyItem(atPath: "Library/PreferenceBundles/recentsprefs.bundle/defaults.plist", toPath: path)
    }
    
    let dict = NSDictionary(contentsOfFile: path)
    
    //Reading values
    
    if (dict?.value(forKey: "isEnabled") != nil) {
        localSettings.isEnabled = dict?.value(forKey: "isEnabled") as? Bool
    } else {
        localSettings.isEnabled = true
    }
    
    if (dict?.value(forKey: "ALMode") != nil) {
        localSettings.prefersApplibrary = dict?.value(forKey: "ALMode") as? Bool
    } else {
        localSettings.prefersApplibrary = false
    }
}

struct lockapps: Tweak {
    init() {
        readPrefs()
        if (localSettings.isEnabled) {
            tweak().activate()
        }
    }
}
