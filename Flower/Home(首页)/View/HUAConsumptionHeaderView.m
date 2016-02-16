//
//  HUAConsumptionHeaderView.m
//  Flower
//
//  Created by 程召华 on 16/1/26.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAConsumptionHeaderView.h"

@implementation HUAConsumptionHeaderView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setView];
    }
    return self;
}

- (void)setView {
//    NSArray *array = @[@"全部", @"服务", @"产品", @"活动"];
//    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:array];
//    segmented.frame = CGRectMake(hua_scale(10), hua_scale(14), SCREEN_WIDTH-hua_scale(20), hua_scale(29));
//    segmented.segmentedControlStyle = UISegmentedControlStyleBordered;
//    segmented.tintColor= HUAColor(0x4da800);
//    
//    [self addSubview:segmented];
    
    CGRect dateFrame = CGRectMake(hua_scale(15), hua_scale(10), hua_scale(100), hua_scale(12));
    UILabel *dateLabel = [UILabel labelWithFrame:dateFrame text:@"日期" color:HUAColor(0x333333) font:hua_scale(12)];
    [self addSubview:dateLabel];
                        
    CGRect nameFrame = CGRectMake(hua_scale(97), hua_scale(10), hua_scale(100), hua_scale(12));
    UILabel *nameLabel = [UILabel labelWithFrame:nameFrame text:@"名称" color:HUAColor(0x333333) font:hua_scale(12)];
    [self addSubview:nameLabel];
    
    CGRect priceFrame = CGRectMake(hua_scale(260), hua_scale(10), hua_scale(100), hua_scale(12));
    UILabel *priceLabel = [UILabel labelWithFrame:priceFrame text:@"价格" color:HUAColor(0x333333) font:hua_scale(12)];
    [self addSubview:priceLabel];
    
    UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, hua_scale(31.5), SCREEN_WIDTH, hua_scale(0.5))];
    separateLine.backgroundColor = HUAColor(0xbcbcbc);
    [self addSubview:separateLine];
}
@end
