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
@property (nonatomic, strong) NSArray *masterListArray;
@end

@implementation HUAMasterListController
- (NSArray *)masterListArray {
    if (!_masterListArray) {
        _masterListArray = [NSArray array];
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
    [self.view addSubview:self.tableView];
    self.title = self.shopName;
    //这个放第一加载、、要不然会空白;
    [self getDownData];
    
    [self setNavigationItem];
    self.searchplaceholder = @"搜索";
    [self getdataWithSubParameters:nil];
    
}
//获取下拉菜单数据
- (void)getDownData{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSString *url = [HUA_URL stringByAppendingPathComponent:@"master/master_level"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"shop_id"] = self.shop_id;
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation,NSDictionary* responseObject) {
        [self category:responseObject];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
    
}

- (void)getdataWithSubParameters:(NSDictionary *)SubParameters{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"shop_id"] = self.shop_id;
    if (SubParameters != nil) {
        [parameters setValuesForKeysWithDictionary:SubParameters];
    }
    [manager GET:self.url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HUALog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"info"] isKindOfClass:[NSString class]]) {
            [HUAMBProgress MBProgressOnlywithLabelText:[responseObject objectForKey:@"info"]];
            return ;
        }
        self.masterListArray = [HUADataTool getMasterList:responseObject];
        [self.tableView reloadData];
        HUALog(@"%lu",self.masterListArray.count);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
}

- (void)category:(NSDictionary *)downDic{
    _dataDic = [NSMutableDictionary dictionary];
    _data1 = [NSMutableArray array];
    
    NSArray *array = downDic[@"info"];
    
    for (NSDictionary *dic in array) {
        
        [_dataDic setValue:dic[@"type_id"] forKey:dic[@"name"]];
        
        [_data1 addObject:@{@"title":dic[@"name"]}];
    }
    
    [_data1 insertObject:@{@"title":@"全部"} atIndex:0];
    
    _data2 = [NSMutableArray arrayWithObjects:@"不限", @"点赞降序", @"点赞升序",nil];
    //_data3 = [NSMutableArray arrayWithObjects:@"不限",@"最少",@"最多",nil];
    
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:hua_scale(30)];
    
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    //图标颜色
    menu.indicatorColor = HUAColor(0x4da800);
    menu.typeStr = @"技师菜单";
    menu.dataSource = self;
    menu.delegate = self;
    [menu setGetDataBlock:^(NSString *leftText, NSString *leftSubText, NSString *midstText, NSString *lastText) {
        
        NSLog(@"%@",leftText);
        NSLog(@"%@",leftSubText);
        NSLog(@"%@",midstText);
        NSLog(@"%@",lastText);
        
        if(leftText.length != 0){
            _leftText = leftText;
        }else if (leftSubText.length != 0){
            _leftSubText = leftSubText;
        }else if (lastText.length != 0 ){
            _rightText = lastText;
        }
        
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSString *url =[HUA_URL stringByAppendingPathComponent:@"master/master_list"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if (![_leftText isEqualToString:@"不限"] && _leftText != nil) {
            parameters[@"type_id"] =_dataDic[_leftText];
        }
        if (![_leftSubText isEqualToString:@"不限"] && _leftSubText != nil) {
            parameters[@"order"] =[_leftSubText isEqualToString:@"点赞降序"]? @"praise_desc":@"praise_asc";
        }
        parameters[@"shop_id"] = self.shop_id;
        NSLog(@"%@",parameters);
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            HUALog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"info"] isKindOfClass:[NSString class]]) {
                [HUAMBProgress MBProgressOnlywithLabelText:[responseObject objectForKey:@"info"]];
                return ;
            }
            self.masterListArray =nil;
            self.masterListArray = [HUADataTool getMasterList:responseObject];
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            HUALog(@"%@",error);
        }];
        
        
        
    }];
    
    [self.view addSubview:menu];
    
}

- (void)setNavigationItem {
    
    
    self.navigationItem.hidesBackButton = NO;
    
    self.navigationItem.titleView = nil;
    
    UIBarButtonItem *searchBar = [UIBarButtonItem itemWithTarget:self action:@selector(search) image:@"search" highImage:@"search" text:nil];
    self.navigationItem.rightBarButtonItem = searchBar;
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
