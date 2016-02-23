//
//  HUAMyOrderViewController.m
//  Flower
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#define Bill_list @"user/bill_list"
#import "HUAMyOrderViewController.h"
#import "HUAMyOrderTableViewCell.h"
#import "HUAMyOrderModel.h"
#import "HUADataTool.h"
#import "HUAProductOrderDetailsViewController.h"
#import "HUAServiceOrderDetailsViewController.h"
#import "HUAActivityOrderDetailsViewController.h"
@interface HUAMyOrderViewController ()<UITableViewDataSource,UITableViewDelegate,JSDropDownMenuDataSource,JSDropDownMenuDelegate>{
 
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
    
    //记录筛选的值
    NSDictionary *_parametersDic;


}
@property (nonatomic,strong)UITableView *tablewView;
@property (nonatomic, strong)NSMutableArray *array;
//分页
@property (nonatomic, assign)NSInteger page;

@end

@implementation HUAMyOrderViewController

- (UITableView *)tablewView {
    if (!_tablewView) {
        _tablewView = [[UITableView alloc] initWithFrame:CGRectMake(0, hua_scale(30), screenWidth, screenHeight-navigationBarHeight-hua_scale(30))];
        _tablewView.delegate = self;
        _tablewView.dataSource = self;
 
    }
    return _tablewView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tablewView];
    
    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;
    [self headDownMenu];
    [self getData:nil parametersDic:_parametersDic];
    [self refreshData];
    
  }
//下拉菜单
- (void)headDownMenu{
    
    NSArray *food = @[@"不限服务", @"未使用", @"已交易完成"];
    NSArray *travel = @[@"不限产品",@"等待发货",@"待确认收货",@"交易完成"];
    NSArray *exercise =@[@"不限活动", @"未使用", @"已使用", @"已过期"];
    NSArray *noLimit = @[@"全部"];
    _data1 = [NSMutableArray arrayWithObjects:@{@"title":@"全部", @"data":noLimit},@{@"title":@"服务",@"data":food}, @{@"title":@"产品", @"data":travel},@{@"title":@"活动", @"data":exercise},nil];
    
    _data2 = [NSMutableArray arrayWithObjects:@"全部", @"一天内", @"一周内",@"一个月内",@"三个月内",nil];
    _data3 = [NSMutableArray arrayWithObjects:@"不限",@"最少",@"最多",nil];
    
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:hua_scale(30)];
    //menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    //图标颜色
    menu.indicatorColor = HUAColor(0x4da800);
    menu.rowHeigth = 80;
    menu.typeStr = @"订单菜单";
    menu.dataSource = self;
    menu.delegate = self;
    [menu setGetDataBlock:^(NSString *text1, NSString *text2, NSString *text3, NSString *text4) {
        NSLog(@"text1%@",text1);
        NSLog(@"text2%@",text2);
        NSLog(@"text3%@",text3);
    
        
        if (text1.length != 0) {
            _leftText = text1;
            return ;
        }else if (text2.length !=0){
            _leftSubText = text2;
        }else if (text3.length !=0){
            _midstText = text3;
        }
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        NSString *url =[HUA_URL stringByAppendingPathComponent:@"user/bill_list"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
       
        if (![_leftText isEqualToString:@"全部"] && _leftText != nil) {
            if ([_leftText isEqualToString:@"产品"]) {
               parameters[@"Product_filter"] = @"1";
            }else if ([_leftText isEqualToString:@"服务"]){
               parameters[@"Product_filter"] = @"5";
            }else{
               parameters[@"Product_filter"] = @"8";
            }
        }
        if (![_leftSubText isEqualToString:@"全部"] && _leftSubText != nil) {
            if ([_leftText isEqualToString:@"服务"]) {
                if ([_leftSubText isEqualToString:@"未使用"]) {
                     parameters[@"Product_filter"] = @"6";
                }else if ([_leftSubText isEqualToString:@"不限服务"]){
                    parameters[@"Product_filter"] = @"5";
                }else{
                     parameters[@"Product_filter"] = @"7";
                }
            }else if ([_leftText isEqualToString:@"产品"]){
                if ([_leftSubText isEqualToString:@"等待发货"]) {
                    parameters[@"Product_filter"] = @"2";
                }else if([_leftSubText isEqualToString:@"待确认收货"]){
                    parameters[@"Product_filter"] = @"3";
                }else if([_leftSubText isEqualToString:@"不限产品"]){
                    parameters[@"Product_filter"] = @"1";
                }else{
                  parameters[@"Product_filter"] = @"4";
                }
            }else if ([_leftText isEqualToString:@"活动"]){
                if ([_leftSubText isEqualToString:@"未使用"]) {
                    parameters[@"Product_filter"] = @"9";
                }else if([_leftSubText isEqualToString:@"已使用"]){
                    parameters[@"Product_filter"] = @"10";
                }else if([_leftSubText isEqualToString:@"不限活动"]){
                    parameters[@"Product_filter"] = @"8";
                }else{
                    parameters[@"Product_filter"] = @"11";
                }
            }
        }
        if (![_midstText isEqualToString:@"全部"] && _midstText != nil) {
         
            if ([_midstText isEqualToString:@"一天内"]) {
                 parameters[@"Time_filter"] = @(3600*24);
            }else if ([_midstText isEqualToString:@"一周内"]){
                parameters[@"Time_filter"] = @(3600*24*7);
            }else if ([_midstText isEqualToString:@"一个月内"]){
                parameters[@"Time_filter"] = @(3600*24*30);
            }else {
                parameters[@"Time_filter"] = @(3600*24*90);
            }
        }
    
        NSLog(@"%@",parameters);
        _parametersDic = parameters;
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
          //  HUALog(@"%@",responseObject);
        
            if ([[responseObject objectForKey:@"info"] isKindOfClass:[NSString class]]) {
                [HUAMBProgress MBProgressOnlywithLabelText:[responseObject objectForKey:@"info"]];
                return ;
            }
            self.array = nil;
            self.array = [[HUADataTool MyOrder:responseObject] mutableCopy];
            
            [self.tablewView reloadData];
            self.page = 1;
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            HUALog(@"%@",error);
        }];
    
    }];
    
    [self.view addSubview:menu];
}

- (void)getData:(NSString *)Type parametersDic:(NSDictionary *)parametersDic{

    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = [HUA_URL stringByAppendingPathComponent:Bill_list];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"per_page"] = @(self.page);
    parameter[@"Product_filter"] = _parametersDic[@"Product_filter"];
    parameter[@"Time_filter"] = _parametersDic[@"Time_filter"];
    NSLog(@"%@",parameter);
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([Type isEqualToString:@"尾部"]) {
    
            NSArray *dataArray = [HUADataTool MyOrder:dic];
            
            if (self.page > [dic[@"info"][@"pages"]integerValue]) {
                [self footEnd];
                return ;
            }
            
            [self.array addObjectsFromArray:dataArray];
            [self.tablewView reloadData];
            [self.tablewView.mj_footer endRefreshing];
        }else{
        
            self.array = nil;
            self.array = [[HUADataTool MyOrder:dic] mutableCopy];
            [self.tablewView reloadData];
            [self.tablewView.mj_header endRefreshing];
        }
        
     
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
}

//下拉刷新
- (void)refreshData{
    
    self.tablewView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        //刷新数据的把页数还原
        self.page= 1;
        
        [self getData:nil parametersDic:_parametersDic];
    }];
    // 马上进入刷新状态
    [self.tablewView.mj_header beginRefreshing];
}
//上拉刷新
- (void)footRefreshData{
    
    self.page++;
    
    [self getData:@"尾部" parametersDic:_parametersDic];
    //上拉刷新
    
}
//上拉刷新
- (void)footEnd{
    
    
    self.tablewView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self.tablewView.mj_footer endRefreshingWithNoMoreData];
        
    }];
    
    [self.tablewView.mj_footer beginRefreshing];
}

//tableview
#pragma  mark ----UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"indetifierCell";
    
    HUAMyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[HUAMyOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.indexPath = indexPath;
    
    [cell setShowBlock:^(UIAlertController *alert){
        
        [self presentViewController:alert animated:YES completion:nil];

    }];
    //收货block
    [cell setGoodsBlock:^(NSIndexPath *path){
        //post请求
        HUAMyOrderModel *model = self.array[indexPath.row];
       
        NSString *token = [HUAUserDefaults getToken];
        NSLog(@"%@",model.bill_num);
      
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //申明请求的数据是json类型
        //manager.requestSerializer=[AFJSONRequestSerializer serializer];
        //如果报接受类型不一致请替换一致text/html或别的
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        //传入的参数
        NSDictionary *parameters = @{@"bill_id":model.bill_num};
        
        NSString *url = [HUA_URL stringByAppendingPathComponent:@"user/confirm_receipt"];
        NSLog(@"%@",parameters);
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            model.is_receipt = [dic[@"info"][@"is_receipt"] stringValue];
            [self.tablewView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
            NSLog(@"%@",error);
            
        }];
        
    }];
    cell.model = self.array[indexPath.row];
 
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tablewView cellHeightForIndexPath:indexPath model:self.array[indexPath.row] keyPath:@"model" cellClass:[HUAMyOrderTableViewCell class] contentViewWidth:SCREEN_WIDTH];
}
//点击跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HUAMyOrderModel *model = self.array[indexPath.row];
    if ([model.type isEqualToString:@"1"]) {
       //产品
        HUAProductOrderDetailsViewController *vc = [HUAProductOrderDetailsViewController new];
        vc.bill_num = model.bill_num;
        vc.type = model.type;
        vc.product_id = model.product_id;
        vc.is_receipt = model.is_receipt;
        vc.shop_id = model.shop_id;
        //从订单详情收货后跳转回来刷新我的订单里面的收货状态
        [vc setRefreshBlock:^(NSDictionary *dic) {
            model.is_receipt = dic[@"info"][@"is_receipt"];
            [self.tablewView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.type isEqualToString:@"2"]){
       //服务
        HUAServiceOrderDetailsViewController *vc = [HUAServiceOrderDetailsViewController new];
        vc.is_use = model.is_use;
        vc.service_id = model.service_id;
        vc.bill_id = model.bill_num;
        [self.navigationController pushViewController:vc animated:YES];
    
    }else{
        //活动
        HUAActivityOrderDetailsViewController *vc = [HUAActivityOrderDetailsViewController new];
        vc.bill_id = model.bill_num;
        vc.active_id = model.active_id;
        vc.number = model.remainNum;
        vc.shop_id = model.shop_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark --- headDownMenuDelegate
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
        case 1: return @"时间"; //_data2[0];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.array.count-2) {
        
        [self footRefreshData];
        
    }
    NSLog(@"%ld",self.page);
}
- (NSMutableArray *)array{
    if (_array==nil) {
        _array = [NSMutableArray array];
    }

    return _array;
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

