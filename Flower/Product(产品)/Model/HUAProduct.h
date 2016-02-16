//
//  HUAProduct.h
//  Flower
//
//  Created by 程召华 on 16/1/5.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUAProduct : NSObject

@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSString *shop_id;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *vip_discount;
@property (nonatomic, strong) NSString *praise_count;

+ (id)getProductDataWithDictionary:(NSDictionary *)dic;


@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *praiseCount;
@property (nonatomic, strong) NSString *productPrice;
-(id)initWithImageName:(NSString *)imageName productName:(NSString *)productName praiseCount:(NSString *)praiseCount productPrice:(NSString *)productPrice;
+(NSArray *)parseProductInfo;
@end
