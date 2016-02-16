//
//  HUAProduct.m
//  Flower
//
//  Created by 程召华 on 16/1/5.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAProduct.h"

@implementation HUAProduct

+ (id)getProductDataWithDictionary:(NSDictionary *)dic{
    return [[self alloc] initWithProductDictionary:dic];
}

- (id)initWithProductDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.cover = dic[@"cover"];
        self.product_id = dic[@"product_id"];
        self.shop_id = dic[@"shop_id"];
        self.name = dic[@"name"];
        self.price = dic[@"price"];
        self.vip_discount = dic[@"vip_discount"];
        self.praise_count = dic[@"praise_count"];
    }
    return self;
}




-(id)initWithImageName:(NSString *)imageName productName:(NSString *)productName praiseCount:(NSString *)praiseCount productPrice:(NSString *)productPrice{
    if (self = [super init]) {
        _imageName = imageName;
        _productName = productName;
        _praiseCount = praiseCount;
        _productPrice = productPrice;
    }
    return self;
}

+(NSArray *)parseProductInfo{
    HUAProduct *product1 = [[HUAProduct alloc]initWithImageName:@"3" productName:@"保肌研极保湿三件套" praiseCount:@"1234" productPrice:@"200.12"];
    HUAProduct *product2 = [[HUAProduct alloc]initWithImageName:@"2" productName:@"保肌研极保湿三件套" praiseCount:@"234" productPrice:@"20.12"];
    HUAProduct *product3 = [[HUAProduct alloc]initWithImageName:@"3" productName:@"保肌研极保湿三件套" praiseCount:@"5" productPrice:@"19.99"];
    HUAProduct *product4 = [[HUAProduct alloc]initWithImageName:@"2" productName:@"保肌研极保湿三件套" praiseCount:@"3" productPrice:@"399.99"];
    HUAProduct *product5 = [[HUAProduct alloc]initWithImageName:@"3" productName:@"保肌研极保湿三件套" praiseCount:@"20000" productPrice:@"0.99"];
    return @[product1, product2, product3, product4, product5];
}
@end
