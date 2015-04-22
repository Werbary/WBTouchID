//
//  PRTouchIdManager.m
//  podRukoy
//
//  Created by Иван Труфанов on 31.03.15.
//  Copyright (c) 2015 Ratmanskiy Alexey. All rights reserved.
//

#include <sys/sysctl.h>
#import "WBTouchID.h"

@import LocalAuthentication;

NSString *const kWBTouchIdErrorDomain = @"WBTouchIdAuthenticationDomain";

@implementation WBTouchID

+ (NSString *)hardware {
  size_t size;
  sysctlbyname("hw.machine", NULL, &size, NULL, 0);
  char* machine = malloc(size);
  sysctlbyname("hw.machine", machine, &size, NULL, 0);
  NSString* hardware = [NSString stringWithCString:machine encoding: NSUTF8StringEncoding];
  free(machine);
  return hardware;
}

+ (BOOL)isDeviceValid {
    NSString *hardware = [self hardware];
    BOOL isValid;
    if ([hardware hasPrefix:@"iPhone6"] || [hardware hasPrefix:@"iPhone7"] || [hardware hasPrefix:@"iPad5"] || [hardware isEqualToString:@"iPad4,7"] || [hardware isEqualToString:@"iPad4,8"] || [hardware isEqualToString:@"iPad4,9"]) {
        isValid = YES;
    } else {
        isValid = NO;
    }
    return isValid;
}
+ (BOOL) canUseTouchID {
    if (NSClassFromString(@"LAContext") != nil && [self isDeviceValid]) {
        LAContext *context = [[LAContext alloc] init];
        return [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL];
    } else if (NSClassFromString(@"LAContext") != nil && ![self isDeviceValid]) {
        //iOS version support Touch ID Framework but device NO
        return NO;
    } else {
        //iOS doesn't support Touch ID framework ;)
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
