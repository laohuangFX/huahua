//
//  HUAShopServiceViewController.m
//  Flower
//
//  Created by 程召华 on 16/2/16.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAShopServiceViewController.h"
#import "HUADataTool.h"
#import "HUAShopProductCell.h"
#import "HUAProductDetailController.h"
#import "HUAServiceDetailController.h"

@interface HUAShopServiceViewController ()<UITableViewDelegate, UITableViewDataSource,JSDropDownMenuDataSource,JSDropDownMenuDelegate>{
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    //参数
    //左边
    NSString *_leftText;
    //左边的子类
    NSString *_leftSubText;
    //中间
    NSString *_midstText;
    //右边
    NSString *_rightText;
    
    //存放产品分类id
    NSMutableDictionary *_dataDic;
}
@property (nonatomic, strong) UITableView *tableView;
/**服务id*/
@property (nonatomic, strong) NSString *service_id;
/**产品数组*/
@property (nonatomic, strong) NSMutableArray *productsArray;
/**分页数*/
@property (nonatomic, assign) NSUInteger page;
/**总页数*/
@property (nonatomic, strong) NSNumber *totalPage;
/**总数量*/
@property (nonatomic, assign) NSString *totalCount;
/**排序字典*/
@property (nonatomic, strong) NSMutableDictionary *parameters;
/**页数缓存路径*/
@property (nonatomic, strong) NSString *pagePath;
/**判断是不是第一次进入控制器*/
@property (nonatomic, assign) BOOL isFirstTime;
@end

@implementation HUAShopServiceViewController
- (NSString *)pagePath {
    if (!_pagePath) {
        _pagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"shopServicePage.plist"];
    }
    return _pagePath;
}
- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
    }
    return _parameters;
}
- (NSMutableArray *)productsArray {
    if (!_productsArray) {
        _productsArray = [NSMutableArray array];
    }
    return _productsArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, hua_scale(30), screenWidth, screenHeight-navigationBarHeight-hua_scale(30))];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HUAShopProductCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;
    self.isFirstTime = YES;
    //获取下拉菜单数据
    [self getDownData];
    _dataDic = [NSMutableDictionary dictionary];
    [self.view addSubview:self.tableView];
    self.title = self.shopName;
    
    [self setNavigationItem];
 
    self.searchplaceholder = @"搜索";
    //搜索

    //[self geDataWithSubParameters:nil];

    
    //菜单
    [self category:nil];

    // 集成下拉刷新控件
    [self setupDownRefresh];
    
}
//获取下拉菜单数据
- (void)getDownData{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSString *url = [HUA_URL stringByAppendingPathComponent:@"service/service_cat"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"shop_id"] = self.shop_id;
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation,NSDictionary* responseObject) {
        //HUALog(@"%@",responseObject);
        _data1 = [NSMutableArray array];
        
        NSArray *array = responseObject[@"info"];
        
        for (NSDictionary *dic in array) {
            
            [_dataDic setValue:dic[@"category_id"] forKey:dic[@"name"]];
            
            [_data1 addObject:@{@"title":dic[@"name"]}];
        }
        
        NSArray *noLimit = @[@"不限"];
        
        [_data1 insertObject:@{@"title":@"不限"} atIndex:0];
        
        _data2 = [NSMutableArray arrayWithObjects:@"不限", @"价格降序", @"价格升序",nil];
        _data3 = [NSMutableArray arrayWithObjects:@"不限",@"点赞降序",@"点赞升序",nil];

        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
    
}

// 集成下拉刷新控件
- (void)setupDownRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)loadNewData {
    if (self.parameters[@"parent_id"] || self.parameters[@"category_id"] || self.parameters[@"order"]) {
        [HUAMBProgress MBProgressOnlywithLabelText:@"没有更多数据了"];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    self.page = 1;
    NSString *url = self.url;
    self.parameters[@"shop_id"] = self.shop_id;
    self.parameters[@"per_page"] = @(self.page);
    [HUAHttpTool GET:url params:self.parameters success:^(id responseObject) {
        HUALog(@"%@",responseObject);
        //获取数据总个数
        if ([responseObject[@"info"] isKindOfClass:[NSString class]]) {
            
            [HUAMBProgress MBProgressOnlywithLabelText:responseObject[@"info"]];
            [self.navigationController popViewControllerAnimated:YES];
            [self.tableView.mj_header endRefreshing];
            return  ;
        }
        
        NSString *newCount = responseObject[@"info"][@"total"];
        if (self.isFirstTime == YES) {
            
        }else {
            if ([newCount isEqualToString:[NSKeyedUnarchiver unarchiveObjectWithFile:self.pagePath]]) {
                [HUAMBProgress MBProgressOnlywithLabelText:@"没有更多新的服务了"];
            }
        }
        self.totalPage = responseObject[@"info"][@"pages"];
        //保存这一次总个数
        [NSKeyedArchiver archiveRootObject:newCount toFile:self.pagePath];
        [self.productsArray removeAllObjects];
         [self.productsArray removeAllObjects];
        NSArray *array = [HUADataTool shopProduct:responseObject];
        [self.productsArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        self.isFirstTime = NO;
    } failure:^(NSError *error) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"还没有联网哦，去设置网络吧"];
        [self.tableView.mj_header endRefreshing];
    }];
}

/**cell即将到最后一个的时候自动加载数据*/
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //到达最后一页数据
    if (self.page == [self.totalPage integerValue]) {
        if (indexPath.row == self.productsArray.count-1) {
            // 集成上拉刷新控件
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        }
    }else {
        if (indexPath.row == self.productsArray.count-1) {
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
    NSString *url = self.url;
    self.parameters[@"shop_id"] = self.shop_id;
    self.parameters[@"per_page"] = @(self.page);
    [HUAHttpTool GET:url params:self.parameters success:^(id responseObject) {
        NSArray *array = [HUADataTool shopProduct:responseObject];
        [self.productsArray addObjectsFromArray:array];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
        self.page--;
    }];
}

- (void)geDataWithSubParameters:(NSDictionary *)SubParameters{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSString *url = self.url;
    self.parameters[@"per_page"] = @(self.page);
    self.parameters[@"shop_id"] = self.shop_id;
    if (SubParameters != nil) {
        [self.parameters setValuesForKeysWithDictionary:SubParameters];
    }
    NSLog(@"%@",self.parameters);
    [manager GET:url parameters:self.parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
       // NSLog(@"")
        if ([[responseObject objectForKey:@"info"] isKindOfClass:[NSString class]]) {
            [HUAMBProgress MBProgressOnlywithLabelText:[responseObject objectForKey:@"info"]];
            return ;
        }
        self.totalPage = responseObject[@"info"][@"pages"];
        [self.productsArray removeAllObjects];
        NSArray *array = [HUADataTool shopProduct:responseObject];
        [self.productsArray addObjectsFromArray:array];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
        [HUAMBProgress MBProgressOnlywithLabelText:@"请检查网络设置"];
    }];
}
#pragma --设置三个选择按钮
//设置三个选择按钮
- (void)category:(NSDictionary *)downDic {
    
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:hua_scale(30)];
    
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    //图标颜色
    menu.indicatorColor = HUAColor(0x4da800);
    menu.typeStr = @"服务菜单";
    menu.dataSource = self;
    menu.delegate = self;
    [menu setGetDataBlock:^(NSString *leftText, NSString *leftSubText, NSString *midstText, NSString *lastText) {
        
        NSLog(@"%@",leftText);
        NSLog(@"%@",leftSubText);
        NSLog(@"%@",midstText);
        NSLog(@"%@",lastText);
        
        if(leftText.length != 0){
            _leftText = leftText;
        }else if (midstText.length != 0){
            _midstText = midstText;
        }else if (lastText.length != 0 ){
            _midstText = lastText;
        }

        
//        [self.productsArray removeAllObjects];
//        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
//        NSString *url =[HUA_URL stringByAppendingPathComponent:@"service/service_list"];
//        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//                self.parameters[@"shop_id"] = self.shop_id;
//                self.parameters[@"per_page"] = @(self.page);

        if (![_leftText isEqualToString:@"不限"] && _leftText != nil) {
            self.parameters[@"category_id"] =_dataDic[_leftText];
        }
        if ([_leftText isEqualToString:@"不限"] || _leftText == nil) {
            self.parameters[@"category_id"] = nil;
        }
        if (![_midstText isEqualToString:@"不限"] && _midstText != nil) {
            if ([_midstText isEqualToString:@"价格降序"]) {
                self.parameters[@"order"] =@"price_desc";
            }else if ([_midstText isEqualToString:@"价格升序"]){
                
                self.parameters[@"order"] =@"price_asc";
            }else if ([_midstText isEqualToString:@"点赞降序"]){
                self.parameters[@"order"] =@"praise_desc";
            }else{
                self.parameters[@"order"] =@"praise_asc";
            }
        }

        if ([_midstText isEqualToString:@"不限"] && _midstText == nil) {
            self.parameters[@"order"] = nil;
        }
        self.page = 1;
        [self geDataWithSubParameters:nil];
//        NSLog(@"%@",parameters);
//        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//           // HUALog(@"%@",responseObject);
//            if ([[responseObject objectForKey:@"info"] isKindOfClass:[NSString class]]) {
//                [HUAMBProgress MBProgressOnlywithLabelText:[responseObject objectForKey:@"info"]];
//                return ;
//            }
//            NSArray *array = [HUADataTool shopProduct:responseObject];
//            [self.productsArray addObjectsFromArray:array];
//            [self.tableView reloadData];
//        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//            HUALog(@"%@",error);
//            [HUAMBProgress MBProgressOnlywithLabelText:@"请检查网络设置"];
//        }];
//
    }];

    [self.view addSubview:menu];
}


- (void)setNavigationItem {
    
    UIBarButtonItem *backButton = [UIBarButtonItem itemWithTarget:self action:@selector(backAction:) image:@"back_green" highImage:@"back_green" text:@"返回"];
    UIBarButtonItem *space = [UIBarButtonItem leftSpace:hua_scale(-10)];
    backButton.tintColor = HUAColor(0x47A300);
    self.navigationItem.leftBarButtonItems = @[space, backButton];
    
    self.navigationItem.titleView = nil;
    UIBarButtonItem *leftSpace = [UIBarButtonItem leftSpace:-30];
    UIBarButtonItem *searchBar = [UIBarButtonItem itemWithTarget:self action:@selector(search) image:@"search" highImage:@"search" text:nil];
    self.navigationItem.rightBarButtonItems = @[leftSpace, searchBar];
    
}
- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- searchTextFiled

- (void)search {
    HUALog(@"搜索");
    [self showSearchNav];
}

- (void)dismissBlackView{
    [super dismissBlackView];
    [self setNavigationItem];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0) {
        [self dismissBlackView];
    }else{
        //数据请求
        NSDictionary *subParametes = [NSDictionary dictionaryWithObject:textField.text forKey:@"search"];
        [self geDataWithSubParameters:subParametes];
        
        [self dismissBlackView];
    }
    
    
    return YES;
}

#pragma mark -- delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HUAShopProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.product = self.productsArray[indexPath.row];
    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return hua_scale(106);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HUAShopProduct *product = self.productsArray[indexPath.row];
    HUAServiceDetailController *serviceVC = [HUAServiceDetailController new];
    serviceVC.service_id = product.service_id;
    [self.navigationController pushViewController:serviceVC animated:YES];
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
}







#pragma mark -- 菜单

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

        return NO;

    }
    return NO;
}

/**
 * 表视图显示时，左边表显示比例
 */
-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==0) {
        return 1;
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


@end
