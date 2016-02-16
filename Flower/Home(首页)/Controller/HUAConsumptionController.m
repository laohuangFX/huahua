//
//  HUAConsumptionController.m
//  Flower
//
//  Created by 程召华 on 16/1/26.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Bill_record @"general/shop_bill_record"
#import "HUAConsumptionController.h"
#import "HUAConsumptionHeaderView.h"
#import "HUAConsumptionCell.h"

@interface HUAConsumptionController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *consumptionArray;
@end

@implementation HUAConsumptionController

- (NSArray *)consumptionArray {
    if (!_consumptionArray) {
        _consumptionArray = [NSArray array];
    }
    return _consumptionArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-navigationBarHeight)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HUAConsumptionCell class] forCellReuseIdentifier:@"cell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消费记录";
    [self.view addSubview:self.tableView];
    
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    NSString *url = [HUA_URL stringByAppendingPathComponent:Bill_record];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"shop_id"] = self.shop_id;
    parameter[@"user_id"] = self.user_id;
     HUALog(@"%@,,%@",self.shop_id,self.user_id);
    [HUAHttpTool GETWithTokenAndUrl:url params:parameter success:^(id responseObject) {
        HUALog(@"%@,,",responseObject);
        self.consumptionArray = [HUADataTool getConsumption:responseObject];
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        HUALog(@"%@",error);
    }];
}

//- (void)setHeaderView {
//    HUAConsumptionHeaderView *header = [[HUAConsumptionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, hua_scale(32))];
//    self.tableView.tableHeaderView = header;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.consumptionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HUAConsumptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.consumption = self.consumptionArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return hua_scale(45);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HUAConsumptionHeaderView *header = [[HUAConsumptionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, hua_scale(32))];
    header.backgroundColor = HUAColor(0xffffff);
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return hua_scale(32);
}
@end
