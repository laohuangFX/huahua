//
//  HUAMasterListController.m
//  Flower
//
//  Created by 程召华 on 16/1/18.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAMasterListController.h"
#import "HUAMasterListCell.h"
#import "HUAMasterDetailController.h"
#import "HUAMasterList.h"


@interface HUAMasterListController ()<UITableViewDataSource, UITableViewDelegate,JSDropDownMenuDataSource,JSDropDownMenuDelegate>{
    NSMutableArray *_data1;
    NSMutableArray *_data2;

    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    
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
/**技师列表*/
@property (nonatomic, strong) NSMutableArray *masterListArray;
/**分页数*/
@property (nonatomic, assign) NSUInteger page;
/**总页数*/
@property (nonatomic, strong) NSNumber *totalPage;
/**总数量*/
@property (nonatomic, assign) NSString *totalCount;
/**页数缓存路径*/
@property (nonatomic, strong) NSString *pagePath;
/**排序参数*/
@property (nonatomic, strong) NSMutableDictionary *parameters;
/**判断是不是第一次进入控制器*/
@property (nonatomic, assign) BOOL isFirstTime;
@end

@implementation HUAMasterListController
- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
    }
    return _parameters;
}

- (NSString *)pagePath {
    if (!_pagePath) {
        _pagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"masterPage.plist"];
    }
    return _pagePath;
}

- (NSMutableArray *)masterListArray {
    if (!_masterListArray) {
        _masterListArray = [NSMutableArray array];
    }
    return _masterListArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, hua_scale(30), screenWidth, screenHeight-navigationBarHeight-hua_scale(30))];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HUAMasterListCell class] forCellReuseIdentifier:@"Cell"];
        _tableView.separatorInset = UIEdgeInsetsMake(0, hua_scale(10), 0, hua_scale(10));
        _tableView.separatorColor = HUAColor(0xcdcdcd);
         [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;
    self.isFirstTime = YES;
    [self.view addSubview:self.tableView];
    self.title = self.shopName;
    //这个放第一加载、、要不然会空白;
    [self getDownData];
    
    [self setNavigationItem];
    self.searchplaceholder = @"搜索";
    //搜索

    //[self getdataWithSubParameters:nil];

    //菜单
    [self category:nil];

    
    // 集成下拉刷新控件
    [self setupDownRefresh];
  
}

//获取下拉菜单数据
- (void)getDownData{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSString *url = [HUA_URL stringByAppendingPathComponent:@"master/master_level"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"shop_id"] = self.shop_id;
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation,NSDictionary* responseObject) {
       
        _dataDic = [NSMutableDictionary dictionary];
        _data1 = [NSMutableArray array];
        
        NSArray *array = responseObject[@"info"];
        
        for (NSDictionary *dic in array) {
            
            [_dataDic setValue:dic[@"type_id"] forKey:dic[@"name"]];
            
            [_data1 addObject:@{@"title":dic[@"name"]}];
        }
        
        [_data1 insertObject:@{@"title":@"全部"} atIndex:0];
        
        _data2 = [NSMutableArray arrayWithObjects:@"不限", @"点赞降序", @"点赞升序",nil];
        
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
    self.page = 1;
    if ((![_leftText isEqualToString:@"全部"] && _leftText != nil) || (![_leftSubText isEqualToString:@"不限"] && _leftSubText != nil)) {
        [HUAMBProgress MBProgressOnlywithLabelText:@"没有更多数据了"];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    NSString *url = self.url;
    self.parameters[@"shop_id"] = self.shop_id;
    self.parameters[@"per_page"] = @(self.page);
    [HUAHttpTool GET:url params:self.parameters success:^(id responseObject) {
        
        //获取数据总个数
        NSString *newCount = responseObject[@"info"][@"total"];
        if (self.isFirstTime == YES) {
            
        }else {
            if ([newCount isEqualToString:[NSKeyedUnarchiver unarchiveObjectWithFile:self.pagePath]]) {
                [HUAMBProgress MBProgressOnlywithLabelText:@"没有更多新的技师了"];
            }
        }
        self.totalPage = responseObject[@"info"][@"pages"];
        //保存这一次总个数
        [NSKeyedArchiver archiveRootObject:newCount toFile:self.pagePath];
        [self.masterListArray removeAllObjects];
        NSArray *array = [HUADataTool getMasterList:responseObject];
        [self.masterListArray  addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        self.isFirstTime = NO;
    } failure:^(NSError *error) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
        [self.tableView.mj_header endRefreshing];
        self.page--;
    }];
}

/**cell即将到最后一个的时候自动加载数据*/
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //到达最后一页数据
    if (self.page == [self.totalPage integerValue]) {
        if (indexPath.row == self.masterListArray.count-1) {
            // 集成上拉刷新控件
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        }
    }else {
        if (indexPath.row == self.masterListArray.count-1) {
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
        NSArray *array = [HUADataTool getMasterList:responseObject];
        [self.masterListArray addObjectsFromArray:array];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
        self.page--;
    }];
}


- (void)getdataWithSubParameters:(NSDictionary *)SubParameters{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    self.parameters[@"shop_id"] = self.shop_id;
    self.parameters[@"per_page"] = @(self.page);
    if (SubParameters != nil) {
        [self.parameters setValuesForKeysWithDictionary:SubParameters];
    }
    [manager GET:self.url parameters:self.parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HUALog(@"diaobaole%@",self.parameters);
        if ([[responseObject objectForKey:@"info"] isKindOfClass:[NSString class]]) {
            [HUAMBProgress MBProgressOnlywithLabelText:[responseObject objectForKey:@"info"]];
            return ;
        }
        self.totalPage = responseObject[@"info"][@"pages"];
        [self.masterListArray removeAllObjects];
        NSArray *array = [HUADataTool getMasterList:responseObject];
        [self.masterListArray addObjectsFromArray:array];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
        HUALog(@"%@",error);
    }];
}

- (void)category:(NSDictionary *)downDic{

    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:hua_scale(30)];
    
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    //图标颜色
    menu.indicatorColor = HUAColor(0x4da800);
    menu.typeStr = @"技师菜单";
    menu.dataSource = self;
    menu.delegate = self;
    [menu setGetDataBlock:^(NSString *leftText, NSString *leftSubText, NSString *midstText, NSString *lastText) {
        
        NSLog(@"leftText%@",_dataDic[_leftText]);
        NSLog(@"leftSubText%@",leftSubText);
        NSLog(@"%@",midstText);
        NSLog(@"%@",lastText);
        
        if(leftText.length != 0){
            _leftText = leftText;
        }else if (leftSubText.length != 0){
            _leftSubText = leftSubText;
        }else if (lastText.length != 0 ){
            _rightText = lastText;
        }
        
        if (![_leftText isEqualToString:@"全部"] && _leftText != nil) {
            self.parameters[@"type_id"] = _dataDic[_leftText];
        }
        if ([_leftText isEqualToString:@"全部"] || _leftText == nil) {
            self.parameters[@"type_id"] = nil;
        }
        if (![_leftSubText isEqualToString:@"不限"] && _leftSubText != nil) {
            self.parameters[@"order"] = [_leftSubText isEqualToString:@"点赞降序"]? @"praise_desc":@"praise_asc";
        }

        if ([_leftSubText isEqualToString:@"不限"] || _leftSubText == nil) {
            self.parameters[@"order"] = nil;
        }
        self.page = 1;
        [self getdataWithSubParameters:nil];
//=======
//        parameters[@"shop_id"] = self.shop_id;
//        NSLog(@"%@",parameters);
//        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            HUALog(@"%@",responseObject);
//            if ([[responseObject objectForKey:@"info"] isKindOfClass:[NSString class]]) {
//                [HUAMBProgress MBProgressOnlywithLabelText:[responseObject objectForKey:@"info"]];
//                return ;
//            }
//            self.masterListArray =  nil;
//            self.masterListArray = [[HUADataTool getMasterList:responseObject] mutableCopy];
//            [self.tableView reloadData];
//        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//            HUALog(@"%@",error);
//        }];
//
//>>>>>>> 5917a5dbd23d29ebf46f41b29762b942588c7f76
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
    self.navigationItem.rightBarButtonItems = @[leftSpace,searchBar];
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
        //数据请求
        NSDictionary *subParametes = [NSDictionary dictionaryWithObject:textField.text forKey:@"search"];
        [self getdataWithSubParameters:subParametes];
        [self dismissBlackView];
    }
    
    
    return YES;
}


#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.masterListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HUAMasterListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.masterList = self.masterListArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HUAMasterList *masterList = self.masterListArray[indexPath.row];
    HUAMasterDetailController *masterDetailVC = [HUAMasterDetailController new];
    masterDetailVC.master_id = masterList.master_id;
    masterDetailVC.shop_id = self.shop_id;
    [self.navigationController pushViewController:masterDetailVC animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return hua_scale(80);
}


//菜单个数
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 2;
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

        return _currentData2Index;

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
        
    } 
    
    return 0;
}
//初始默认菜单title
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return @"类别";//[[_data1[0] objectForKey:@"data"] objectAtIndex:0];
            break;
        case 1: return @"点赞数"; //_data2[0];
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
    } else  {
        
        return _data2[indexPath.row];
        
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        if(indexPath.leftOrRight==0){
            
            _currentData1Index = indexPath.row;
            
            return;
        }
        
    } else {
        
        _currentData2Index = indexPath.row;
        
    }
}

@end
