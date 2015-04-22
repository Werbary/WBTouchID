//
//  PRTouchIdManager.h
//  podRukoy
//
//  Created by Иван Труфанов on 31.03.15.
//  Copyright (c) 2015 Ratmanskiy Alexey. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWBTouchIdReason @"Приложите палец для входа"

typedef void(^TouchIdCallback)(BOOL success,NSError *err);
@interface WBTouchID : NSObject

//Returns hardware name ex (iPhone 6,1)
+ (NSString *)hardware;

//Returns YES if device valid for Touch ID
+ (BOOL)isDeviceValid;

//Returns YES if device has Touch ID
+ (BOOL) canUseTouchID;

//Callback block handles YES, if Touch ID validated. No if handled error.
+ (void) validateTouchId:(TouchIdCallback)callback;
@end
