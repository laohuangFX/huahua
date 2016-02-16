//
//  HUAShopProductController.m
//  Flower
//
//  Created by 程召华 on 16/1/13.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAShopProductController.h"
#import "HUADataTool.h"
#import "HUAShopProductCell.h"
#import "HUAProductDetailController.h"
#import "HUAServiceDetailController.h"
@interface HUAShopProductController ()<UITableViewDelegate, UITableViewDataSource,JSDropDownMenuDataSource,JSDropDownMenuDelegate>{
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *productsArray;
@property (nonatomic, strong) NSString *service_id;
@end

@implementation HUAShopProductController

- (NSArray *)productsArray {
    if (!_productsArray) {
        _productsArray = [NSArray array];
    }
    return _productsArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, hua_scale(30), screenWidth, screenHeight-navigationBarHeight-hua_scale(30))];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HUAShopProductCell class] forCellReuseIdentifier:@"cell"];
 
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //获取下拉菜单数据
    [self getDownData];
    
    [self.view addSubview:self.tableView];
    self.title = self.shopName;
    [self setNavigationItem];
    
    self.searchplaceholder = @"搜索";
    
    [self geDataWithSubParameters:nil];
    
}
 //获取下拉菜单数据
- (void)getDownData{

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSString *url = [HUA_URL stringByAppendingPathComponent:@"product/product_cat"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"shop_id"] = self.shop_id;
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation,NSDictionary* responseObject) {
        //HUALog(@"%@",responseObject);
        [self category:responseObject];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];


}
- (void)geDataWithSubParameters:(NSDictionary *)SubParameters{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSString *url = self.url;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"shop_id"] = self.shop_id;
    if (SubParameters != nil) {
        [parameters setValuesForKeysWithDictionary:SubParameters];
    }
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HUALog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"info"] isKindOfClass:[NSString class]]) {
            [HUAMBProgress MBProgressOnlywithLabelText:[responseObject objectForKey:@"info"]];
            return ;
        }
        self.productsArray = [HUADataTool shopProduct:responseObject];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
    
}
#pragma --设置三个选择按钮
//设置三个选择按钮
- (void)category:(NSDictionary *)titelDic{
    
    NSMutableArray *food= [NSMutableArray array];
    NSMutableArray *travel = [NSMutableArray array];
    
//    NSArray *food = @[@"不限", @"海飞丝", @"飘柔", @"清扬", @"沙宣",@"霸王"];
//    NSArray *travel = @[@"不限", @"蜂花护发素", @"潘婷护发素", @"沙宣护发素", @"飘柔护发素", @"欧莱雅护发素", @"百雀羚护发素", @"迪彩护发素", @"资生堂护发素", @"露华浓护发素"];
    NSArray *noLimit = @[@"不限"];
    
    _data1 = [NSMutableArray array];
   
    for (int i=0; i<[titelDic[@"info"] count]+1; i++) {
        if (i==0) {
            [_data1 addObject:@{@"title":@"不限",@"data":noLimit}];
        }else{
            NSMutableArray *array = [NSMutableArray array];
            
            for (int y = 0; y< [titelDic[@"info"][i-1][@"sub"] count]+1; y++) {
                if (y==0){
                    [array addObject:@"不限"];
                }else{
                    [array addObject:titelDic[@"info"][i-1][@"sub"][y-1][@"name"]];
                    //[array insertObject:titelDic[@"info"][i-1][@"sub"][y-1][@"name"] atIndex:y];
                }
            }
            [food addObject:titelDic[@"info"][i-1][@"name"]];
            [_data1 insertObject:@{@"title":food[i-1],@"data":array} atIndex:i];

        }
    }
    
    //_data1 = [NSMutableArray arrayWithObjects:@{@"title":@"不限", @"data":noLimit},@{@"title":@"沐浴露",@"data":food}, @{@"title":@"护发素", @"data":travel}, @{@"title":@"洗面奶",@"data":food},@{@"title":@"啫喱水",@"data":travel},@{@"title":@"BB霜",@"data":food},@{@"title":@"眼霜",@"data":travel},@{@"title":@"指甲油",@"data":food},@{@"title":@"卸甲油",@"data":travel},nil];
    NSLog(@"%@",_data1);
    _data2 = [NSMutableArray arrayWithObjects:@"不限", @"从低到高", @"从高到低",nil];
    _data3 = [NSMutableArray arrayWithObjects:@"不限",@"最少",@"最多",nil];
    
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:hua_scale(30)];

    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    //图标颜色
    menu.indicatorColor = HUAColor(0x4da800);

    menu.dataSource = self;
    menu.delegate = self;
    
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
    if (product.service_id == nil) {
        HUAProductDetailController *productVC = [HUAProductDetailController new];
        productVC.product_id = product.product_id;
        productVC.shop_id = self.shop_id;
        [self.navigationController pushViewController:productVC animated:YES];
    } else if (product.service_id != nil) {
        HUAServiceDetailController *serviceVC = [HUAServiceDetailController new];
        serviceVC.service_id = product.service_id;
        [self.navigationController pushViewController:serviceVC animated:YES];
    }
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
        return YES;
    }
    return NO;
}

/**
 * 表视图显示时，左边表显示比例
 */
-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==0) {
        return 0.5;
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
