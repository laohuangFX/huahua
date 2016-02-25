//
//  HUAHomeHeaderView.m
//  Flower
//
//  Created by 程召华 on 16/1/5.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAHomeHeaderView.h"
#import "HUAFunctionButtonView.h"
#import "HUAHomeController.h"

@interface HUAHomeHeaderView ()<FunctionViewDelegate>

//@property (nonatomic, strong) HUAHomeController *vc;
@end


@implementation HUAHomeHeaderView



- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //创建分类按钮的底部View
        HUAFunctionButtonView *categoryButtonView = [[HUAFunctionButtonView alloc] initWithFrame:CGRectMake(0, hua_scale(120), screenWidth, hua_scale(123))];
        categoryButtonView.delegate = self;
        categoryButtonView.backgroundColor = [UIColor whiteColor];
        [self addSubview:categoryButtonView];

    }
    return self;
}

- (void)clickToJump:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickToChooseCategory:)]) {
        [self.delegate clickToChooseCategory:sender];
    }
}

-(void)setImagesURLStrings:(NSArray *)imagesURLStrings {
    _imagesURLStrings = imagesURLStrings;
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screenWidth, hua_scale(120)) delegate:nil placeholderImage:nil];
    cycleScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_picture_middle"]];
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;

    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    [self addSubview:cycleScrollView];
    
}


@end
