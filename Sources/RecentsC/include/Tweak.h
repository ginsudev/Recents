#import <UIKit/UIKit.h>

struct SBIconImageInfo {
    struct CGSize size;
    double scale;
    double continuousCornerRadius;
};

@interface SBApplicationInfo : NSObject
@property (nonatomic,copy,readonly) NSString * bundleIdentifier;
@end

@interface SBIcon : NSObject
@property (nonatomic,copy,readonly) NSString * displayName;
- (id)generateIconImageWithInfo:(struct SBIconImageInfo)arg1;
- (Class)iconImageViewClassForLocation:(id)arg1 ;
@end

@interface SBDisplayItem: NSObject
@property (nonatomic,copy,readonly) NSString * bundleIdentifier;
@end

@interface SBIconModel : NSObject
- (SBIcon *)expectedIconForDisplayIdentifier:(id)arg1;
@end

@interface SBHIconManager : NSObject
@end

@interface SBIconController : NSObject
@property (nonatomic,retain) SBIconModel * model;
@property (nonatomic, readonly) SBHIconManager *iconManager;
+ (instancetype)sharedInstance;
- (void)presentLibraryOverlayForIconManager:(id)arg1;
@end


@interface SBLeafIcon : SBIcon
@property (nonatomic,copy,readonly) NSString * sbh_iconLibraryItemIdentifier;
@end

@interface SBApplication : UIApplication
@property (nonatomic,readonly) NSString * bundleIdentifier;
@end

@interface SBApplicationIcon : SBLeafIcon
@end

@interface SBIconImageView : UIView
@property (nonatomic,readonly) SBIcon * icon;
@end

@interface SBIconView : UIView
@property (nonatomic,copy,readonly) NSString * applicationBundleIdentifierForShortcuts;
@end

@interface MTMaterialView : UIView
+ (instancetype)materialViewWithRecipe:(long long)arg1 configuration:(long long)arg2;
@property (assign,nonatomic) long long recipe;
@end
