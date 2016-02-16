//
//  HUAFunctionController.m
//  Flower
//
//  Created by 程召华 on 16/2/1.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define App_index @"general/app_index"
#import "HUAFunctionController.h"
#import "HUAShopTableViewCell.h"
#import "HUAVipShopFrontPageController.h"

@interface HUAFunctionController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *shopsArray;
@end

@implementation HUAFunctionController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-navigationBarHeight)];
        [_tableView registerClass:[HUAShopTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = HUAColor(0xffffff);

    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.name;
    [self.view addSubview:self.tableView];
    [self getData];
}

- (void) getData {
    HUAUserDetailInfo *detailInfo = [HUAUserDefaults getUserDetailInfo];
    NSString *url = [HUA_URL stringByAppendingPathComponent:App_index];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"category_id"] = self.category_id;
    parameter[@"user_id"] = detailInfo.user_id;
    HUALog(@"%@",self.category_id);
    [HUAHttpTool POSTWithTokenAndUrl:url params:parameter success:^(id responseObject) {
        HUALog(@"%@,,,%@",responseObject,url);
        self.shopsArray = [HUADataTool homeShop:responseObject];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        HUALog(@"%@",error);
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shopsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HUAShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        //设置cell的背景颜色
    cell.backgroundColor = HUAColor(0xeeeeee);
    //设置点击cell不变颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.shopInfo = self.shopsArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HUAUserDetailInfo *detailInfo = [HUAUserDefaults getUserDetailInfo];
    HUAShopInfo *shopInfo = self.shopsArray[indexPath.row];
    HUAVipShopFrontPageController *vipFrontPageVC = [[HUAVipShopFrontPageController alloc] init];
    vipFrontPageVC.shop_id = shopInfo.shop_id;
    vipFrontPageVC.user_id = detailInfo.user_id;
    [self.navigationController pushViewController:vipFrontPageVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return hua_scale(161);
    
}

@end
