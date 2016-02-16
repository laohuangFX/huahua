//
//  HUAChooseAddressTableViewCell.m
//  Flower
//
//  Created by apple on 16/2/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAChooseAddressTableViewCell.h"

@interface HUAChooseAddressTableViewCell (){

    UILabel *_nameLabel;
    UILabel *_phoneLabel;
    UILabel *_addressLabel;
}

@end

@implementation HUAChooseAddressTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCell];
    }
    return self;
}
- (void)setCell{

    //名字
    _nameLabel = [UILabel labelText:@"陈翔" color:nil font:hua_scale(13)];
    
    [self.contentView addSubview:_nameLabel];

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
