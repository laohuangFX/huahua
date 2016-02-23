//
//  HUAMemberCardViewController.m
//  Flower
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define User_vip @"user/user_vip"
#import "HUAMemberCardViewController.h"
#import "HUAMemberCardTableViewCell.h"
#import "HUAVipShopFrontPageController.h"

@interface HUAMemberCardViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tablewView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSMutableArray *memberCardArray;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) NSInteger page;
@end

@implementation HUAMemberCardViewController

- (NSMutableArray *)memberCardArray {
    if (!_memberCardArray) {
        _memberCardArray = [NSMutableArray array];
    }
    return _memberCardArray;
}

- (UITableView *)tablewView {
    if (!_tablewView) {
        _tablewView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-navigationBarHeight)];
        _tablewView.delegate = self;
        _tablewView.dataSource = self;
        _tablewView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tablewView registerClass:[HUAMemberCardTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tablewView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"我的会员卡";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tablewView];
    
    [self refreshData];
  
}

//下拉刷新
- (void)refreshData{
    
    self.tablewView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        //刷新数据的把页数还原
        self.page= 1;
        
        [self getData:nil];
    }];
    // 马上进入刷新状态
    [self.tablewView.mj_header beginRefreshing];
}
//上拉刷新
- (void)footRefreshData{
    
    self.page++;
    
    [self getData:@"尾部"];
    //上拉刷新
    
}
//上拉刷新
- (void)footEnd{
    
    
    self.tablewView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self.tablewView.mj_footer endRefreshingWithNoMoreData];
        
    }];
    
    [self.tablewView.mj_footer beginRefreshing];
}

- (void)getData:(NSString *)indicate{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    NSString *url = [HUA_URL stringByAppendingPathComponent:User_vip];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"per_page"] = @(self.page);

    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HUALog(@"%@",responseObject);
        NSString *maxPage = responseObject[@"info"][@"pages"];

        if ([indicate isEqualToString:@"尾部"]) {
            
            NSArray *array = [[HUADataTool myMemberCardArray:responseObject] mutableCopy];
            if (self.page > maxPage.integerValue) {
                
                [self footEnd];
                return ;
            }

            [self.memberCardArray addObjectsFromArray:array];
            [self.tablewView reloadData];
        }else{
            self.memberCardArray = nil;
            self.memberCardArray = [[HUADataTool myMemberCardArray:responseObject] mutableCopy];
            self.user_id = responseObject[@"request"][@"user_id"];
            [self.tablewView reloadData];
            [self.tablewView.mj_header endRefreshing];
        }

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];


}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    [self.tablewView startAutoCellHeightWithCellClass:[HUAMemberCardTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return self.memberCardArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HUAMemberCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //self.array = @[@"jjj"];
    cell.memberCard = self.memberCardArray[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HUAMyMemberCard *myCard = self.memberCardArray[indexPath.row];
    
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
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.memberCardArray.count-2) {
        
        [self footRefreshData];
        
    }
    NSLog(@"%ld",self.page);
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

