//
//  HUADetailController.m
//  Flower
//
//  Created by 程召华 on 16/1/9.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Create_praise        @"user/create_praise"
#define Is_vip        @"user/is_vip"
#define Active_detail @"active/active_detail"
#import "HUADetailController.h"
#import "HUADetailTopCell.h"
#import "HUAShopInfoCell.h"
#import "HUAActivityTimeCell.h"
#import "HUAShopFrontPageController.h"
#import "HUAVipShopFrontPageController.h"
#import "HUABuyViewController.h"

@interface HUADetailController ()<UITableViewDelegate, UITableViewDataSource, PhoneDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *detailArray;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) HUADetailInfo *info;
@property (nonatomic, strong) HUAUserDetailInfo *detailInfo;
@property (nonatomic, strong) id is_Vip;
@property (nonatomic, assign) CGFloat cellHeight;
@end

@implementation HUADetailController
- (HUAUserDetailInfo *)detailInfo {
    if (!_detailInfo) {
        _detailInfo = [HUAUserDefaults getUserDetailInfo];
    }
    return _detailInfo;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HUADetailTopCell class] forCellReuseIdentifier:@"top"];
        [_tableView registerClass:[HUAShopInfoCell class] forCellReuseIdentifier:@"shop"];
        [_tableView registerClass:[HUAActivityTimeCell class] forCellReuseIdentifier:@"time"];
        [_tableView registerClass:[HUAActivityDetailCell class] forCellReuseIdentifier:@"cell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        //_tableView.bounces = NO;

    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self isVip];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self setNavigationBar];
    [self getData];
}

- (void)isVip {
    NSString *token = [HUAUserDefaults getToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    NSString *url = [HUA_URL stringByAppendingPathComponent:Is_vip];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"user_id"] = self.detailInfo.user_id;
    parameter[@"shop_id"] = self.shop_id;
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //HUALog(@"是不是会员%@",responseObject);
        self.is_Vip = responseObject[@"info"];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
}

- (void)getData {
    NSString *url = [HUA_URL stringByAppendingPathComponent:Active_detail];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"active_id"] = self.active_id;
    parameters[@"shop_id"] = self.shop_id;
    [HUAHttpTool GET:url params:parameters success:^(id responseObject) {
        HUALog(@"%@",responseObject);
        //NSDictionary *shopInfo = responseObject[@"info"];
        // = [HUADetailInfo parseDetailinfo:shopInfo];
        self.info = [HUADetailInfo mj_objectWithKeyValues:responseObject[@"info"]];
        self.detailArray = [HUADataTool activityDetail:responseObject];
        [self setNavigationBar];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
         HUALog(@"%@",error);
    }];
}

#pragma mark -- 设置导航栏
- (void)setNavigationBar {
    UIButton *praiseButton = [UIButton buttonWithType:0];
    praiseButton.userInteractionEnabled = NO;
    praiseButton.frame = CGRectMake(hua_scale(268), hua_scale(9), hua_scale(42), hua_scale(16));
    [praiseButton setImage:[UIImage imageNamed:@"praise_tech"] forState:UIControlStateNormal];
    [praiseButton setTitle:self.info.praise_count forState:UIControlStateNormal];
    [praiseButton setTitleColor:HUAColor(0x000000) forState:UIControlStateNormal];
    praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    praiseButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    praiseButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(14)];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:praiseButton],];
}


#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3+self.detailArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.row == 0) {
            HUADetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"top" forIndexPath:indexPath];
            cell.top = self.info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //block回调跳转到活动订单确认
            [cell setPusViewBlock:^{
                if (![HUAUserDefaults getUserDetailInfo].user_id) {
                    [HUAMBProgress MBProgressFromWindowWithLabelText:@"未登录,正在跳转登录页面..." dispatch_get_main_queue:^{
                        HUALoginController *loginVC = [[HUALoginController alloc] init];
                        [self.navigationController pushViewController:loginVC animated:YES];
                    }];
                }else {
                    HUABuyViewController *buyVC = [HUABuyViewController new];
                    [self.navigationController pushViewController:buyVC animated:YES];
                }
            }];
            return cell;
        } else if(indexPath.row == 1){
            HUAShopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shop" forIndexPath:indexPath];
            cell.delegate = self;
            cell.shopInfo = self.info;
            return cell;
        } else  if(indexPath.row == 2){
            HUAActivityTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"time" forIndexPath:indexPath];
            cell.timeInfo = self.info;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            HUAActivityDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.textAndImg = self.detailArray[indexPath.row-3];
            self.cellHeight = cell.cellHeight;
               HUALog(@"cellHeight%f",self.cellHeight);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
}


- (void)makePhoneCall {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //添加取消按钮
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击");
    }];
    //添加电话按钮
    UIAlertAction *phoneAction = [UIAlertAction actionWithTitle:self.info.phone style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.info.phone]]];
    }];
    [alertC addAction:cancleAction];
    [alertC addAction:phoneAction];
    [self presentViewController:alertC animated:YES completion:nil];

}



#pragma mark -- datasourse
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        HUALog(@"点击了");

        HUAVipShopFrontPageController *pageVC = [[HUAVipShopFrontPageController alloc]init];
        pageVC.shop_id = self.shop_id;
        pageVC.user_id = self.detailInfo.user_id;
        HUALog(@"shop_id:%@,user_id:%@",pageVC.shop_id,pageVC.user_id);
        [self.navigationController pushViewController:pageVC animated:YES];
        
    }else
        return;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return hua_scale(377);
    }else if (indexPath.row == 1) {
        return hua_scale(56);
    }else if (indexPath.row == 2) {
        return hua_scale(157);
    }else if (indexPath.row == self.detailArray.count+2){
        return self.cellHeight+70;
    }
        return self.cellHeight +10 ;
}


@end
