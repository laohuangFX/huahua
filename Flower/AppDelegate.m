//
//  AppDelegate.m
//  Flower
//
//  Created by 程召华 on 16/1/4.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "AppDelegate.h"
#import "HUATabBarController.h"
#import "HUALoginController.h"
#import "JPUSHService.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     
    // 1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    HUATabBarController *tabBarVC = [[HUATabBarController alloc] init];
    tabBarVC.selectedIndex= 2;
    self.window.rootViewController = tabBarVC;
    //背景色

    
    //开始监听网络状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //极光推送 注册
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    // Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    [JPUSHService setupWithOption:launchOptions appKey:@"023a23d3f750a296291c51d8" channel:@"APP Store" apsForProduction:NO];
    return YES;
    

    
}
/**  极光推送   **/

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo{
    application.applicationIconBadgeNumber = 0;
    [JPUSHService handleRemoteNotification:userInfo];
    NSString *string = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if ([[string substringToIndex:3] isEqualToString:@"发货了"]) {
        NSLog(@"发货了");
    }else{
        NSLog(@"一级棒");
    }
    
    NSLog(@"-------------------%@",userInfo);
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    application.applicationIconBadgeNumber = 0;
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"-------------------%@",userInfo);
    // 应用正处理前台状态下 处理推送消息
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收到推送消息"
                                                        message:userInfo[@"aps"][@"alert"]
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    }
    //在激活状态下，从上方弹出通知
    if (application.applicationState == UIApplicationStateActive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tuisong" object:nil userInfo:userInfo];
        
        
    }
}
#endif

/**
 *  返回devicetoken
 *
 *  @param application
 *  @param deviceToken
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    //将device token转换为字符串
    NSString *pushToken = [[[[deviceToken description]
                             
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           
                           stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:pushToken forKey:@"DeviceToken"];
    NSLog(@"uuid : %@",deviceToken);
    //    [UserManager shareManager].deviceToken = pushToken;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
     // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
