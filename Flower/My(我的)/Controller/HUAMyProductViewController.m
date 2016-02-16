//
//  HUAMyProductViewController.m
//  Flower
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Product_card @"user/user_product_card"
#import "HUAMyProductViewController.h"
#import "HUAMyProductTableViewCell.h"
#import "HUAVipShopFrontPageController.h"
#import "HUAProductCard.h"


@interface HUAMyProductViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tablewView;
@property (nonatomic, strong)NSArray *array;
@property (nonatomic, strong) NSArray *productCardArray;
@property (nonatomic, strong) NSString *user_id;
@end

@implementation HUAMyProductViewController
- (NSArray *)productCardArray {
    if (!_productCardArray) {
        _productCardArray = [NSArray array];
    }
    return _productCardArray;
}

- (UITableView *)tablewView {
    if (!_tablewView) {
        _tablewView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-navigationBarHeight)];
        _tablewView.delegate = self;
        _tablewView.dataSource = self;
        _tablewView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tablewView registerClass:[HUAMyProductTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tablewView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的产品卡";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tablewView];

    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    NSString *url = [HUA_URL stringByAppendingPathComponent:Product_card];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    //parameter[@"per_page"] = @"1";
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HUALog(@"%@",responseObject);
        self.productCardArray = [HUADataTool getProductCard:responseObject];
        self.user_id = responseObject[@"info"][@"request"][@"bpc.user_id"];
        HUALog(@"user_id%@",self.user_id);
        [self.tablewView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];

    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    [self.tablewView startAutoCellHeightWithCellClass:[HUAMyProductTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return self.productCardArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HUAMyProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //self.array = @[@"jjj"];
    cell.productCard = self.productCardArray[indexPath.row];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HUAProductCard *myCard = self.productCardArray[indexPath.row];
    
    HUAVipShopFrontPageController *shopVC = [HUAVipShopFrontPageController new];
    shopVC.shop_id = myCard.shop_id;
    shopVC.user_id = self.user_id;
   
    [self.navigationController pushViewController:shopVC animated:YES];
    [self.tablewView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.tablewView cellHeightForIndexPath:indexPath model:self.array keyPath:@"array"];
    
    return 300;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
