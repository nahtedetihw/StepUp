#include "STEPUPPreferences.h"
#import <AudioToolbox/AudioServices.h>

UIBarButtonItem *respringButtonItem;
UIBarButtonItem *twitterButtonItem;
UIBarButtonItem *paypalButtonItem;
UIViewController *popController;

@implementation STEPUPPreferencesListController
@synthesize killButton;
@synthesize versionArray;

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
    }

    return _specifiers;
}


- (instancetype)init {

    self = [super init];

    if (self) {

        
        STEPUPAppearanceSettings *appearanceSettings = [[STEPUPAppearanceSettings alloc] init];
        self.hb_appearanceSettings = appearanceSettings;
        UIButton *respringButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        respringButton.frame = CGRectMake(0,0,30,30);
        respringButton.layer.cornerRadius = respringButton.frame.size.height / 2;
        respringButton.layer.masksToBounds = YES;
        respringButton.backgroundColor = [UIColor colorWithRed:147/255.0f green:162/255.0f blue:167/255.0f alpha:1.0f];
        [respringButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/stepupprefs.bundle/CHECKMARK.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [respringButton addTarget:self action:@selector(apply:) forControlEvents:UIControlEventTouchUpInside];
        respringButton.tintColor = [UIColor colorWithRed:63/255.0f green:72/255.0f blue:83/255.0f alpha:1.0f];
        
        respringButtonItem = [[UIBarButtonItem alloc] initWithCustomView:respringButton];
        
        UIButton *twitterButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        twitterButton.frame = CGRectMake(0,0,30,30);
        twitterButton.layer.cornerRadius = twitterButton.frame.size.height / 2;
        twitterButton.layer.masksToBounds = YES;
        twitterButton.backgroundColor = [UIColor colorWithRed:147/255.0f green:162/255.0f blue:167/255.0f alpha:1.0f];
        [twitterButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/stepupprefs.bundle/TWITTER.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [twitterButton addTarget:self action:@selector(twitter:) forControlEvents:UIControlEventTouchUpInside];
        twitterButton.tintColor = [UIColor colorWithRed:63/255.0f green:72/255.0f blue:83/255.0f alpha:1.0f];
        
        twitterButtonItem = [[UIBarButtonItem alloc] initWithCustomView:twitterButton];
        
        UIButton *paypalButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        paypalButton.frame = CGRectMake(0,0,30,30);
        paypalButton.layer.cornerRadius = paypalButton.frame.size.height / 2;
        paypalButton.layer.masksToBounds = YES;
        paypalButton.backgroundColor = [UIColor colorWithRed:147/255.0f green:162/255.0f blue:167/255.0f alpha:1.0f];
        [paypalButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/stepupprefs.bundle/PAYPAL.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [paypalButton addTarget:self action:@selector(paypal:) forControlEvents:UIControlEventTouchUpInside];
        paypalButton.tintColor = [UIColor colorWithRed:63/255.0f green:72/255.0f blue:83/255.0f alpha:1.0f];
        
        paypalButtonItem = [[UIBarButtonItem alloc] initWithCustomView:paypalButton];
        
        NSArray *rightButtons;
        rightButtons = @[respringButtonItem, twitterButtonItem, paypalButtonItem];
        self.navigationItem.rightBarButtonItems = rightButtons;
        self.navigationItem.titleView = [UIView new];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.text = @"";
        self.titleLabel.textColor = [UIColor colorWithRed:63/255.0f green:72/255.0f blue:83/255.0f alpha:1.0f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.navigationItem.titleView addSubview:self.titleLabel];

        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/stepupprefs.bundle/icon.png"];
        self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
        self.iconView.alpha = 0.0;
        [self.navigationItem.titleView addSubview:self.iconView];

        [NSLayoutConstraint activateConstraints:@[
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
            [self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
        ]];

    }

    return self;

}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {

    return UIModalPresentationNone;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;

    self.navigationController.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:63/255.0f green:72/255.0f blue:83/255.0f alpha:1.0f];
    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationController.navigationBar.tintColor = [UIColor colorWithRed:63/255.0f green:72/255.0f blue:83/255.0f alpha:1.0f];
    self.navigationController.navigationController.navigationBar.translucent = NO;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableHeaderView = self.headerView;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/stepupprefs.bundle/banner.png"];
    self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.headerView addSubview:self.headerImageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
    ]];

    _table.tableHeaderView = self.headerView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNoGesture:)
                                                     name:UIApplicationDidEnterBackgroundNotification object:nil];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 200) {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 1.0;
            self.titleLabel.alpha = 0.0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 0.0;
            self.titleLabel.alpha = 1.0;
        }];
    }

    if (offsetY > 0) offsetY = 0;
    self.headerImageView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, 200 - offsetY);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
}

- (void)apply:(UIButton *)sender {
    
    popController = [[UIViewController alloc] init];
    popController.modalPresentationStyle = UIModalPresentationPopover;
    popController.preferredContentSize = CGSizeMake(200,130);
    UILabel *respringLabel = [[UILabel alloc] init];
    respringLabel.frame = CGRectMake(20, 20, 160, 60);
    respringLabel.numberOfLines = 2;
    respringLabel.textAlignment = NSTextAlignmentCenter;
    respringLabel.adjustsFontSizeToFitWidth = YES;
    respringLabel.font = [UIFont boldSystemFontOfSize:20];
    respringLabel.textColor = [UIColor colorWithRed:63/255.0f green:72/255.0f blue:83/255.0f alpha:1.0f];
    respringLabel.text = @"Are you sure you want to respring?";
    [popController.view addSubview:respringLabel];
    
    UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [yesButton addTarget:self
                  action:@selector(handleYesGesture)
     forControlEvents:UIControlEventTouchUpInside];
    [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    yesButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [yesButton setTitleColor:[UIColor colorWithRed:63/255.0f green:72/255.0f blue:83/255.0f alpha:1.0f] forState:UIControlStateNormal];
    yesButton.frame = CGRectMake(100, 100, 100, 30);
    [popController.view addSubview:yesButton];
    
    UIButton *noButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [noButton addTarget:self
                  action:@selector(handleNoGesture:)
     forControlEvents:UIControlEventTouchUpInside];
    [noButton setTitle:@"No" forState:UIControlStateNormal];
    noButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [noButton setTitleColor:[UIColor colorWithRed:63/255.0f green:72/255.0f blue:83/255.0f alpha:1.0f] forState:UIControlStateNormal];
    noButton.frame = CGRectMake(0, 100, 100, 30);
    [popController.view addSubview:noButton];
     
    UIPopoverPresentationController *popover = popController.popoverPresentationController;
    popover.delegate = self;
    //[popover _setBackgroundBlurDisabled:YES];
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.barButtonItem = respringButtonItem;
    popover.backgroundColor = [UIColor colorWithRed:147/255.0f green:162/255.0f blue:167/255.0f alpha:1.0f];
    
    [self presentViewController:popController animated:YES completion:nil];
    
    AudioServicesPlaySystemSound(1519);

}

- (void)twitter:(id)sender {
    AudioServicesPlaySystemSound(1519);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/EthanWhited"] options:@{} completionHandler:nil];
}

- (void)paypal:(id)sender {
    AudioServicesPlaySystemSound(1519);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/nahtedetihw"] options:@{} completionHandler:nil];
}

- (void)handleYesGesture {
    AudioServicesPlaySystemSound(1519);

    [popController dismissViewControllerAnimated:YES completion:nil];
    
    pid_t pid;
    const char* args[] = {"sbreload", NULL};
    posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
}

- (void)handleNoGesture:(UIButton *)sender {
    [popController dismissViewControllerAnimated:YES completion:nil];
}

@end


@implementation STEPUPAppearanceSettings: HBAppearanceSettings

- (UIColor *)tintColor {

    return [UIColor colorWithRed:63/255.0f green:72/255.0f blue:83/255.0f alpha:1.0f];

}

- (UIColor *)tableViewCellSeparatorColor {

    return [UIColor clearColor];

}


@end
