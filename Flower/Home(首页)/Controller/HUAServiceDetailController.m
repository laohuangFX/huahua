//
//  HUAServiceDetailController.m
//  Flower
//
//  Created by 程召华 on 16/1/15.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Create_praise      @"user/praise"
#define Service_detail @"service/service_detail"
#import "HUAServiceDetailController.h"
#import "HUAServiceInfo.h"
#import "HUAServiceMasterCell.h"
#import "HUAChooseMasterController.h"
#import "HUATechnicianViewController.h"
#import "HUAMasterDetailController.h"

@interface HUAServiceDetailController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/**服务模型*/
@property (nonatomic, strong) HUAServiceInfo *serviceInfo;
/**服务数组*/
@property (nonatomic, strong) NSArray *serviceArray;
/**技师数组*/
@property (nonatomic, strong) NSArray *masterArray;
/**技师的聊表*/
@property (nonatomic, strong) NSArray *technicianArray;
/**项目类容*/
@property (nonatomic, strong) NSString *category;
/**店铺id*/
@property (nonatomic, strong) NSString *shop_id;
/**用户信息*/
@property (nonatomic, strong) HUAUserDetailInfo *detailInfo;
@end

@implementation HUAServiceDetailController

- (HUAUserDetailInfo *)detailInfo {
    if (!_detailInfo) {
        _detailInfo = [HUAUserDefaults getUserDetailInfo];
    }
    return _detailInfo;
}

- (NSArray *)masterArray {
    if (!_masterArray) {
        _masterArray = [NSArray array];
    }
    return _masterArray;
}

- (NSArray *)serviceArray {
    if (!_serviceArray) {
        _serviceArray = [NSArray array];
    }
    return _serviceArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-navigationBarHeight)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HUAServiceMasterCell class] forCellReuseIdentifier:@"Cell"];
        _tableView.separatorInset = UIEdgeInsetsMake(0, hua_scale(10), 0, hua_scale(10));
        _tableView.separatorColor = HUAColor(0xcdcdcd);
       // [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务详情";
    [self.view addSubview:self.tableView];

}

- (void)getData {
    
    NSString *url = [HUA_URL stringByAppendingPathComponent:Service_detail];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"user_id"] = self.detailInfo.user_id;
    parameters[@"service_id"] = self.service_id;
    NSLog(@"%@",url);
    [HUAHttpTool GETWithTokenAndUrl:url params:parameters success:^(id responseObject) {
        HUALog(@"response%@",responseObject);
        self.shop_id = responseObject[@"item"][@"shop_id"];
        self.serviceInfo = [HUAServiceInfo mj_objectWithKeyValues:responseObject[@"item"]];
        HUALog(@"%@",self.serviceInfo.have_praised);
        self.category = responseObject[@"item"][@"category"];
        self.serviceArray = responseObject[@"info"][@"media_lis"];
        self.masterArray = [HUADataTool getMasterArray:responseObject];
        [self setHeaderView:self.serviceInfo];
        [self setNavigationBar];
        [self.tableView reloadData];

    } failure:^(NSError *error) {
         HUALog(@"%@",error);
    }];
}

#pragma mark -- 设置导航栏
- (void)setNavigationBar {
    UIButton *praiseButton = [UIButton buttonWithType:0];
    praiseButton.frame = CGRectMake(hua_scale(268), hua_scale(9), hua_scale(42), hua_scale(16));
    [praiseButton setImage:[UIImage imageNamed:@"praise_black_empty"] forState:UIControlStateNormal];
    [praiseButton setImage:[UIImage imageNamed:@"praise_tech"] forState:UIControlStateSelected];
    [praiseButton setTitle:self.serviceInfo.praise_count forState:UIControlStateNormal];
    [praiseButton setTitleColor:HUAColor(0x000000) forState:UIControlStateNormal];
    praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    praiseButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    if ([[[[NSNumberFormatter alloc] init] stringFromNumber:self.serviceInfo.have_praised] isEqualToString:@"1"] ) {
        praiseButton.selected = YES;
        
    }
    [praiseButton setTitle:[NSString stringWithFormat:@"%ld",self.serviceInfo.praise_count.integerValue] forState:UIControlStateNormal];
    [praiseButton addTarget:self action:@selector(clickToPraise:) forControlEvents:UIControlEventTouchUpInside];
    
    praiseButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(14)];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:praiseButton]];
}

#pragma mark -- 点击点赞
- (void)clickToPraise:(UIButton *)sender {
    if (!self.detailInfo) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"未登录,正在跳转登录页面..." dispatch_get_main_queue:^{
            HUALoginController *loginVC = [[HUALoginController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
        
    }else {
        sender.selected = !sender.selected;
        NSString *url = [HUA_URL stringByAppendingPathComponent:Create_praise];
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        parameter[@"target"] = @"service";
        parameter[@"id"] = self.service_id;
        [HUAHttpTool POSTWithTokenAndUrl:url params:parameter success:^(id responseObject) {
            HUALog(@"%@",responseObject);
            if ([responseObject[@"info"][0] isKindOfClass:[NSDictionary class]]) {
                [HUAMBProgress MBProgressOnlywithLabelText:@"点赞成功"];
                [sender setTitle:[NSString stringWithFormat:@"%ld",sender.titleLabel.text.integerValue+1] forState:UIControlStateNormal];
            }else {
                [HUAMBProgress MBProgressOnlywithLabelText:@"取消点赞"];
                [sender setTitle:[NSString stringWithFormat:@"%ld",sender.titleLabel.text.integerValue-1] forState:UIControlStateNormal];
            }
        } failure:^(NSError *error) {
            HUALog(@"%@",error);
        }];
    }
}


#pragma mark - tableView代理
- (void)setHeaderView:(HUAServiceInfo *)serviceInfo {
    UIImageView *serviceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, hua_scale(190))];
    [serviceImageView sd_setImageWithURL:[NSURL URLWithString:serviceInfo.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    CGRect nameFrame = CGRectMake(hua_scale(10), hua_scale(205), screenWidth - hua_scale(20), 0);
    UILabel *serviceName = [UILabel labelWithFrame:nameFrame text:serviceInfo.name color:HUAColor(0x000000) font:hua_scale(13)];
    serviceName.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:serviceName.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:hua_scale(7)];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [serviceName.text length])];
        serviceName.attributedText = attributedString;
    [serviceName sizeToFit];
    
    
    CGRect priceFrame = CGRectMake(hua_scale(10), serviceName.height+hua_scale(220), screenWidth - hua_scale(20), hua_scale(19));
    UILabel *servicePrice = [[UILabel alloc]initWithFrame:priceFrame];
    servicePrice.text = [NSString stringWithFormat:@"¥%@(会员价¥%@)",serviceInfo.price,serviceInfo.vip_discount];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:servicePrice.text];
    [str addAttribute:NSForegroundColorAttributeName value:HUAColor(0x4da800) range:NSMakeRange(0 ,[serviceInfo.price length]+1)];
    [str addAttribute:NSForegroundColorAttributeName value:HUAColor(0x4da800) range:NSMakeRange([serviceInfo.price length]+1,[serviceInfo.vip_discount length]+6)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:hua_scale(19)] range:NSMakeRange(0, [serviceInfo.price length]+1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:hua_scale(11)] range:NSMakeRange([serviceInfo.price length]+1,[serviceInfo.vip_discount length]+6)];
    
    servicePrice.attributedText = str;

    
    CGRect purchaseFrame = CGRectMake(hua_scale(20), serviceName.height+hua_scale(259), screenWidth- hua_scale(40), hua_scale(53));
    UIButton *purchaseButton = [UIButton buttonWithFrame:purchaseFrame title:@"预约" image:@"appointment" font:hua_scale(15) titleColor:HUAColor(0xffffff)];
    purchaseButton.backgroundColor = HUAColor(0x4da800);
    [purchaseButton addTarget:self action:@selector(clickToPurchase:) forControlEvents:UIControlEventTouchUpInside];
    
     CGRect titleFrame = CGRectMake(hua_scale(10), serviceName.height+hua_scale(342), screenWidth- hua_scale(20), hua_scale(13));
    UILabel *titleLabel = [UILabel labelWithFrame:titleFrame text:@"服务内容" color:HUAColor(0x000000) font:hua_scale(13)];
    
    CGRect serviceFrame = CGRectMake(hua_scale(10), serviceName.height+hua_scale(370), screenWidth- hua_scale(20), 0);
    UILabel *serviceContent = [UILabel labelWithFrame:serviceFrame text:serviceInfo.desc color:HUAColor(0x000000) font:hua_scale(11)];
    serviceContent.numberOfLines = 0;
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:serviceContent.text];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:hua_scale(10)];//调整行间距
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [serviceContent.text length])];
    serviceContent.attributedText = attributedString1;
    [serviceContent sizeToFit];
    
    UIView *separateLine1 = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(10), serviceName.height+serviceContent.height+hua_scale(395), screenWidth-hua_scale(20), 0.5)];
    separateLine1.backgroundColor = HUAColor(0xeeeeee);
    
    CGRect titleDetailFrame = CGRectMake(hua_scale(10), serviceName.height+serviceContent.height+hua_scale(420), screenWidth- hua_scale(20), hua_scale(13));
    UILabel *serviceDetailLabel = [UILabel labelWithFrame:titleDetailFrame text:@"服务详情" color:HUAColor(0x000000) font:hua_scale(13)];
    
    UIView *separateLine2 = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(10), serviceName.height+serviceContent.height+hua_scale(463) + hua_scale(195)*self.serviceArray.count, screenWidth-hua_scale(20), 0.5)];
    separateLine2.backgroundColor = HUAColor(0xeeeeee);
    
    CGRect masterFrame = CGRectMake(hua_scale(10), serviceName.height+serviceContent.height+hua_scale(488) + hua_scale(195)*self.serviceArray.count, screenWidth-hua_scale(20), hua_scale(13));
    UILabel *masterLabel = [UILabel labelWithFrame:masterFrame text:@"服务技师" color:HUAColor(0x000000) font:hua_scale(13)];
    
    UIView *separateLine3 = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(10), serviceName.height+serviceContent.height+hua_scale(516) + hua_scale(195)*self.serviceArray.count, screenWidth-hua_scale(20), 0.5)];
    separateLine3.backgroundColor = HUAColor(0xcdcdcd);
    
    CGFloat height = serviceName.height+serviceContent.height+hua_scale(516) + hua_scale(195)*self.serviceArray.count;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, height)];
    
    for (int i = 0; i < self.serviceArray.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(10), serviceName.height+serviceContent.height+hua_scale(448) + hua_scale(195)*i, screenWidth - hua_scale(20), hua_scale(190))];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.serviceArray[i]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [headerView addSubview:imageView];
    }
    
    
    [headerView addSubview:serviceImageView];
    [headerView addSubview:serviceName];
    [headerView addSubview:servicePrice];
    [headerView addSubview:purchaseButton];
    [headerView addSubview:titleLabel];
    [headerView addSubview:serviceContent];
    [headerView addSubview:separateLine1];
    [headerView addSubview:serviceDetailLabel];
    [headerView addSubview:separateLine2];
    [headerView addSubview:masterLabel];
    [headerView addSubview:separateLine3];
    self.tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.height = hua_scale(20);
    
    
    UIView *footSeparateLine = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(10), hua_scale(0), screenWidth-hua_scale(20), 0.5)];
    footSeparateLine.backgroundColor = HUAColor(0xcdcdcd);
    [footerView addSubview:footSeparateLine];
    
    self.tableView.tableFooterView = footerView;
}


- (void)clickToPurchase:(UIButton *)sender {
    
    if (![HUAUserDefaults getUserDetailInfo].user_id) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].keyWindow subviews].lastObject animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            hud.labelText = @"未登录,正在跳转登录页面...";
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].keyWindow subviews].lastObject animated:YES];
                HUALoginController *loginVC = [[HUALoginController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            });
        });
    }else {
        //跳转到选择技师
        HUATechnicianViewController *vc = [HUATechnicianViewController new];
        vc.service_id = self.service_id;
        vc.category = self.category;
         vc.shop_id = self.shop_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    HUALog(@"购买了");
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.masterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HUAServiceMasterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    cell.masterInfo = self.masterArray[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HUAServiceMasterInfo *model = self.masterArray[indexPath.row];
    HUAMasterDetailController *vc = [HUAMasterDetailController new];
    vc.master_id = model.master_id;
    vc.shop_id = self.serviceInfo.shop_id;
    [self.navigationController pushViewController:vc animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return hua_scale(50);
}



@end
