//
//  HUAHomeController.m
//  huahua
//
//  Created by 程召华 on 16/1/4.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define sortViewHeight  (64+hua_scale(28))

#define App_index @"general/app_index"
#import "HUAHomeController.h"
#import "UIBarButtonItem+Extension.h"
#import "HUASearchBar.h"
#import "HUAShopTableViewCell.h"
#import "HUAShopInfo.h"
#import "HUAHomeHeaderView.h"
#import "HUASectionHeaderView.h"
#import "HUAVipShopFrontPageController.h"
#import "HUAMyController.h"
#import "HUASortView.h"
#import "HUAFunctionController.h"
#import "HUACategoryList.h"
#import "MJRefresh.h"
#import "HUASelectCityView.h"
#import "HUAGetCity.h"
#import "EmojiBool.h"
#import <CoreLocation/CoreLocation.h>

static NSString *identifier = @"cell";

@interface HUAHomeController ()<ClickDelegate, UIScrollViewDelegate,UITabBarControllerDelegate,HUASortMenuDelegate,HomeHeaderViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate>

/**商铺的可变数组*/
@property (nonatomic, strong) NSMutableArray *shopsArray;
/**头部滚动视图的数组*/
@property (nonatomic, strong) NSArray *bannerArray;
/**分类的数组*/
@property (nonatomic, strong) NSArray *categoryArray;
/**排序*/
@property (nonatomic, strong) NSString *order;
/**自定义头部view*/
@property (nonatomic, strong) HUASectionHeaderView *header;
/**自定义的排序view*/
@property (nonatomic, strong) HUASortView *sortView;
/**自定义的搜索bar*/
@property (nonatomic, strong) UITextField *searchBar;
/**城市选择*/
@property (nonatomic, strong) UIButton *chooseCity;
/**自定义城市选择view*/
@property (nonatomic, strong) HUASelectCityView *selectView;
/**当前的页数*/
@property (nonatomic, assign) NSUInteger page;
/**总页数*/
@property (nonatomic, assign) NSNumber *totalPage;
/**总数量*/
@property (nonatomic, assign) NSString *totalCount;
/**页数缓存路径*/
@property (nonatomic, strong) NSString *pagePath;
/**缓存路径*/
@property (nonatomic, strong) NSString *homePath;

@property (nonatomic, strong) CLLocationManager * mgr;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoord;
@property (nonatomic, strong) NSString *currentCity;

@end

@implementation HUAHomeController
- (NSString *)pagePath {
    if (!_pagePath) {
        _pagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"page.plist"];
    }
    return _pagePath;
}

- (NSString *)homePath {
    if (!_homePath) {
        _homePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"home.plist"];
    }
    return _homePath;
}

- (HUASortView *)sortView {
    if (!_sortView) {
        _sortView = [[HUASortView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, screenHeight-sortViewHeight) ];
        _sortView.delegate = self;
    }
    return _sortView;
}

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
        _shopsArray = [NSMutableArray array];
    }
    return _shopsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置tableView没有分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
    self.tabBarController.delegate = self;
    self.page = 1;
    
    //[self getData];
    //设置导航栏
    [self setNavigationBar];
    
    // 集成下拉刷新控件
    [self setupDownRefresh];

    //定位
    [self getAddress];
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
    
    if (kNetworkNotReachability == YES) {
        HUALog(@"meiyou");
    }else {
        HUALog(@"you");
    }
    
    NSString *url = [HUA_URL stringByAppendingPathComponent:App_index];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"order"] = self.order;
    parameter[@"per_page"] = @(self.page);
    [HUAHttpTool POST:url params:parameter success:^(id responseObject) {
        self.totalCount = responseObject[@"info"][@"total"];
        self.totalPage = responseObject[@"info"][@"pages"];
        NSArray *shopArray = [HUADataTool homeShop:responseObject];
        [self.shopsArray addObjectsFromArray:shopArray];
        self.categoryArray = [HUADataTool getCategoryList:responseObject];
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
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)loadNewData {
    if (kNetworkNotReachability == YES) {
       [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    if (self.order) {
        [HUAMBProgress MBProgressOnlywithLabelText:@"没有更多数据了"];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    self.page=1;
    NSString *url = [HUA_URL stringByAppendingPathComponent:App_index];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"order"] = self.order;
    parameter[@"per_page"] = @(self.page);
    [HUAHttpTool POST:url params:parameter success:^(id responseObject) {
        HUALog(@"123%@",responseObject);
        //加载数据插入到可变数组最前面
        NSString *newCount = responseObject[@"info"][@"total"];
        [NSKeyedArchiver archiveRootObject:newCount toFile:self.pagePath];
        if ([newCount isEqualToString:[NSKeyedUnarchiver unarchiveObjectWithFile:self.pagePath]]) {
            [HUAMBProgress MBProgressOnlywithLabelText:@"没有更多新的商户了"];
        }
        [self.shopsArray removeAllObjects];
        NSArray *shopArray = [HUADataTool homeShop:responseObject];
        [self.shopsArray addObjectsFromArray:shopArray];
        self.categoryArray = [HUADataTool getCategoryList:responseObject];
        NSArray *array = [HUADataTool homeBanner:responseObject];
        HUAShopInfo *banner = array.firstObject;
        self.bannerArray = banner.bannerArr;
        [self createHeaderView:self.bannerArray];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        
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
//        if (indexPath.row == self.shopsArray.count-1) {
            // 集成上拉刷新控件
           self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
       // }
    }else {
        if (indexPath.row == self.shopsArray.count-1) {
            // 自动上啦刷新
            [self loadMoreData];
//            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//            [self.tableView.mj_footer beginRefreshing];
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
    parameter[@"order"] = self.order;
    parameter[@"per_page"] = @(self.page);
    [HUAHttpTool POST:url params:parameter success:^(id responseObject) {
        NSArray *shopArray = [HUADataTool homeShop:responseObject];
        [self.shopsArray addObjectsFromArray:shopArray];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        self.page--;
        [self.tableView.mj_footer endRefreshingWithNoNoHTTP];
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
    }];
}

- (BOOL)tabBarController:( UITabBarController *)tabBarController shouldSelectViewController :( UIViewController *)viewController {
    
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
        _chooseCity.backgroundColor = HUAColor(0x4da800);
        _chooseCity.width = 60;
        _chooseCity.height = 44;
        [_chooseCity setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [_chooseCity setImage:[UIImage imageNamed:@"select_green"] forState:UIControlStateSelected];
       
        [_chooseCity setTitle: [[NSUserDefaults standardUserDefaults]objectForKey:@"currentCity"] forState:UIControlStateNormal];
        [_chooseCity setTitleColor:HUAColor(0x575757) forState:UIControlStateNormal];
        [_chooseCity setTitleColor:HUAColor(0x4da800) forState:UIControlStateSelected];
        
        _chooseCity.titleLabel.font = [UIFont systemFontOfSize:hua_scale(10)];
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
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.chooseCity]];

}

- (void)setSearchNav{
    self.tableView.scrollEnabled = NO;
    self.navigationItem.leftBarButtonItems = @[];
    
    self.searchBar.width = hua_scale(300.0);
    self.searchBar.height = hua_scale(22.5);
    self.navigationItem.titleView = self.searchBar;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismissBlackView)];
}

//选择城市按钮
#pragma --选择城市按钮的点击事件
- (void)chooseCity:(UIButton *)chooseCity{

    UIButton * button =  [self.header viewWithTag:1000];
    button.selected = NO;
    self.sortView.y = screenHeight;
     [self.sortView removeFromSuperview];
    
    chooseCity.selected = !chooseCity.selected;
    if (chooseCity.selected == YES) {
        self.selectView = [[HUASelectCityView alloc]initWithFrame:self.view.bounds];
        self.selectView.cityArray = [HUAGetCity getCityArray];
        __block HUAHomeController * wself = self;
        self.selectView.cityBlock = ^(NSString *cityName){
            chooseCity.selected = NO;
            wself.tableView.scrollEnabled = YES;
            if (cityName.length != 0) {
                wself.currentCity = cityName;
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
#pragma mark - textFiled delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    UIButton * button =  [self.header viewWithTag:1000];
    button.selected = NO;
    self.sortView.y = screenHeight;
    [self.sortView removeFromSuperview];
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
    self.tableView.scrollEnabled = YES;
    UIView *blackView = [self.view viewWithTag:1001];
    if (blackView == nil) {
        return;
    }
    [self setNavigationBar];
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    [UIView animateWithDuration:0.5 animations:^{
        blackView.alpha = 0.5;
    } completion:^(BOOL finished) {
        [blackView removeFromSuperview];
    }];
}

#pragma mark 定位
- (void)setCurrentCity:(NSString *)currentCity{
    _currentCity = currentCity;
    NSUserDefaults *userD  = [NSUserDefaults standardUserDefaults];
    [userD setObject:currentCity forKey:@"currentCity"];
    self.currentCoord = [self getCoord:currentCity];
    
}
- (CLLocationCoordinate2D)getCoord:(NSString *)city{
//    NSString *oreillyAddress = @"1005 Gravenstein Highway North, Sebastopol, CA 95472, USA";
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    __block CLLocationCoordinate2D coord;
    [myGeocoder geocodeAddressString:city completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            coord = firstPlacemark.location.coordinate;
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }  
    }];
    return coord;
}
- (void)getAddress{
    self.mgr = [[CLLocationManager alloc]init];
    self.mgr.delegate = self;
    //用于判断当前是ios7.0还是ios8.0
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        //NSLocationAlwaysUsageDescription   允许在前后台都可以授权
//        NSLocationWhenInUseUsageDescription   允许在前台授权
        //手动授权
        
//        主动请求前后台授权
        [self.mgr requestAlwaysAuthorization];
        
        //主动请求前台授权
//                [self.mgr requestWhenInUseAuthorization];
    }else {
        [self.mgr startUpdatingLocation];
    }

}
//判断授权状态
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        //开启定位
        [self.mgr startUpdatingLocation];
        // 定位的精确度
        self.mgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//        //每隔一点距离定位一次 （单位：米）
//        self.mgr.distanceFilter = 10;
    }
    
}
//获取定位的位置信息
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"%@",locations);
    //获取我当前的位置
    CLLocation *location = [locations lastObject];
    
    //当前经纬度
    self.currentCoord  = location.coordinate;
    NSLog(@" **************** coord.x = %f,coord.y = %f ",self.currentCoord.latitude,self.currentCoord.longitude);
    //地理反编码
    //创建反编码对象
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    //调用方法，使用位置反编码对象获取位置信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *place in placemarks) {
            NSLog(@" **************** name = %@,thorough = %@ ,locality = %@",place.name,place.thoroughfare,place.locality);
            [_chooseCity setTitle:place.locality forState:UIControlStateNormal];
            _chooseCity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_chooseCity setTitleEdgeInsets:UIEdgeInsetsMake(0, -(_chooseCity.imageView.frame.size.width), 0, 0)];
            [_chooseCity setImageEdgeInsets:UIEdgeInsetsMake(0, (_chooseCity.titleLabel.frame.size.width+20), 0, 0)];
        }
    }];
    
    //停止定位
     [self.mgr stopUpdatingLocation];
}

/*
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
*/

#pragma mark --- 创建分区头视图
//创建分区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.header;
    
}

- (void)clickSortButton:(UIButton *)sender {
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    if (sender.selected == YES) {
        if (self.tableView.contentOffset.y < hua_scale(250)) {
            [self.tableView setContentOffset:CGPointMake(0, hua_scale(250)) animated:YES];
            [window addSubview:self.sortView];
            [UIView animateWithDuration:0 delay:0.4 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.sortView.y = sortViewHeight;
                
            } completion:nil];
            
        } else {
            [self.tableView setContentOffset:CGPointMake(0, hua_scale(250)) animated:YES];
            [window addSubview:self.sortView];
            [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.sortView.y = sortViewHeight;
            } completion:nil];
        
        }
    }else {
        self.sortView.y = screenHeight;
        [self.sortView removeFromSuperview];
        
    }
}



- (void)sortMenuDidDismiss:(HUASortViewButtonType)buttonType {

    switch (buttonType) {
        case HUASortViewButtonTypePopularity:
            self.order = @"bill_count_desc";
            [HUAMBProgress MBProgressOnlywithLabelText: @"人气排序"];
            break;
        case HUASortViewButtonTypeDistance:
            
            break;
        case HUASortViewButtonTypeShopName:
            self.order = @"shopname_desc";
            [HUAMBProgress MBProgressOnlywithLabelText: @"名字排序"];
            break;

    }
    [self.shopsArray removeAllObjects];
    self.page = 1;
    [self getData];
    UIButton * button =  [self.header viewWithTag:1000];
    button.selected = NO;
    self.sortView.y = screenHeight;
    [self.sortView removeFromSuperview];
    
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
    vipFrontPageVC.block  = ^(NSUInteger prase_count){
        shopInfo.praise_count = [NSString stringWithFormat:@"%lu",(unsigned long)prase_count];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vipFrontPageVC animated:YES];
    
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
