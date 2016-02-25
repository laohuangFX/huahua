//
//  HUAMyController.m
//  Flower
//
//  Created by 程召华 on 16/1/7.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define User_home  @"user/user_home"
#import "HUAMyController.h"
#import "HUAHeadCell.h"
#import "HUALoginController.h"
#import "HUACollectViewController.h"
#import "HUAMyProductViewController.h"
#import "HUAMemberCardViewController.h"
#import "HUAMyOrderViewController.h"
#import "HUAMyInformationViewController.h"
#import "HUAUserDetailInfo.h"
#import "HUAModifyPasswordController.h"
#import "HUAForgetPasswordController.h"
@interface HUAMyController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

//生日
@property (nonatomic, strong)NSString *birthString;
//个人信息
@property (nonatomic, strong)NSDictionary *userDic;
@end

@implementation HUAMyController

static NSString * const identifier = @"head";

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-navigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HUAHeadCell class] forCellReuseIdentifier:identifier];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.separatorInset = UIEdgeInsetsMake(0, hua_scale(15), 0, hua_scale(15));
        _tableView.separatorColor = HUAColor(0xBCBAC1);
        _tableView.bounces = NO;
        
    }
    return _tableView;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:viewController animated:animated];
}

//- (void)viewWillAppear:(BOOL)animated {
//    self.tabBarController.tabBar.hidden = NO;
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    HUALog(@"%@",token);
//       if (!token) {
//        
//        HUALoginController *loginVC = [[HUALoginController alloc] init];
//        [self.navigationController pushViewController:loginVC animated:NO];
//    }
//    [self.tableView reloadData];
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self getData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(poptoRoot) name:@"popCenter" object:nil];
}
- (void)poptoRoot{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)getData {
    NSString *token = [HUAUserDefaults getToken];
    HUALog(@"token:%@",token);
    if (!token) {
        HUALoginController *loginVC = [[HUALoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:NO];
        self.tabBarController.tabBar.hidden = NO;
    }
    HUAUserDetailInfo *detailInfo = [HUAUserDefaults getUserDetailInfo];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    NSString *url = [HUA_URL stringByAppendingPathComponent:User_home];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"user_id"] = detailInfo.user_id;
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HUALog(@"token返回%@",responseObject);

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        self.userDic = dic;
        self.birthString = dic[@"info"][@"birth"];
        [self.tableView reloadData];
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        HUALog(@"%@",string);
        
        NSLog(@"%@",dic);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }   else if (section == 1) {
        return 4;
    } else {
        return 2;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HUAHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
        HUAUserDetailInfo *detailInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        HUALog(@"nick%@",detailInfo.nickname);
        //cell.nameLabel.text = [detailInfo.nickname isEqualToString:@""]?detailInfo.phone:detailInfo.nickname;
        cell.nameLabel.text = self.userDic[@"info"][@"nickname"];
        cell.sexLabel.text = [detailInfo.sex isEqualToString:@"1"]?@"男":@"女";
        if (detailInfo.headicon != nil && ![detailInfo.headicon isKindOfClass:[NSNull class]]) {
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:detailInfo.headicon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }else{
            [cell.headImageView setImage:[UIImage imageNamed:@"placeholder"]];
        }
        

//        if (detailInfo.headicon != nil) {
//            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:detailInfo.headicon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
//        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
        
        if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0:
                    cell.imageView.image = [UIImage imageNamed:@"my_collect"];
                    cell.textLabel.text = @"我的收藏";
                    break;
                case 1:
                    cell.imageView.image = [UIImage imageNamed:@"my_order"];
                    cell.textLabel.text = @"我的订单";
                    break;
                case 2:
                    cell.imageView.image = [UIImage imageNamed:@"my_vipCard"];
                    cell.textLabel.text = @"我的会员卡";
                    break;
                case 3:
                    cell.imageView.image = [UIImage imageNamed:@"my_productCard"];
                    cell.textLabel.text = @"我的产品卡";
                    break;
            }
        } else {
            switch (indexPath.row) {
                case 0:
                    cell.imageView.image = [UIImage imageNamed:@"change_Password"];
                    cell.textLabel.text = @"修改密码";
                    break;
                case 1:
                    cell.imageView.image = [UIImage imageNamed:@"message_Feedback"];
                    cell.textLabel.text = @"留言反馈";
                    break;
            }
        }
        return cell;
    }
}





#pragma mark -- datasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = @[@"jjj"];
    
    
    if (indexPath.section==1 && indexPath.row == 3) {
        HUAMyProductViewController *vc = [HUAMyProductViewController new];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section==1 && indexPath.row == 2){
        HUAMemberCardViewController *vc = [HUAMemberCardViewController new];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section==1 && indexPath.row == 1){
        
        HUAMyOrderViewController *vc  =[HUAMyOrderViewController new];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.section==1 && indexPath.row == 0){
        
        HUACollectViewController *vc = [HUACollectViewController new];
        vc.arrar=array;

        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section ==0 &&indexPath.row ==0){
        HUAMyInformationViewController *vc = [HUAMyInformationViewController new];
        vc.birthString = self.birthString;
        vc.userDic = self.userDic;
        [self.navigationController pushViewController:vc animated:YES];

    }else if (indexPath.section == 2 && indexPath.row == 0) {
        HUAModifyPasswordController *vc = [HUAModifyPasswordController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    //    HUAViewController *vc = [[HUAViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
    //    HUALog(@"点击了cell");
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return hua_scale(77);
    }
    return hua_scale(40);
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return hua_scale(10);;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, hua_scale(10))];
    view.backgroundColor = HUAColor(0xe1e1e1);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = HUAColor(0xFFFFFF);
    UIView *seperateLine = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(15), 0, screenWidth-hua_scale(30), 0.5)];
    seperateLine.backgroundColor = HUAColor(0xBCBAC1);
    [view addSubview:seperateLine];
    return view;
}




@end
