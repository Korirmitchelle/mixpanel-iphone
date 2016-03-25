//
//  NSNotificationCenter+AutomaticEvents.m
//  HelloMixpanel
//
//  Created by Sam Green on 2/23/16.
//  Copyright © 2016 Mixpanel. All rights reserved.
//

#import "NSNotificationCenter+AutomaticEvents.h"
#import "Mixpanel+AutomaticEvents.h"
#import "MPSwizzle.h"
#import "MPLogger.h"

@implementation NSNotificationCenter (AutomaticEvents)

- (void)mp_postNotification:(NSNotification *)notification {
    if ([NSNotificationCenter shouldTrackNotificationNamed:notification.name]) {
        [[Mixpanel sharedAutomatedInstance] trackNotification:notification];
    }
    
    [self mp_postNotification:notification];
}

- (void)mp_postNotificationName:(NSString *)name object:(nullable id)object {
    if ([NSNotificationCenter shouldTrackNotificationNamed:name]) {
        [[Mixpanel sharedAutomatedInstance] trackNotificationName:name object:object];
    }
    
    [self mp_postNotificationName:name object:object];
}

- (void)mp_postNotificationName:(NSString *)name
                         object:(nullable id)object
                       userInfo:(nullable NSDictionary *)info {
    if ([NSNotificationCenter shouldTrackNotificationNamed:name]) {
        [[Mixpanel sharedAutomatedInstance] trackNotificationName:name object:object userInfo:info];
    }
    
    [self mp_postNotificationName:name object:object userInfo:info];
}

+ (BOOL)shouldTrackNotificationNamed:(NSString *)name {
    // iOS spams notifications. We're whitelisting for now.
    NSArray *names = @[
                       // UITextField Editing
                       UITextFieldTextDidBeginEditingNotification,
                       UITextFieldTextDidChangeNotification,
                       UITextFieldTextDidEndEditingNotification,
                       
                       // UIApplication Lifecycle
                       UIApplicationDidFinishLaunchingNotification,
                       UIApplicationDidEnterBackgroundNotification,
                       UIApplicationDidBecomeActiveNotification ];
    NSSet<NSString *> *whiteListedNotificationNames = [NSSet setWithArray:names];
    return [whiteListedNotificationNames containsObject:name];
}

@end
