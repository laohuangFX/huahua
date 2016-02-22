//
//  HUAHttpStatus.m
//  Flower
//
//  Created by 程召华 on 16/2/22.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAHttpStatus.h"


@implementation HUAHttpStatus
//-(BOOL) isConnectionAvailable{
//    
//    BOOL isExistenceNetwork = YES;
//    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
//    switch ([reach currentReachabilityStatus]) {
//        case NotReachable:
//            isExistenceNetwork = NO;
//            //NSLog(@"notReachable");
//            break;
//        case ReachableViaWiFi:
//            isExistenceNetwork = YES;
//            //NSLog(@"WIFI");
//            break;
//        case ReachableViaWWAN:
//            isExistenceNetwork = YES;
//            //NSLog(@"3G");
//            break;
//    }
//}
+ (void)reachability
{
    // 检测网络连接状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 连接状态回调处理
    /* AFNetworking的Block内使用self须改为weakSelf, 避免循环强引用, 无法释放 */
    //__weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         switch (status)
         {
             case AFNetworkReachabilityStatusUnknown:
                 // 回调处理
                 break;
             case AFNetworkReachabilityStatusNotReachable:
                 // 回调处理
                 break;
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 // 回调处理
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 // 回调处理
                 break;
             default:
                 break;
         }
     }];
    
}
@end
