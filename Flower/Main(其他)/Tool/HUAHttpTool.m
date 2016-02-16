//
//  HUAHttpTool.m
//  Flower
//
//  Created by 程召华 on 16/2/13.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAHttpTool.h"

@implementation HUAHttpTool
+ (void)GET:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
            //[HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
        }
    }];

}
+ (void)POST:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
            
        }
    }];

}

+ (void)GETWithTokenAndUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    // 1.创建请求管理者
     NSString *token = [HUAUserDefaults getToken];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    // 2.发送请求
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
            //[HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
        }
    }];

}

+ (void)POSTWithTokenAndUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    // 1.创建请求管理者
    NSString *token = [HUAUserDefaults getToken];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    // 2.发送请求
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);
            //[HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
        }
        
    }];
}

@end
