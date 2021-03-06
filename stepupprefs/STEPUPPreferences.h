#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <spawn.h>

@interface UIPopoverPresentationController (Private)
@property (assign,setter=_setPopoverBackgroundStyle:,nonatomic) long long _popoverBackgroundStyle;
@property (assign,setter=_setBackgroundBlurDisabled:,nonatomic) BOOL _backgroundBlurDisabled;
@end

@interface STEPUPPreferencesListController : HBRootListController<UIPopoverPresentationControllerDelegate> {

    UITableView * _table;

}
@property (nonatomic, retain) UIBarButtonItem *killButton;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *headerImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) NSArray *versionArray;
- (void)apply:(UIButton *)sender;
- (void)twitter:(UIButton *)sender;
- (void)paypal:(UIButton *)sender;
- (void)handleYesGesture;
- (void)handleNoGesture:(UIButton *)sender;
@end

@interface STEPUPAppearanceSettings: HBAppearanceSettings
@end
