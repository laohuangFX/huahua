//
//  HUACollectViewController.m
//  Flower
//
//  Created by apple on 16/1/11.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define User_collection  @"user/user_collection"
#import "HUACollectViewController.h"
#import "HUACollectTableViewCell.h"
#import "HUAVipShopFrontPageController.h"

@interface HUACollectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tablewView;
@property (nonatomic, strong) NSArray *collectionArray;
@property (nonatomic, strong) NSString *user_id;
@end

@implementation HUACollectViewController
- (NSArray *)collectionArray {
    if (!_collectionArray) {
        _collectionArray = [NSArray array];
    }
    return _collectionArray;
}

- (UITableView *)tablewView {
    if (!_tablewView) {
        _tablewView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-navigationBarHeight)];
        _tablewView.delegate = self;
        _tablewView.showsVerticalScrollIndicator = NO;
        _tablewView.dataSource = self;
        [_tablewView registerClass:[HUACollectTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tablewView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tablewView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tablewView];

}

- (void)getData {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    HUALog(@"token%@",token);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    NSString *url = [HUA_URL stringByAppendingPathComponent:User_collection];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"per_page"] = @"1";
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HUALog(@"%@",responseObject);
        self.collectionArray = [HUADataTool collectionArray:responseObject];
        self.user_id = responseObject[@"info"][@"request"][@"user_id"];
        [self.tablewView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
       [self.tablewView startAutoCellHeightWithCellClass:[HUACollectTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return self.collectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HUACollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.myCollection = self.collectionArray[indexPath.row];
    cell.backgroundColor = HUAColor(0xdddddd);
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HUAMyCollection *myCollection = self.collectionArray[indexPath.row];
    HUALog(@"shop_id=%@,user_id=%@,shopname=%@",myCollection.shop_id,self.user_id,myCollection.shopname);

    HUAVipShopFrontPageController *shopVC = [HUAVipShopFrontPageController new];
    shopVC.shop_id = myCollection.shop_id;
    shopVC.user_id = self.user_id;
    shopVC.shopName = myCollection.shopname;
    [self.navigationController pushViewController:shopVC animated:YES];
   
    [self.tablewView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.tablewView cellHeightForIndexPath:indexPath model:self.arrar keyPath:@"array"];

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
