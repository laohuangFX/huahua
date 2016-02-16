//
//  HUAmodel.m
//  Flower
//
//  Created by apple on 16/1/9.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAmodel.h"

extern const CGFloat contentLabelFontSize;
extern const CGFloat maxContentLabelHeight;

@implementation HUAmodel


@synthesize shouldShowMoreButton = _shouldShowMoreButton;
@synthesize content = _content;


- (void)setContent:(NSString *)content
{
    _content = content;
}
- (NSString *)content
{
    // CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    //CGRect textRect = [_content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
    
    
    if (self.commentArray.count > 6 ) {
        _shouldShowMoreButton = YES;
    } else {
        _shouldShowMoreButton = NO;
    }
    
    return _content;
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

//动态
+ (HUAStatusModel *)status:(NSDictionary *)dictionary{
    
    NSDictionary *dic = dictionary[@"info"];
    
    HUAStatusModel *statusModel = [HUAStatusModel new];
    statusModel.essay_id = dic[@"essay_id"];
    statusModel.content =  dic[@"content"];
    statusModel.name = dic[@"shopname"];
    statusModel.time = dic[@"create_time"];
    statusModel.icon = dic[@"cover"];
    statusModel.praise = dic[@"praise_count"];
    statusModel.comment = dic[@"comment_count"];
    NSArray *imageArray = dic[@"img_list"];
    NSMutableArray *mutableImage = [NSMutableArray array];
    for (NSDictionary *imageDic in imageArray) {
        NSString * str  = imageDic[@"content"];
        [mutableImage addObject:str];
    }
    statusModel.imageArray = mutableImage;
    
    return statusModel;
}


@end
