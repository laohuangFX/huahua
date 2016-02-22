//
//  HUStatusAViewController.m
//  Flower
//
//  Created by apple on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Essay_list @"essay/essay_list"
#import "HUStatusAViewController.h"
#import "HUDynamicATableViewCell.h"
#import "HUADynamicDetailsViewController.h"
#import "HUAStatusModel.h"
#import "HUALoginController.h"

#define Scw [UIScreen mainScreen].bounds.size.width
#define Sch [UIScreen mainScreen].bounds.size.height
@interface HUStatusAViewController ()<UITableViewDataSource,UITableViewDelegate,StatusModelDelegate>
@property(nonatomic ,strong)UITableView *tableView;
//假数据
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic, strong)NSArray *colorarray;

@property (nonatomic, assign)NSInteger page;

@property (nonatomic, strong)NSString *pathStr;
@end

@implementation HUStatusAViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *vcsArray = [self.navigationController viewControllers];
    NSInteger vcCount = vcsArray.count;
    if (vcCount == 1) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Scw, Sch-44-20-49) style:UITableViewStylePlain];
        UIImageView *logoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoIcon];
    }else {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Scw, Sch-44-20) style:UITableViewStylePlain];
    }
    //获取沙盒临时路径
    
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    self.pathStr = [path stringByAppendingPathComponent:@"array.plist"];
    
     //初始化表视图
    [self initTbaleView];
    
    
    NSArray *newPersonsArr = [NSKeyedUnarchiver unarchiveObjectWithFile:self.pathStr];
    
    self.page=1;
    
    if (newPersonsArr.count!=0) {
        
        self.array = [newPersonsArr mutableCopy];
        [self.tableView reloadData];
    }
    
    
    //刷新数据
    [self refreshData];
    
}

//下拉刷新
- (void)refreshData{
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        //刷新数据的把页数还原
        self.page= 1;
    
        [self getData:nil];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}
//上拉刷新
- (void)footRefreshData{
    
    self.page++;
    
    [self getData:@"尾部"];
     //上拉刷新
   
}
//上拉刷新
- (void)footEnd{

    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }];

    [self.tableView.mj_footer beginRefreshing];
}


- (void)initTbaleView{
    //初始化tableview
    
    //[self.tableView creatModelsWithCount:10];
    //self.tableView.estimatedRowHeight = 100;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, hua_scale(15))];
    headView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headView;
}
//- (void)viewWillAppear:(BOOL)animated{
//    [self getData:nil];
//}
//获取数据
- (void)getData:(NSString *)marker{
    //获取当前用户名
    HUAUserDetailInfo *detailInfo = [HUAUserDefaults getUserDetailInfo];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    NSString *url = [HUA_URL stringByAppendingPathComponent:Essay_list];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"shop_id"] = self.shop_id;
    parameters[@"user_id"] = detailInfo.user_id;
    parameters[@"per_page"] = @(self.page);

    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        NSString *maxPage = responseObject[@"info"][@"pages"];

        if ([marker isEqualToString:@"尾部"]) {
      
            NSArray *array = [HUADataTool status:responseObject];
            if (array.count==0) {
                if (self.page > maxPage.integerValue) {

                    [self footEnd];
                    return ;
                }
            }
            
            [self.array addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            //缓存
            [NSKeyedArchiver archiveRootObject:self.array toFile:self.pathStr];

        }else{
            if (self.array!=nil) {
                [self.array removeAllObjects];
            }
     
            self.array = [HUADataTool status:responseObject];

            HUALog(@"shop_id..%@",self.shop_id);
      
    
            [self.tableView reloadData];
          
            [self.tableView.mj_header endRefreshing];
            
            [NSKeyedArchiver archiveRootObject:[self.array copy] toFile:self.pathStr];
            
            }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
        self.page--;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    [self.tableView startAutoCellHeightWithCellClass:[HUDynamicATableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    
    
    return self.array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    //static NSString *identifier = @"cell";
    
    HUDynamicATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //设置代理
    
    if (!cell) {
        
        cell = [[HUDynamicATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    cell.delagate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //评论类型
    cell.boolType = NO;
    cell.model = self.array[indexPath.row];
       __weak typeof(self) weakSelf = self;
    //回调点赞block
    [cell setLoveBlock:^{
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        //判断是否是游客模式
        if (token==nil) {
            //判断是否是游客评论，
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登陆" message:@"游客模式下不能点赞,请先登陆!" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [weakSelf.navigationController pushViewController:[HUALoginController new] animated:YES];
                [alert removeFromParentViewController];
                
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [alert removeFromParentViewController];
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            return ;
        }

        //获取当前用户名
        HUAUserDetailInfo *detailInfo = [HUAUserDefaults getUserDetailInfo];
        
        HUAStatusModel *statusModel = self.array[indexPath.row];
        // NSLog(@"%@",statusModel.user_id);
        ;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //申明请求的数据是json类型
        //manager.requestSerializer=[AFJSONRequestSerializer serializer];
        //如果报接受类型不一致请替换一致text/html或别的
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        //传入的参数
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        NSDictionary *parameters = @{@"target":@"essay",@"id":statusModel.essay_id};
        //你的接口地址
        NSString *url= [HUA_URL stringByAppendingPathComponent:@"user/praise"];
        //发送请求
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            HUAStatusModel *model = self.array[indexPath.row];
            model.praise = [model.praise isEqualToString:@"0"]? @"1":@"0";
            model.is_praise = [model.is_praise.stringValue isEqualToString:@"1"]? @0:@1;
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.array != nil) {
        return [self.tableView cellHeightForIndexPath:indexPath model:self.array[indexPath.row] keyPath:@"model"];
    }
    return 100;
}
//点击跳转详情页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HUAStatusModel *model = self.array[indexPath.row];
    HUADynamicDetailsViewController *detailsViewC = [HUADynamicDetailsViewController new];
    detailsViewC.hidesBottomBarWhenPushed = YES;
    detailsViewC.essay_id = model.essay_id;
    detailsViewC.statusModel = model;
    
    [self.navigationController pushViewController:detailsViewC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击评论pus页面
- (void)pusView:(UIButton *)sender{
    
    HUDynamicATableViewCell *cell = (HUDynamicATableViewCell *)sender.superview.superview;
    
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    HUAStatusModel *model = self.array[index.row];
    HUADynamicDetailsViewController *detailsViewC = [HUADynamicDetailsViewController new];
    detailsViewC.hidesBottomBarWhenPushed = YES;
    detailsViewC.essay_id = model.essay_id;
    detailsViewC.statusModel = model;
    
    [self.navigationController pushViewController:detailsViewC animated:YES];
    
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
