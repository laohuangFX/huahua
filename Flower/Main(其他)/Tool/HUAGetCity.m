


//
//  HUAGetCity.m
//  Flower
//
//  Created by applewoainiqwe on 16/2/3.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAGetCity.h"

@implementation HUAGetCity


+(NSMutableArray *)getCityArray{
    //省级数组
    NSMutableArray *provinceArr = [NSMutableArray array];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSDictionary *root = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    for (int i = 0; i < [[root allKeys] count]; i++) {
        NSDictionary *dic = [root objectForKey:[NSString stringWithFormat:@"%d",i]];
        NSString *string = [dic allKeys][0];
        NSDictionary *city = [dic objectForKey:string];
        NSMutableArray *cityArr = [NSMutableArray array];
        for (int i = 0; i < [[city allKeys] count]; i++) {
            NSDictionary *areadic = [city objectForKey:[NSString stringWithFormat:@"%d",i]];
            NSString *areastring = [areadic allKeys][0];
            NSArray *area = [areadic objectForKey:areastring];
            
            [cityArr addObject:[NSDictionary dictionaryWithObject:area forKey:areastring]];
        }
        [provinceArr addObject:[NSDictionary dictionaryWithObject:cityArr forKey:string]];
    }
    return provinceArr;
}

@end
