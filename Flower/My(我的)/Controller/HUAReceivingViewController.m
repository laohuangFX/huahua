//
//  HUAReceivingViewController.m
//  Flower
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAReceivingViewController.h"
#import "HUAAddReceivingViewController.h"
#import "HUAEditAddressViewController.h"
#import "HUAAddressModel.h"
@interface HUAReceivingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tablewView;
@property (nonatomic, strong)NSMutableArray *ReceivingArrar;
@end

@implementation HUAReceivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _ReceivingArrar = [NSMutableArray array];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:HUAColor(0x4da800) forState:0];
    [button setTitle:@"新增" forState:0];
    //button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 30);
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self getData];
    
   

}
- (void)getData{

    NSString *strURL = @"user/shopping_addr";
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
     NSString *url = [HUA_URL stringByAppendingPathComponent:strURL];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];

    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 6 ) {
            //为空就返回
            self.ReceivingArrar = nil;
            [self.tablewView reloadData];
            return ;
        }
        
        self.ReceivingArrar = [[HUADataTool addressJson:responseObject] mutableCopy];
        
        [self setTableView];
        
        [self.tablewView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
}
- (void)setTableView{
 
    
    self.tablewView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.tablewView.delegate = self;
    self.tablewView.dataSource = self;
    [self setExtraCellLineHidden:self.tablewView];
    [self.view addSubview:self.tablewView];
    [self.tablewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.ReceivingArrar.count;
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *identifier  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
 
    HUAAddressModel *model = self.ReceivingArrar[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",model.name,model.phone];
    cell.detailTextLabel.text =model.address;
    
    cell.textLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
    cell.detailTextLabel.textColor = HUAColor(0x888888);
   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //编辑地址
    HUAEditAddressViewController *vc = [HUAEditAddressViewController new];
    vc.model = self.ReceivingArrar[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    vc.addressDic = _ReceivingArrar[indexPath.row];
    
    //删除地址block
    vc.remoerBlock = ^(NSString *infoAddr_id){

        NSString *token = [HUAUserDefaults getToken];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //申明请求的数据是json类型
         //manager.requestSerializer=[AFJSONRequestSerializer serializer];
        //如果报接受类型不一致请替换一致text/html或别的
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        //传入的参数
        NSDictionary *parameters = @{@"addr_id":infoAddr_id};
         NSString *url = [HUA_URL stringByAppendingPathComponent:@"user/delete_shopping_addr"];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [HUAMBProgress MBProgressFromWindowWithLabelText:@"删除成功!"];
            [self getData];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSLog(@"%@",dic);
            //刷新cell
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
            NSLog(@"%@",error);
        }];
    };
    
    
    
    
    //修改地址的block语句
    vc.infoBlock = ^(NSDictionary *inFotextDic){

        //post 请求
        
        NSString *token = [HUAUserDefaults getToken];
        HUALog(@"token:%@",token);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //申明请求的数据是json类型
        // manager.requestSerializer=[AFJSONRequestSerializer serializer];
        //如果报接受类型不一致请替换一致text/html或别的
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        //传入的参数
        NSDictionary *parameters = @{@"addr_id":inFotextDic[@"addr_id"],@"consignee":inFotextDic[@"consignee"],@"consignee_phone":inFotextDic[@"consignee_phone"],@"province":inFotextDic[@"province"],@"city":inFotextDic[@"city"],@"region":inFotextDic[@"region"],@"address":inFotextDic[@"address"]};
        
        [manager POST:[HUA_URL stringByAppendingPathComponent:@"user/update_shopping_addr"] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            //刷新cell
            [HUAMBProgress MBProgressFromWindowWithLabelText:@"修改成功!"];
            [self getData];
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
            NSLog(@"%@",error);
          
            //[self getData];
            
        }];
  
    };
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;

}

//新增地址按钮点击事件
- (void)click:(UIButton *)button{

    HUAAddReceivingViewController *vc = [HUAAddReceivingViewController new];
    vc.hidesBottomBarWhenPushed = YES;

    //调用回调block
    vc.inFoBlock = ^(NSArray *InFotext){
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"添加成功!"];
        [self getData];
      
    };
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
