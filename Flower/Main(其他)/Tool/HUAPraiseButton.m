//
//  HUAPraiseButton.m
//  Flower
//
//  Created by 程召华 on 16/2/24.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAPraiseButton.h"

@implementation HUAPraiseButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.praiseImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, hua_scale(15), self.height)];
        self.label=[[UILabel alloc]initWithFrame:CGRectMake(hua_scale(20), 0, self.width-self.praiseImageView.width, self.height)];
        self.label.font = [UIFont systemFontOfSize:hua_scale(12)];
        self.praiseImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:self.label];
        [self addSubview:self.praiseImageView];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
