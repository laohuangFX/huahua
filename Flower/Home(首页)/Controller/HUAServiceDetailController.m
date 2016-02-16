//
//  HUAServiceDetailController.m
//  Flower
//
//  Created by 程召华 on 16/1/15.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Service_detail @"service/service_detail"
#import "HUAServiceDetailController.h"
#import "HUAServiceInfo.h"
#import "HUAServiceMasterCell.h"
#import "HUAChooseMasterController.h"
#import "HUATechnicianViewController.h"

@interface HUAServiceDetailController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HUAServiceInfo *serviceInfo;
@property (nonatomic, strong) NSArray *serviceArray;

@property (nonatomic, strong) NSArray *masterArray;

//技师的聊表
@property (nonatomic, strong)NSArray *technicianArray;

//项目类容
@property (nonatomic, strong)NSString *category;

@property (nonatomic, strong)NSString *shop_id;
@end

@implementation HUAServiceDetailController

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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    NSString *url = [HUA_URL stringByAppendingPathComponent:Service_detail];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"service_id"] = self.service_id;
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
       self.shop_id = responseObject[@"item"][@"shop_id"];
        self.serviceInfo = [HUAServiceInfo getServiceDetailInfoWithDictionary:responseObject];
        //项目
        self.category = responseObject[@"item"][@"category"];
        self.serviceArray = responseObject[@"info"][@"media_lis"];
        self.masterArray = [HUADataTool getMasterArray:responseObject];
        NSLog(@"sss:%@",self.masterArray);
        [self setHeaderView:self.serviceInfo];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];

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
  
    
    HUALog(@"%ld",self.masterArray.count);
    cell.masterInfo = self.masterArray[indexPath.row];
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//    }else {
//        while ([cell.contentView.subviews lastObject] != nil) {
//            
//            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
//        }
//    }
//    HUAServiceMasterInfo *masterInfo = self.masterArray[indexPath.row];
//    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(10), hua_scale(5), hua_scale(40), hua_scale(40))];
//    [headImageView sd_setImageWithURL:[NSURL URLWithString:masterInfo.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    [cell.contentView addSubview:headImageView];
//    
//    CGRect nameFrame = CGRectMake(hua_scale(60), hua_scale(8.5), hua_scale(50),     hua_scale(12));
//    UILabel *nameLabel = [UILabel labelWithFrame:nameFrame text:masterInfo.masterName color:HUAColor(0x333333) font:hua_scale(12)];
//    [cell.contentView addSubview:nameLabel];
//    [nameLabel sizeToFit];
//    
//    CGRect typeFrame = CGRectMake(hua_scale(65)+nameLabel.width, hua_scale(10), hua_scale(50), hua_scale(10));
//    UILabel *typeLabel = [UILabel labelWithFrame:typeFrame text:masterInfo.masterType color:HUAColor(0x999999) font:hua_scale(10)];
//    [cell.contentView addSubview:typeLabel];
//    [typeLabel sizeToFit];
//    
//    UIImageView *praiseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hua_scale(60), hua_scale(30.5), hua_scale(9), hua_scale(9))];
//    praiseImageView.image = [UIImage imageNamed:@"productprise"];
//    [cell.contentView addSubview:praiseImageView];
//    
//    
//    CGRect praiseFrame = CGRectMake(hua_scale(64)+praiseImageView.width, hua_scale(30.5), hua_scale(100), hua_scale(9));
//    UILabel *praiseLabel = [UILabel labelWithFrame:praiseFrame text:[NSString stringWithFormat:@"%@赞过",masterInfo.praise_count] color:HUAColor(0xcdcdcd) font:hua_scale(9)];
//    [cell.contentView addSubview:praiseLabel];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HUAChooseMasterController *chooseMasterVC = [HUAChooseMasterController new];
    chooseMasterVC.service_id = self.service_id;
    [self.navigationController pushViewController:chooseMasterVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return hua_scale(50);
}



@end
