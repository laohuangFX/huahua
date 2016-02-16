//
//  HUAMBProgress.h
//  Flower
//
//  Created by 程召华 on 16/1/27.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAMBProgress : NSObject
+ (id)MBProgressFromWindowWithLabelText:(NSString *)labelText;


+ (id)MBProgressOnlywithLabelText:(NSString *)labelText;

+ (id)MBProgressFromWindowWithLabelText:(NSString *)labelText dispatch_get_main_queue:(void(^)())mainBlock;

+ (id)MBProgressFromView:(UIView *)view andLabelText:(NSString *)labelText;

+ (id)MBProgressFromView:(UIView *)view wrongLabelText:(NSString *)labelText;
@end
