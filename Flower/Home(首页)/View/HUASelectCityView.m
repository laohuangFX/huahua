//
//  HUASelectCityView.m
//  Flower
//
//  Created by applewoainiqwe on 16/2/3.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUASelectCityView.h"
#import "HUACityInfo.h"

typedef NS_ENUM(NSInteger, UITableViewLeftOrRight) {
    UITableViewLeft = 10,
    UITableViewRight ,
};
#define LEFT_CELL @"leftCell"
#define RIGHT_CELL @"rightCell"

@interface HUASelectCityView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *blackV;
@property (nonatomic, strong) UITableView *leftTableV;
@property (nonatomic, strong) UITableView *rightTableV;

@property (nonatomic, assign) NSInteger leftSelectIndex;
@property (nonatomic, assign) NSInteger rightSelectIndex;
@end

@implementation HUASelectCityView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init{
    if ([super init]) {
        [self setView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        [self setView];
    }
    return self;
}

- (void)setView{
    self.blackV = [[UIView alloc]initWithFrame:self.bounds];
    self.blackV.alpha = YES;
    self.blackV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDismissView)];
    [self.blackV addGestureRecognizer:tap];
    [self addSubview:self.blackV];
    
    
    self.leftTableV.frame = CGRectMake(0, 0, self.size.width/2,0);
    [self addSubview:self.leftTableV];
    
    self.rightTableV.frame = CGRectMake(self.size.width/2, 0, self.size.width/2,0);
    [self addSubview:self.rightTableV];
    self.isShow = NO;
}
#pragma mark showView
- (void)showView{
    self.isShow = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.leftTableV.frame = CGRectMake(0, 0, self.size.width/2, self.size.height/2);
        self.rightTableV.frame = CGRectMake(self.size.width/2 - 1, 0, self.size.width/2 + 1, self.size.height/2);
        self.blackV.alpha = 1;
    }];
    
    
}
- (void)tapDismissView{
    self.cityBlock(nil);
    [self dismissView];
}
- (void)dismissView{
    self.isShow = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.leftTableV.frame = CGRectMake(0, 0, self.size.width/2,0);
        self.rightTableV.frame = CGRectMake(self.size.width/2, 0, self.size.width/2,0);
        self.blackV.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == UITableViewLeft) {
        
        return self.cityArray.count;
//        if (self.cityArray.count != 0) {
//            return 1;
//        }
//        return 0;
    }else{
        return [self.cityArray[self.leftSelectIndex] childrenArray].count;
//        NSDictionary *dic = self.cityArray[self.leftSelectIndex];
//        return [[dic objectForKey:[dic allKeys][0]] count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == UITableViewLeft) {
        UITableViewCell *leftCell = [tableView dequeueReusableCellWithIdentifier:LEFT_CELL];
        if (!leftCell) {
            leftCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LEFT_CELL];
        }
        leftCell.textLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
        
        leftCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *BackgroundView = [[UIView alloc]initWithFrame:leftCell.bounds];
        BackgroundView.backgroundColor = HUAColor(0x4da800);
        leftCell.selectedBackgroundView = BackgroundView;
        leftCell.textLabel.highlightedTextColor = [UIColor whiteColor];
//        leftCell.textLabel.text = [self.cityArray[indexPath.row] allKeys][0];
//        leftCell.textLabel.text = [self.cityArray[0] mergerName];
        leftCell.textLabel.text = [self.cityArray[indexPath.row] cityName];
        return leftCell;
    }
    else
    {
        
        UITableViewCell *rightCell = [tableView dequeueReusableCellWithIdentifier:RIGHT_CELL];
        if (!rightCell) {
            rightCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RIGHT_CELL];
        }
//        NSDictionary *dic = self.cityArray[self.leftSelectIndex];
//        rightCell.textLabel.text = [[dic objectForKey:[dic allKeys][0]][indexPath.row] allKeys][0];
//        rightCell.textLabel.text = [self.cityArray[indexPath.row] cityName];
        
        rightCell.textLabel.text = [[self.cityArray[self.leftSelectIndex] childrenArray][indexPath.row] cityName];
        
        rightCell.textLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
        rightCell.backgroundColor = HUAColor(0xf2f2f2);
        UIView *BackgroundView = [[UIView alloc]initWithFrame:rightCell.bounds];
        BackgroundView.backgroundColor = HUAColor(0x49a000);
        rightCell.selectedBackgroundView = BackgroundView;
        rightCell.textLabel.highlightedTextColor = [UIColor whiteColor];

        return rightCell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == UITableViewLeft) {
        self.leftSelectIndex = indexPath.row;
        [self.rightTableV reloadData];
    }
    else
    {
        if (indexPath.row == 0) {
            self.cityBlock(self.cityArray[self.leftSelectIndex]);
        }else{
            self.cityBlock([self.cityArray[self.leftSelectIndex] childrenArray][indexPath.row]);
        }
//        self.rightSelectIndex = indexPath.row;
//        NSDictionary *dic = self.cityArray[self.leftSelectIndex];
//        self.cityBlock([[dic objectForKey:[dic allKeys][0]][indexPath.row] allKeys][0]);
        [self dismissView];
    }
}






#pragma mark Lazy loading
- (UITableView *)leftTableV{
    if (!_leftTableV) {
        _leftTableV = [[UITableView alloc]init];
        _leftTableV.delegate = self;
        _leftTableV.dataSource = self;
        _leftTableV.tag = UITableViewLeft;
        _leftTableV.showsVerticalScrollIndicator = NO;
        _leftTableV.showsHorizontalScrollIndicator = NO;
        _leftTableV.separatorInset = UIEdgeInsetsMake(0,0, 0,0);
        _leftTableV.separatorColor = HUAColor(0xd2d2d2);
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [_leftTableV selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return _leftTableV;
}

- (UITableView *)rightTableV{
    if (!_rightTableV) {
        _rightTableV = [[UITableView alloc]init];
        _rightTableV.delegate = self;
        _rightTableV.dataSource = self;
        _rightTableV.tag = UITableViewRight;
        _rightTableV.showsVerticalScrollIndicator = NO;
        _rightTableV.showsHorizontalScrollIndicator = NO;
        _rightTableV.separatorInset = UIEdgeInsetsMake(0,0, 0,0);
        _rightTableV.separatorColor = HUAColor(0xd2d2d2);
        _rightTableV.tableHeaderView = [[UIView alloc]init];
        _rightTableV.backgroundColor = HUAColor(0xf2f2f2);
    }
    return _rightTableV;
}


@end
