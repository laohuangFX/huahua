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
@property (nonatomic,strong)NSArray *array;
@property (nonatomic, strong)NSArray *colorarray;



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
    
    
    [self initTbaleView];
    //获取数据
    [self getData];
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
- (void)viewWillAppear:(BOOL)animated{
    [self getData];
}
//获取数据
- (void)getData{
    //获取当前用户名
    HUAUserDetailInfo *detailInfo = [HUAUserDefaults getUserDetailInfo];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    NSString *url = [HUA_URL stringByAppendingPathComponent:Essay_list];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"shop_id"] = self.shop_id;
    parameters[@"user_id"] = detailInfo.user_id;
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        self.array = [HUADataTool status:responseObject];
        HUALog(@"shop_id..%@",self.shop_id);
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
        
    }];
    
    //    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //    //manager.responseSerializer = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    //    //NSURL *URL = [NSURL URLWithString:@"http://120.24.182.25/huahua_api/index.php/essay/essay_list"];
    //    //NSURL *URL = [NSURL URLWithString:@"http://192.168.8.55/huahua_api/index.php/essay/essay_list"];
    //    NSString *string = [NSString stringWithFormat:@"http://192.168.8.142/huahua_api/index.php/essay/essay_list?shop_id=%@",self.shop_id];
    //    NSURL *URL = [NSURL URLWithString:string];
    //
    //    HUALog(@"%@",self.shop_id);
    //    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //
    //    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    //        if (error) {
    //            NSLog(@"Error: %@", error);
    //        } else {
    //
    //            self.array = [HUADataTool status:responseObject];
    //
    //
    //            [self.tableView reloadData];
    //        }
    //    }];
    //    [dataTask resume];
    
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
    
    //回调点赞block
    [cell setLoveBlock:^{
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        //判断是否是游客模式
        if (token==nil) {
            //判断是否是游客评论，
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登陆" message:@"游客模式下不能点赞,请先登陆!" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController= [[HUALoginController alloc] init];
                
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
        // manager.requestSerializer=[AFJSONRequestSerializer serializer];
        //如果报接受类型不一致请替换一致text/html或别的
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        //传入的参数
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        NSDictionary *parameters = @{@"target":@"essay",@"id":statusModel.essay_id,@"user_id":detailInfo.user_id};
        //你的接口地址
        
        NSString *url= [HUA_URL stringByAppendingPathComponent:@"user/praise"];
        //发送请求
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            [self getData];
            
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
    
    //    HUADetailsViewController *detailsViewC = [[HUADetailsViewController alloc] init];
    //    detailsViewC.hidesBottomBarWhenPushed = YES;
    //
    //    //detailsViewC.statusModel = self.array[indexPath.row];
    //
    //    [self.navigationController pushViewController:detailsViewC animated:YES];
    //
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
