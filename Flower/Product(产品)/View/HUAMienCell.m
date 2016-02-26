//
//  HUAMienCell.m
//  Flower
//
//  Created by 程召华 on 16/1/18.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAMienCell.h"

@interface HUAMienCell ()

@end


@implementation HUAMienCell
- (void)setDetailInfo:(HUAMasterDetailInfo *)detailInfo {
    _detailInfo = detailInfo;
    [self.mienImageView sd_setImageWithURL:[NSURL URLWithString:detailInfo.url] placeholderImage:nil];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.mienImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(10), 0, screenWidth-hua_scale(20), hua_scale(182))];
        [self addSubview:self.mienImageView];
        self.mienImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_picture_middle"]];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
