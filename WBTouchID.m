//
//  PRTouchIdManager.m
//  podRukoy
//
//  Created by Иван Труфанов on 31.03.15.
//  Copyright (c) 2015 Ratmanskiy Alexey. All rights reserved.
//

#import "WBTouchID.h"

@import LocalAuthentication;

NSString *const kWBTouchIdErrorDomain = @"WBTouchIdAuthenticationDomain";

@implementation WBTouchID

+ (BOOL) canUseTouchID {
    if (NSClassFromString(@"LAContext") != nil) {
        LAContext *context = [[LAContext alloc] init];
        return [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL];
    } else {
        //iOS version not support Touch ID
        return NO;
    }
}
+ (void) validateTouchId:(TouchIdCallback)callback {
    if (![self canUseTouchID]) {
        callback(NO,[NSError errorWithDomain:kWBTouchIdErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"Touch ID isn't availiable"}]);
        return;
    }
    
    LAContext *context = [[LAContext alloc] init];
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:kWBTouchIdReason reply:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                callback(YES,nil);
            } else {
                callback(NO,error);
            }
        });
    }];
}
@end
