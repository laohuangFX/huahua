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
/**店铺数组*/
@property (nonatomic, strong) NSMutableArray *shopsArray;
/**当前的页数*/
@property (nonatomic, assign) NSUInteger page;
/**商铺的可变数组*/
@property (nonatomic, assign) NSNumber *totalPage;
@end

@implementation HUAFunctionController

- (NSMutableArray *)shopsArray {
    if (!_shopsArray) {
        _shopsArray = [NSMutableArray array];
    }
    return _shopsArray;
}

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
    // 集成下拉刷新控件
    [self setupDownRefresh];
}

// 集成下拉刷新控件
- (void)setupDownRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
    //[self.tableView.mj_header beginRefreshing];
    
}

- (void)loadNewData {
    self.page++;
    if (self.page > [self.totalPage integerValue]) {
        [HUAMBProgress MBProgressOnlywithLabelText:@"没有更多数据了"];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    NSString *url = [HUA_URL stringByAppendingPathComponent:App_index];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"per_page"] = @(self.page);
    parameter[@"category_id"] = self.category_id;
    [HUAHttpTool POST:url params:parameter success:^(id responseObject) {
        HUALog(@"123%@",responseObject);
        //加载数据插入到可变数组最前面
        NSArray *shopArray = [HUADataTool homeShop:responseObject];
        [self.shopsArray insertObjects:shopArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, shopArray.count)]];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
        [self.tableView.mj_header endRefreshing];
        self.page--;
    }];
}


// 集成上拉刷新控件
//- (void)setupUpRefresh {
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//
//    [self.tableView.mj_footer beginRefreshing];
//}

//*cell即将到最后一个的时候自动加载数据
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //到达最后一页数据
    if (self.page == [self.totalPage integerValue]) {
        if (indexPath.row == self.shopsArray.count-1) {
            // 集成上拉刷新控件
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        }
    }else {
        if (indexPath.row == self.shopsArray.count-1) {
            // 自动上啦刷新
            [self loadMoreData];
        }
    }
}


- (void)loadMoreData {
    self.page++;
    if (self.page > [self.totalPage integerValue]) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    NSString *url = [HUA_URL stringByAppendingPathComponent:App_index];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"per_page"] = @(self.page);
    parameter[@"category_id"] = self.category_id;
    [HUAHttpTool POST:url params:parameter success:^(id responseObject) {
        NSArray *shopArray = [HUADataTool homeShop:responseObject];
        [self.shopsArray addObjectsFromArray:shopArray];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        self.page--;
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
    }];
}


- (void) getData {
    HUAUserDetailInfo *detailInfo = [HUAUserDefaults getUserDetailInfo];
    NSString *url = [HUA_URL stringByAppendingPathComponent:App_index];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    if (self.isSearch) {
        parameter[@"search"] = self.category_id;
    }else{
        parameter[@"category_id"] = self.category_id;
        
    }
    parameter[@"user_id"] = detailInfo.user_id;
    HUALog(@"%@",self.category_id);
    [HUAHttpTool POSTWithTokenAndUrl:url params:parameter success:^(id responseObject) {
        HUALog(@"%@,,,%@",responseObject,url);
        if ([[responseObject objectForKey:@"info"] isKindOfClass:[NSString class]]) {
            [HUAMBProgress MBProgressOnlywithLabelText:[responseObject objectForKey:@"info"]];
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
         self.totalPage = responseObject[@"info"][@"pages"];
        NSArray *array = [HUADataTool homeShop:responseObject];
        [self.shopsArray addObjectsFromArray:array];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        HUALog(@"%@",error);
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
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
