//
//  HUAChooseView.m
//  Flower
//
//  Created by 程召华 on 16/1/4.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAChooseView.h"
#import "JSDropDownMenu.h"
@interface HUAChooseView ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate>{
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
}

@end
@implementation HUAChooseView



- (id)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
         self.backgroundColor = HUAColor(0xF5F6F7);
         
         NSArray *food = @[@"不限", @"海飞丝", @"飘柔", @"清扬", @"沙宣",@"霸王"];
         NSArray *travel = @[@"不限", @"蜂花护发素", @"潘婷护发素", @"沙宣护发素", @"飘柔护发素", @"欧莱雅护发素", @"百雀羚护发素", @"迪彩护发素", @"资生堂护发素", @"露华浓护发素"];
         NSArray *noLimit = @[@"不限"];
         _data1 = [NSMutableArray arrayWithObjects:@{@"title":@"不限", @"data":noLimit},@{@"title":@"沐浴露",@"data":food}, @{@"title":@"护发素", @"data":travel}, @{@"title":@"洗面奶",@"data":food},@{@"title":@"啫喱水",@"data":travel},@{@"title":@"BB霜",@"data":food},@{@"title":@"眼霜",@"data":travel},@{@"title":@"指甲油",@"data":food},@{@"title":@"卸甲油",@"data":travel},nil];
         
         _data2 = [NSMutableArray arrayWithObjects:@"不限", @"从低到高", @"从高到低",nil];
         _data3 = [NSMutableArray arrayWithObjects:@"不限",@"最少",@"最多",nil];
         
         JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:hua_scale(30)];
         //menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
         menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
         menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
         //图标颜色
         menu.indicatorColor = HUAColor(0x4da800);
         //    //menu.separatorColor = [UIColor grayColor];
         //    menu.textColor = HUAColor(0x4da800);
         menu.dataSource = self;
         menu.delegate = self;
         
         [self addSubview:menu];

         
//         //分类按钮
//        UIButton *categoryButton = [UIButton buttonWithType:0];
//        categoryButton.frame = CGRectMake(0, 0, screenWidth/3, chooseViewHeight);
//         categoryButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
//     [categoryButton setTitle:@"类别" forState:UIControlStateNormal];
//     [categoryButton setTitleColor:HUAColor(0x00000) forState:UIControlStateNormal];
//     [categoryButton setTitleColor:HUAColor(0x4da800) forState:UIControlStateSelected];
//     [categoryButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
//     [categoryButton setImage:[UIImage imageNamed:@"select_green"] forState:UIControlStateSelected];
//     [categoryButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -90)];
//     [categoryButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
//    
//     [categoryButton addTarget:self action:@selector(categorySort:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:categoryButton];
//         
//         //价格按钮
//        UIButton *priceButton = [UIButton buttonWithType:0];
//        priceButton.frame = CGRectMake(screenWidth/3, 0, screenWidth/3, chooseViewHeight);
//        //priceButton.backgroundColor = HUAColor(0xF5F6F7);
//         priceButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
//        [priceButton setTitle:@"价格" forState:UIControlStateNormal];
//         [priceButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
//         [priceButton setImage:[UIImage imageNamed:@"select_green"] forState:UIControlStateSelected];
//        [priceButton setTitleColor:HUAColor(0x00000) forState:UIControlStateNormal];
//        [priceButton setTitleColor:HUAColor(0x4da800) forState:UIControlStateSelected];
//         [priceButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -90)];
//         [priceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
//         [priceButton addTarget:self action:@selector(priceSort:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:priceButton];
//         
//         //点赞按钮
//        UIButton *praiseButton = [UIButton buttonWithType:0];
//        praiseButton.frame = CGRectMake(screenWidth *2/3, 0, screenWidth/3, chooseViewHeight);
//        //evaluateButton.backgroundColor = HUAColor(0xF5F6F7);
//         praiseButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
//         [praiseButton setTitle:@"点赞数" forState:UIControlStateNormal];
//         [praiseButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
//         [praiseButton setImage:[UIImage imageNamed:@"select_green"] forState:UIControlStateSelected];
//         [praiseButton setTitleColor:HUAColor(0x000000) forState:UIControlStateNormal];
//         [praiseButton setTitleColor:HUAColor(0x4da800) forState:UIControlStateSelected];
//         [praiseButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -90)];
//         [praiseButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
//         [praiseButton addTarget:self action:@selector(praiseSort:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:praiseButton];
//         
//         //三个button之间的两根线
//        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(screenWidth/3-0.5, hua_scale(5), 1, hua_scale(20))];
//        lineView1.backgroundColor = HUAColor(0xDDDDDD);
//        [self addSubview:lineView1];
//        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(screenWidth*2/3-0.5, hua_scale(5), 1, hua_scale(20))];
//        lineView2.backgroundColor = HUAColor(0xDDDDDD);
//        [self addSubview:lineView2];
     }
    return self;
}
//菜单个数
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 3;
}

/**
 * 是否需要显示为UICollectionView 默认为否
 */
-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    //    if (column==2) {
    //
    //        return NO;
    //    }
    
    return NO;
}
/**
 * 表视图显示时，是否需要两个表显示
 */
-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    if (column==0) {
        return YES;
    }
    return NO;
}

/**
 * 表视图显示时，左边表显示比例
 */
-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==0) {
        return 0.5;
    }
    
    return 1;
}

//返回当前菜单左边表选中行
-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        
        return _currentData1Index;
        
    }
    if (column==1) {
        
        return _currentData2Index;
    }
    
    return _currentData3Index;
}
//返回菜单栏cell的个数
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        if (leftOrRight==0) {
            
            return _data1.count;
        } else{
            
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
    } else if (column==1){
        
        return _data2.count;
        
    } else if (column==2){
        
        return _data3.count;
    }
    
    return 0;
}
//初始默认菜单title
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return @"类别";//[[_data1[0] objectForKey:@"data"] objectAtIndex:0];
            break;
        case 1: return @"价格"; //_data2[0];
            break;
        case 2: return @"点赞数";//_data3[0];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_data1 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else{
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    } else if (indexPath.column==1) {
        
        return _data2[indexPath.row];
        
    } else {
        
        return _data3[indexPath.row];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        if(indexPath.leftOrRight==0){
            
            _currentData1Index = indexPath.row;
            
            return;
        }
        
    } else if(indexPath.column == 1){
        
        _currentData2Index = indexPath.row;
        
    } else{
        
        _currentData3Index = indexPath.row;
    }
}

//-(void)categorySort:(UIButton *)sender{
//    sender.selected = !sender.selected;
//    HUALog(@"点击了按钮");
//}
//
//-(void)priceSort:(UIButton *)sender{
//    sender.selected = !sender.selected;
//    HUALog(@"点击了按钮");
//}
//
//-(void)praiseSort:(UIButton *)sender{
//    sender.selected = !sender.selected;
//    HUALog(@"点击了按钮");
//}
//

@end
