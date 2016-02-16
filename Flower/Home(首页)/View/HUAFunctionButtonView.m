//
//  HUAFunctionButtonView.m
//  Flower
//
//  Created by 程召华 on 16/1/5.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAFunctionButtonView.h"

@implementation HUAFunctionButtonView
- (NSArray *)functionImages {
    if (!_functionImages) {
        _functionImages = @[@"all", @"hairdressing", @"shampoo", @"meijia", @"bodybuilding", @"weizhengxing"];
    }
    return _functionImages;
}

- (NSArray *)functionNames {
    if (!_functionNames) {
        _functionNames = @[@"全部", @"美容", @"美发", @"美甲", @"美体", @"微整形"];
    }
    return _functionNames;
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        for (int i = 0; i < 6; i++) {
            UIButton *fuctionButton =[UIButton buttonWithType:0];
            fuctionButton.tag =  i;
            
            [fuctionButton setImage:[UIImage imageNamed:self.functionImages[i]] forState:UIControlStateNormal];
            [fuctionButton setTitle:self.functionNames[i] forState:UIControlStateNormal];
            [fuctionButton addTarget:self action:@selector(showFunction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:fuctionButton];
            [fuctionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.top.mas_equalTo(hua_scale(8));
                    make.left.mas_equalTo(hua_scale(39));
                }
                if (i == 1) {
                    make.top.mas_equalTo(hua_scale(8));
                    make.centerX.mas_equalTo(hua_scale(0));
                }
                if (i == 2) {
                    make.top.mas_equalTo(hua_scale(8));
                    make.right.mas_equalTo(hua_scale(-39));
                }
                if (i == 3) {
                    make.bottom.mas_equalTo(hua_scale(-22));
                    make.left.mas_equalTo(hua_scale(39));
                }
                if (i == 4) {
                    make.bottom.mas_equalTo(hua_scale(-22));
                    make.centerX.mas_equalTo(0);
                }
                if (i == 5) {
                    make.bottom.mas_equalTo(hua_scale(-22));
                    make.right.mas_equalTo(hua_scale(-39));
                }
                make.size.mas_equalTo(CGSizeMake(hua_scale(35), hua_scale(35)));
            }];
            UILabel *functionLabel = [[UILabel alloc]init];
            functionLabel.text = self.functionNames[i];
            functionLabel.textAlignment = NSTextAlignmentCenter;
            functionLabel.textColor = HUAColor(0x656565);
            functionLabel.font = [UIFont systemFontOfSize:hua_scale(10)];
            
            [self addSubview:functionLabel];
            [functionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.top.mas_equalTo(hua_scale(48));
                    make.left.mas_equalTo(hua_scale(39));
                }
                if (i == 1) {
                    make.top.mas_equalTo(hua_scale(48));
                    make.centerX.mas_equalTo(0);
                }
                if (i == 2) {
                    make.top.mas_equalTo(hua_scale(48));
                    make.right.mas_equalTo(hua_scale(-39));
                }
                if (i == 3) {
                    make.bottom.mas_equalTo(hua_scale(-8));
                    make.left.mas_equalTo(hua_scale(39));
                }
                if (i == 4) {
                    make.bottom.mas_equalTo(hua_scale(-8));
                    make.centerX.mas_equalTo(0);
                }
                if (i == 5) {
                    make.bottom.mas_equalTo(hua_scale(-8));
                    make.right.mas_equalTo(hua_scale(-39));
                }
                make.size.mas_equalTo(CGSizeMake(hua_scale(35), hua_scale(9)));
            }];
        }
    }
    return self;
}
- (void)showFunction:(UIButton *)sender {

    
    if ([self.delegate respondsToSelector:@selector(clickToJump:)]) {
        [self.delegate clickToJump:sender];
    }
   
    
}

@end
