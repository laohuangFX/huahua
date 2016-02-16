//
//  HUAActivityTimeCell.m
//  Flower
//
//  Created by 程召华 on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAActivityTimeCell.h"
#import "HUATranslateTime.h"

@interface HUAActivityTimeCell ()
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation HUAActivityTimeCell


- (void)setTimeInfo:(HUADetailInfo *)timeInfo {
    _timeInfo = timeInfo;
    long start = timeInfo.start_time.longLongValue;
    NSString *startTime = [HUATranslateTime translateTimeIntoCurrurent:start];
    
    long end = timeInfo.end_time.longLongValue;
    NSString *endTime = [HUATranslateTime translateTimeIntoCurrurent:end];
    
    self.activityTimeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",startTime,endTime];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}

- (void)setCell {
    self.topLine = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(10), hua_scale(15), hua_scale(300), 0.5)];
    self.topLine.backgroundColor = HUAColor(0xeeeeee);
    [self addSubview:self.topLine];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(10), hua_scale(103), hua_scale(300), 0.5)];
    self.bottomLine.backgroundColor = HUAColor(0xeeeeee);
    [self addSubview:self.bottomLine];
    
    CGRect timeFrame = CGRectMake(hua_scale(10), hua_scale(68), hua_scale(200), hua_scale(10));
    self.activityTimeLabel = [UILabel labelWithFrame:timeFrame text:@"2015-08-12 至 2015-12-28" color:HUAColor(0x4da800) font:hua_scale(11)];
    [self addSubview:self.activityTimeLabel];
    
    CGRect titleFrame = CGRectMake(hua_scale(10), hua_scale(40), hua_scale(200), hua_scale(13));
    self.titleLabel = [UILabel labelWithFrame:titleFrame text:@"活动时间" color:HUAColor(0x000000) font:hua_scale(13)];
    [self addSubview:self.titleLabel];
    
    CGRect detailFrame = CGRectMake(hua_scale(10), hua_scale(129), hua_scale(200), hua_scale(13));
    self.detailLabel = [UILabel labelWithFrame:detailFrame text:@"活动详情" color:HUAColor(0x000000) font:hua_scale(13)];
    [self addSubview:self.detailLabel];
    
}









@end
