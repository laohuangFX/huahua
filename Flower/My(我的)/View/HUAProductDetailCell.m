//
//  HUAProductDetailCell.m
//  Flower
//
//  Created by 程召华 on 16/2/2.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAProductDetailCell.h"

@interface HUAProductDetailCell ()

@end


@implementation HUAProductDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.productImageView = [[UIImageView alloc] init];
        self.productImageView.frame = CGRectMake(hua_scale(10), 0, screenWidth-hua_scale(20), hua_scale(191));
        self.productImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_picture_middle"]];
        [self addSubview:self.productImageView];
    }
    return self;
}

@end
