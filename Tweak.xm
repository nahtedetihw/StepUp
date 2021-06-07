@interface SBVolumeControl : NSObject
+(id)sharedInstance;
-(void)changeVolumeByDelta:(float)arg1 ;
-(float)_effectiveVolume;
-(void)_presentVolumeHUDWithVolume:(float)arg1 ;
-(void)setActiveCategoryVolume:(float)arg1 ;
- (void)increaseVolume;
- (void)decreaseVolume;
@end

@interface SBVolumeHUDSettings
- (float)volumeStepDelta;
@end

@interface NSUserDefaults (FDM)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

NSNumber *volumeStepper;
static NSString *domainString = @"com.nahtedetihw.stepup";
static NSString *notificationString = @"com.nahtedetihw.stepup/preferences.changed";

%group StepUp
%hook SBVolumeControl

- (void)decreaseVolume {
    %orig;
    [self _presentVolumeHUDWithVolume:[self _effectiveVolume]];
    
    // when volume is decreased, set the volume to current volume minus our custom step amount
    if ([volumeStepper floatValue]/100 >= 0) { // don't let volume % go below 0
        [self setActiveCategoryVolume:[self _effectiveVolume]-[volumeStepper floatValue]/100];
    }
    
}
- (void)increaseVolume {
    %orig;
    [self _presentVolumeHUDWithVolume:[self _effectiveVolume]];
    
    // when volume is increased, set the volume to current volume plus our custom step amount
    if ([volumeStepper floatValue]/100 <= 100) { // don't let volume % go above 100
        [self setActiveCategoryVolume:[self _effectiveVolume]+[volumeStepper floatValue]/100];
    }
    
}

- (void)changeVolumeByDelta:(float)arg1 {
    //remove orig value so we can make our own
}

%end

%hook SBVolumeHUDSettings
- (float)volumeStepDelta {
    return 0; // set this to 0 to let volume go below 6%
}
%end
%end

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSNumber *stepperValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"volumeStepper" inDomain:domainString];
    volumeStepper = (stepperValue)? [NSNumber numberWithFloat:[stepperValue floatValue]] : [NSNumber numberWithInt:16];
}

%ctor {
    notificationCallback(NULL, NULL, NULL, NULL, NULL);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
    %init(StepUp);
}
