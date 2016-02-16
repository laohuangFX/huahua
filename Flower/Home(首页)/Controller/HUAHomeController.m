//
//  HUAHomeController.m
//  huahua
//
//  Created by 程召华 on 16/1/4.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define App_index @"general/app_index"
#import "HUAHomeController.h"
#import "UIBarButtonItem+Extension.h"
#import "HUASearchBar.h"
#import "HUAShopTableViewCell.h"
#import "HUAShopInfo.h"
#import "HUAHomeHeaderView.h"
#import "HUASectionHeaderView.h"
#import "HUAHomeSortDropdownMenuController.h"
#import "HUAShopFrontPageController.h"
#import "HUAVipShopFrontPageController.h"
#import "HUAMyController.h"
#import "HUAVipShopFrontPageController.h"
#import "HUAMyController.h"
#import "HUASortView.h"
#import "HUAFunctionController.h"
#import "HUACategoryList.h"
#import "MJRefresh.h"
#import "HUASelectCityView.h"
#import "HUAGetCity.h"
#import "EmojiBool.h"

static NSString *identifier = @"cell";
@interface HUAHomeController ()<ClickDelegate, UIScrollViewDelegate,UITabBarControllerDelegate,HUASortMenuDelegate,HomeHeaderViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *shopsArray;
@property (nonatomic, strong) NSMutableArray *shopsMutableArray;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSString *order;
@property (nonatomic, strong) HUASectionHeaderView *header;
@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) UIButton *chooseCity;
@property (nonatomic, strong) HUASelectCityView *selectView;
@end

@implementation HUAHomeController
- (HUASectionHeaderView *)header {
    if (!_header) {
        _header = [[HUASectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, sortButtonHeight)];
        _header.delegate = self;
        _header.backgroundColor = HUAColor(0xF6F6F6);
    }
    return _header;
}

- (NSArray *)shopsArray {
    if (!_shopsArray) {
        _shopsArray = [NSArray array];
    }
    return _shopsArray;
}

- (NSArray *)shopsMutableArray {
    if (!_shopsMutableArray) {
        _shopsMutableArray = [NSMutableArray array];
    }
    return _shopsMutableArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置tableView没有分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tabBarController.delegate = self;
    self.page = 1;
    [self getData];
    //设置导航栏
    [self setNavigationBar];
    // 集成上拉刷新控件
    [self setupUpRefresh];
    // 集成下拉刷新控件
    [self setupDownRefresh];
    
   
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //取消地区选择
    if (self.chooseCity.selected) {
        self.chooseCity.selected = NO;
        [self.selectView dismissView];
    }
}

- (void)getData {

    NSString *url = [HUA_URL stringByAppendingPathComponent:App_index];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"order"] = self.order;
    parameter[@"per_page"] = @(self.page);
    [HUAHttpTool POST:url params:parameter success:^(id responseObject) {
        NSArray *shopArray = [HUADataTool homeShop:responseObject];
        [self.shopsMutableArray addObjectsFromArray:shopArray];
        self.shopsArray = [self.shopsMutableArray copy];
        self.categoryArray = [HUADataTool getCategoryList:responseObject];
        HUALog(@"self.shopsArray  %lu",(unsigned long)self.shopsArray.count);
        NSArray *array = [HUADataTool homeBanner:responseObject];
        HUAShopInfo *banner = array.firstObject;
        self.bannerArray = banner.bannerArr;
        [self createHeaderView:self.bannerArray];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
    }];

}
 // 集成下拉刷新控件
- (void)setupDownRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
   // [self.tableView.mj_header beginRefreshing];

}
 // 集成上拉刷新控件
- (void)setupUpRefresh {
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
   
}

- (void)loadNewData {
    self.page++;
    if (self.page > 4) {
        [HUAMBProgress MBProgressOnlywithLabelText:@"没有更多数据了"];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    NSString *url = [HUA_URL stringByAppendingPathComponent:App_index];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"order"] = self.order;
    parameter[@"per_page"] = @(self.page);
    [HUAHttpTool POST:url params:parameter success:^(id responseObject) {
        NSArray *shopArray = [HUADataTool homeShop:responseObject];
        [self.shopsMutableArray insertObjects:shopArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, shopArray.count)]];
        self.shopsArray = [self.shopsMutableArray copy];
        self.categoryArray = [HUADataTool getCategoryList:responseObject];
        HUALog(@"%@",self.categoryArray[0]);
        NSArray *array = [HUADataTool homeBanner:responseObject];
        HUAShopInfo *banner = array.firstObject;
        self.bannerArray = banner.bannerArr;
        [self createHeaderView:self.bannerArray];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
        [self.tableView.mj_header endRefreshing];
    }];

   //    [HUAHttpTool POSTWithTokenAndUrl:url params:parameter success:^(id responseObject) {
//        self.shopsArray = [HUADataTool homeShop:responseObject];
//        self.categoryArray = [HUADataTool getCategoryList:responseObject];
//        HUALog(@"%@",self.categoryArray[0]);
//        NSArray *array = [HUADataTool homeBanner:responseObject];
//        HUAShopInfo *banner = array.firstObject;
//        self.bannerArray = banner.bannerArr;
//        [self createHeaderView:self.bannerArray];
//        [self.tableView reloadData];
//        [self.tableView.mj_header endRefreshing];
//    } failure:^(NSError *error) {
//        [self.tableView.mj_header endRefreshing];
//        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
////        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
////        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
////            hud.labelText = @"请检查网络设置";
////            sleep(1);
////            dispatch_async(dispatch_get_main_queue(), ^{
////                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject] animated:YES];
////            });
////        });
//
//        HUALog(@"%@",error.userInfo[@"error"]);
//    }];
}

- (void)loadMoreData {
    self.page++;
    if (self.page > 4) {
        [HUAMBProgress MBProgressOnlywithLabelText:@"没有更多数据了"];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    NSString *url = [HUA_URL stringByAppendingPathComponent:App_index];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"order"] = self.order;
    parameter[@"per_page"] = @(self.page);
    [HUAHttpTool POST:url params:parameter success:^(id responseObject) {
        NSArray *shopArray = [HUADataTool homeShop:responseObject];
        NSMutableArray *mutabelArray = [NSMutableArray array];
        [mutabelArray addObjectsFromArray:shopArray];
        self.shopsArray = [mutabelArray copy];
        self.categoryArray = [HUADataTool getCategoryList:responseObject];
        HUALog(@"%@",self.categoryArray[0]);
        NSArray *array = [HUADataTool homeBanner:responseObject];
        HUAShopInfo *banner = array.firstObject;
        self.bannerArray = banner.bannerArr;
        [self createHeaderView:self.bannerArray];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (BOOL)tabBarController:( UITabBarController *)tabBarController shouldSelectViewController :( UIViewController *)viewController {
    HUALog(@"asdasdasd");
    if ([viewController isKindOfClass:[HUAMyController class]]) {
        return NO;
    }
    return YES;
}
//创建tableView的头部视图
- (void)createHeaderView:(NSArray *)array {
    
    HUAHomeHeaderView *headerView = [[HUAHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, hua_scale(250))];
    headerView.delegate = self;
    headerView.imagesURLStrings = array;
    headerView.backgroundColor = HUAColor(0xEAEAEA);
    self.tableView.tableHeaderView = headerView;
}

- (void)clickToChooseCategory:(UIButton *)sender {
    HUAFunctionController *functionVC = [HUAFunctionController new];
    if (sender.tag == 0) {
        functionVC.name = @"全部";
        [self.navigationController pushViewController:functionVC animated:YES];
    }else {
        for (HUACategoryList *categoryList in self.categoryArray) {
            if (![categoryList.category_id isEqualToString:[NSString stringWithFormat:@"%ld",sender.tag]]) {
                continue;
            }else {
                functionVC.name = categoryList.name;
                functionVC.category_id = categoryList.category_id;
                [self.navigationController pushViewController:functionVC animated:YES];
            }
        }
    }
}

- (UITextField *)searchBar{
    if (!_searchBar) {
        _searchBar = [UITextField textFieldWithFrame:CGRectZero image:@"search" placeholder:@"请输入商家名称"];
        _searchBar.layer.masksToBounds = YES;
        _searchBar.layer.cornerRadius = hua_scale(5);
        _searchBar.backgroundColor = HUAColor(0xeeeeee);
        _searchBar.width = hua_scale(185);
        _searchBar.height = hua_scale(22.5);
        _searchBar.delegate = self;
        _searchBar.returnKeyType = UIReturnKeySearch;
    }
    return _searchBar;
}
- (UIButton *)chooseCity{
    if (!_chooseCity) {
        _chooseCity = [UIButton buttonWithType:0];
        _chooseCity.width = 60;
        _chooseCity.height = 44;
        [_chooseCity setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [_chooseCity setImage:[UIImage imageNamed:@"select_green"] forState:UIControlStateSelected];
        [_chooseCity setTitle:@"广州市" forState:UIControlStateNormal];
        [_chooseCity setTitleColor:HUAColor(0x575757) forState:UIControlStateNormal];
        [_chooseCity setTitleColor:HUAColor(0x4da800) forState:UIControlStateSelected];
        
        _chooseCity.titleLabel.font = [UIFont systemFontOfSize:16];
        [_chooseCity addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
        _chooseCity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_chooseCity setTitleEdgeInsets:UIEdgeInsetsMake(0, -(_chooseCity.imageView.frame.size.width), 0, 0)];
        [_chooseCity setImageEdgeInsets:UIEdgeInsetsMake(0, (_chooseCity.titleLabel.frame.size.width+20), 0, 0)];
        
        
    }
    return _chooseCity;
}
- (void)setNavigationBar {
    
    self.searchBar.width = hua_scale(185);
    self.searchBar.height = hua_scale(22.5);
    self.navigationItem.titleView = self.searchBar;
    
    //设置左边的LOGO
    UIImageView *logoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoIcon.x = hua_scale(10);
    logoIcon.width = hua_scale(45);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoIcon];
    //设置右边选择城市按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.chooseCity];
}

- (void)setSearchNav{
    self.navigationItem.leftBarButtonItems = @[];
    
    self.searchBar.width = hua_scale(300.0);
    self.searchBar.height = hua_scale(22.5);
    self.navigationItem.titleView = self.searchBar;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismissBlackView)];
}

//选择城市按钮
#pragma --选择城市按钮的点击事件
- (void)chooseCity:(UIButton *)chooseCity{
    chooseCity.selected = !chooseCity.selected;
    if (chooseCity.selected == YES) {
        self.selectView = [[HUASelectCityView alloc]initWithFrame:self.view.bounds];
        self.selectView.cityArray = [HUAGetCity getCityArray];
        __block HUAHomeController * wself = self;
        self.selectView.cityBlock = ^(NSString *cityName){
            chooseCity.selected = NO;
            wself.tableView.scrollEnabled = NO;
            if (cityName.length != 0) {
                [chooseCity setTitle:cityName forState:UIControlStateNormal];
            }
            
        };
        [self.view addSubview:self.selectView];
        [self.selectView showView];
        self.tableView.scrollEnabled = NO;
        
    }else{
        [self.selectView dismissView];
        self.tableView.scrollEnabled = YES;
    }
    
    HUALog(@"....");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - textFiled delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"beginEditing");
    UIView *blackView  = [[UIView alloc]initWithFrame:self.view.bounds];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    blackView.tag = 1001;
    blackView.alpha = 0;
    [self.view addSubview:blackView];
    UITapGestureRecognizer *blackTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissBlackView)];
    [blackView addGestureRecognizer:blackTap];
    [self setSearchNav];
    
    //取消地区选择
    if (self.chooseCity.selected) {
        self.chooseCity.selected = NO;
        [self.selectView dismissView];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        blackView.alpha = 1;
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return ![EmojiBool stringContainsEmoji:string];
}


//搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length == 0) {
        [self dismissBlackView];
    }else{
        //数据请求
        HUAFunctionController *functionVC = [HUAFunctionController new];
        functionVC.name = @"搜索结果";
        functionVC.category_id = textField.text;
        functionVC.isSearch = YES;
        [self.navigationController pushViewController:functionVC animated:YES];
        [self dismissBlackView];
    }
    return YES;
}
- (void)dismissBlackView{
    
    UIView *blackView = [self.view viewWithTag:1001];
    if (blackView == nil) {
        return;
    }
    [self setNavigationBar];
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    [UIView animateWithDuration:0.5 animations:^{
        blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [blackView removeFromSuperview];
    }];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.shopsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HUAShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HUAShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //设置cell的背景颜色
    cell.backgroundColor = HUAColor(0xeeeeee);
    //设置点击cell不变颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.shopInfo = self.shopsArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HUAUserDetailInfo *detailInfo = [HUAUserDefaults getUserDetailInfo];
        HUAVipShopFrontPageController *vipFrontPageVC = [[HUAVipShopFrontPageController alloc] init];
        HUAShopInfo *shopInfo = self.shopsArray[indexPath.row];
        vipFrontPageVC.shop_id = shopInfo.shop_id;
        vipFrontPageVC.user_id = detailInfo.user_id;
        vipFrontPageVC.shopName = shopInfo.shopname;
        [self.navigationController pushViewController:vipFrontPageVC animated:YES];
    
}


//创建分区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.header;

}

- (void)clickSortButton:(UIButton *)sender {
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    if (sender.selected == YES) {
        if (self.tableView.contentOffset.y != hua_scale(250)) {
        [self.tableView setContentOffset:CGPointMake(0, hua_scale(250)) animated:YES];
            HUASortView *sortView = [[HUASortView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0) ];
            sortView.delegate = self;
            
            [window addSubview:sortView];
            [UIView animateWithDuration:0 delay:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
                sortView.frame = CGRectMake(0, 64+hua_scale(28), SCREEN_HEIGHT, 1000);
            } completion:nil];
            
        } else {
            [self.tableView setContentOffset:CGPointMake(0, hua_scale(250)) animated:YES];
            HUASortView *sortView = [[HUASortView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0) ];
            sortView.delegate = self;
            
            [window addSubview:sortView];
            [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                sortView.frame = CGRectMake(0, 64+hua_scale(28), SCREEN_HEIGHT, 1000);
            } completion:nil];
            
        }
    
    }else {
        
        for (UIView *view in [window subviews]) {
            if ([view isKindOfClass:[HUASortView class]]) {
                [view removeFromSuperview];
            }
        }
    }
}

- (void)tap:(UITapGestureRecognizer *)tap {
    UIButton * button =  [self.header viewWithTag:1000];
    button.selected = NO;
    for (UIView *view in [[[UIApplication sharedApplication].windows lastObject] subviews]) {
        if ([view isKindOfClass:[HUASortView class]]) {
            [view removeFromSuperview];
        }
    }
    
}

- (void)sortMenuDidDismiss:(UIButton *)sender {
    if (sender.tag == 10086) {
       self.order = @"bill_count_desc";
        [self getData];
        [HUAMBProgress MBProgressOnlywithLabelText: @"人气排序"];
    }
    if (sender.tag == 10087) {
        HUALog(@"点击了距离排序");
        [self.tableView reloadData];
    }
    if (sender.tag == 10088) {
        self.order = @"shopname_desc";
        [self getData];
        [HUAMBProgress MBProgressOnlywithLabelText: @"名字排序"];
    }
    
    UIButton * button =  [self.header viewWithTag:1000];
    button.selected = NO;
    
}


//分区高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return sortButtonHeight;
}
//每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return hua_scale(161);
    
}






@end
