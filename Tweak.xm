#import <Cephei/HBPreferences.h>
#import <AVKit/AVKit.h>

@interface SBVolumeControl : NSObject
+(id)sharedInstance;
-(void)changeVolumeByDelta:(float)arg1 ;
-(float)_effectiveVolume;
-(void)setActiveCategoryVolume:(float)arg1 ;
- (void)increaseVolume;
- (void)decreaseVolume;
- (float)volumeStepUp;
- (float)volumeStepDown;
@end

@interface SBVolumeHUDSettings
- (float)volumeStepDelta;
@end

BOOL isPlayingOnBuiltInSpeaker() {
    NSArray *availableOutputs = [[AVAudioSession sharedInstance] currentRoute].outputs;
    for (AVAudioSessionPortDescription *portDescription in availableOutputs) {
        if ([portDescription.portType isEqualToString:AVAudioSessionPortBuiltInSpeaker]) {
            return YES;
        }
    }
    return NO;
}

HBPreferences *preferences;
BOOL enabled;
NSNumber *volumeStepper;
NSNumber *volumeStepperHeadphones;

%group StepUp
%hook SBVolumeControl
- (void)decreaseVolume {
    %orig;
    
    // when volume is decreased, set the volume to current volume minus our custom step amount
    if ([volumeStepper floatValue]/100 >= 0) { // don't let volume % go below 0
        if (isPlayingOnBuiltInSpeaker() == YES) {
            [self setActiveCategoryVolume:[self _effectiveVolume]-[volumeStepper floatValue]/100];
        } else {
            [self setActiveCategoryVolume:[self _effectiveVolume]-[volumeStepperHeadphones floatValue]/100];
        }
    }
    
}
- (void)increaseVolume {
    %orig;
    
    // when volume is increased, set the volume to current volume plus our custom step amount
    if ([volumeStepper floatValue]/100 <= 100) { // don't let volume % go above 100
        if (isPlayingOnBuiltInSpeaker() == YES) {
            [self setActiveCategoryVolume:[self _effectiveVolume]+[volumeStepper floatValue]/100];
        } else {
            [self setActiveCategoryVolume:[self _effectiveVolume]+[volumeStepperHeadphones floatValue]/100];
        }
    }
    
}

- (void)changeVolumeByDelta:(float)arg1 {
    //remove orig value so we can make our own
}

- (float)volumeStepUp {
    return 0; // set this to 0 to let volume go below 6%
}

- (float)volumeStepDown {
    return 0; // set this to 0 to let volume go below 6%
}

%end

%hook SBVolumeHUDSettings
- (float)volumeStepDelta {
    return 0; // set this to 0 to let volume go below 6%
}
%end
%end

%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.nahtedetihw.stepupprefs"];
    [preferences registerBool:&enabled default:NO forKey:@"enabled"];
    [preferences registerObject:&volumeStepper default:[NSNumber numberWithInt:16] forKey:@"volumeStepper"];
    [preferences registerObject:&volumeStepperHeadphones default:[NSNumber numberWithInt:16] forKey:@"volumeStepperHeadphones"];
    
    if (enabled) {
        %init(StepUp);
        return;
    }
    return;
}
