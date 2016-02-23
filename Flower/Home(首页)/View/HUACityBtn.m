//
//  HUACityBtn.m
//  Flower
//
//  Created by applewoainiqwe on 16/2/19.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUACityBtn.h"

@interface HUACityBtn ()

@property (nonatomic , strong) UILabel *titleL;
@property (nonatomic , strong) UIImageView *imageV;

@end

@implementation HUACityBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = HUAColor(0x575757);
        _titleL.textAlignment = NSTextAlignmentRight;
        _titleL.font = [UIFont systemFontOfSize:hua_scale(10)];
        _titleL.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:_titleL];
    }
    return _titleL;
}

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"select"]];
        [self addSubview:_imageV];
    }
    return _imageV;
}

- (void)setTitle:(NSString *)title{
    self.titleL.text = title;
//    CGSize titleSize = [self.titleL.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size;
//    
//
//    if (titleSize.width >= self.titleL.frame.size.width) {
//        self.titleL.textAlignment = NSTextAlignmentCenter;
//    }else{
//        self.titleL.textAlignment = NSTextAlignmentRight;
//    }
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.imageV setFrame:CGRectMake(CGRectGetWidth(frame) - self.imageV.frame.size.width, 0,self.imageV.frame.size.width,self.imageV.frame.size.height)];
    CGPoint point = self.imageV.center;
    point.y = self.frame.size.height/2;
    self.imageV.center = point;
    [self.titleL setFrame:CGRectMake(0, 0,CGRectGetWidth(frame) - self.imageV.frame.size.width - hua_scale(5), CGRectGetHeight(frame))];
    
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (self.selected) {
        self.imageV.image = [UIImage imageNamed:@"select_green"];
        self.titleL.textColor = HUAColor(0x4da800);
    }else{
        self.imageV.image = [UIImage imageNamed:@"select"];
        self.titleL.textColor = HUAColor(0x575757);
    }
}

@end
