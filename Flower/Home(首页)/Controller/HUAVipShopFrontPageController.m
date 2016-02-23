//
//  HUAVipShopFrontPageController.m
//  Flower
//
//  Created by 程召华 on 16/1/13.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Create_praise        @"user/praise"
#define Create_collection    @"user/create_collection"
#define Is_vip               @"user/is_vip"
#define Shop_index           @"general/shop_index"
#import "HUAVipShopFrontPageController.h"
#import "HUAVIPShopTopView.h"
#import "HUAShopTopView.h"
#import "HUAShopIntroduce.h"
#import "HUAShopFooterView.h"
#import "HUADetailController.h"
#import "HUAShopProductController.h"
#import "HUAShopServiceViewController.h"
#import "HUAMasterListController.h"
#import "HUStatusAViewController.h"
#import "HUAConsumptionController.h"
#import "HUARechargeViewController.h"
#import "HUAUserInfomation.h"

@interface HUAVipShopFrontPageController ()<UITableViewDataSource, UITableViewDelegate, VipPhoneCallDelegate, PhoneCallDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *shopArray;
@property (nonatomic, strong) HUAShopIntroduce *shopIntroduce;
@property (nonatomic, strong) HUAUserInfomation *userInfo;
@property (nonatomic, strong) NSArray *coverArray;
@property (nonatomic, strong) NSArray *idArray;
@property (nonatomic, strong) HUAUserDetailInfo *detailInfo;
@property (nonatomic, strong) id is_Vip;
@end

@implementation HUAVipShopFrontPageController

- (HUAUserDetailInfo *)detailInfo {
    if (!_detailInfo) {
        _detailInfo = [HUAUserDefaults getUserDetailInfo];
    }
    return _detailInfo;
}

- (NSArray *)shopArray {
    if (!_shopArray) {
        _shopArray = [NSArray array];
    }
    return _shopArray;
}
- (NSArray *)coverArray {
    if (!_coverArray) {
        _coverArray = [NSArray array];
    }
    return _coverArray;
}
- (NSArray *)idArray {
    if (!_idArray) {
        _idArray = [NSArray array];
    }
    return _idArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-navigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, hua_scale(10), 0, hua_scale(10));
        _tableView.separatorColor = HUAColor(0xCBCBCB);
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.detailInfo.user_id) {
        [self getData];
    }else {
        [self isVip];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)isVip {
    NSString *url = [HUA_URL stringByAppendingPathComponent:Is_vip];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"shop_id"] = self.shop_id;
    [HUAHttpTool GETWithTokenAndUrl:url params:parameter success:^(id responseObject) {
        HUALog(@"是不是会员%@",responseObject);
        self.is_Vip = responseObject[@"info"];
        [self getData];
    } failure:^(NSError *error) {
         HUALog(@"%@",error);
    }];
}

- (void)setNavigationItem {
    UIButton *collectButton = [UIButton buttonWithType:0];
    collectButton.frame = CGRectMake(hua_scale(239), hua_scale(9), hua_scale(16), hua_scale(16));
    if ([self.userInfo.have_collected isEqualToString:@"1"] ) {
        collectButton.selected = YES;
    }
    [collectButton setImage:[UIImage imageNamed:@"collect_white"] forState:UIControlStateNormal];
    [collectButton setImage:[UIImage imageNamed:@"collect_green"] forState:UIControlStateSelected];
    [collectButton addTarget:self action:@selector(clickToCollect:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *praiseButton = [UIButton buttonWithType:0];
    praiseButton.frame = CGRectMake(hua_scale(268), hua_scale(9), hua_scale(42), hua_scale(16));
    [praiseButton setImage:[UIImage imageNamed:@"praise_black_empty"] forState:UIControlStateNormal];
    [praiseButton setImage:[UIImage imageNamed:@"praise_tech"] forState:UIControlStateSelected];
    [praiseButton setTitle:self.shopIntroduce.praise_count forState:UIControlStateNormal];
    [praiseButton setTitleColor:HUAColor(0x000000) forState:UIControlStateNormal];
    praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    praiseButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    if ([self.userInfo.hava_praised isEqualToString:@"1"] ) {
        praiseButton.selected = YES;
    }
//    [praiseButton setTitle:[NSString stringWithFormat:@"%ld",self.shopIntroduce.praise_count.integerValue] forState:UIControlStateNormal];
    [praiseButton addTarget:self action:@selector(clickToPraise:) forControlEvents:UIControlEventTouchUpInside];
    
    praiseButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(14)];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:praiseButton],[[UIBarButtonItem alloc]initWithCustomView:collectButton]];
}
#pragma mark -- 点击收藏
- (void)clickToCollect:(UIButton *)sender {
    if (!self.detailInfo) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"未登录,正在跳转登录页面..." dispatch_get_main_queue:^{
            HUALoginController *loginVC = [[HUALoginController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];

    }else {
        sender.selected = !sender.selected;
        NSString *url = [HUA_URL stringByAppendingPathComponent:Create_collection];
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        parameter[@"user_id"] = self.detailInfo.user_id;
        parameter[@"shop_id"] = self.shop_id;
        [HUAHttpTool POSTWithTokenAndUrl:url params:parameter success:^(id responseObject) {
            HUALog(@"%@",responseObject);
            if ([responseObject[@"info"][0] isKindOfClass:[NSDictionary class]]) {
                [HUAMBProgress MBProgressOnlywithLabelText:@"收藏成功"];
            }else {
                [HUAMBProgress MBProgressOnlywithLabelText:@"取消收藏"];
            }

        self.block([sender.titleLabel.text integerValue]);

        } failure:^(NSError *error) {
            HUALog(@"%@",error);
        }];

    }
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
        parameter[@"target"] = @"shop";
        parameter[@"id"] = self.shop_id;
        [HUAHttpTool POSTWithTokenAndUrl:url params:parameter success:^(id responseObject) {
            HUALog(@"%@",responseObject);
            if ([responseObject[@"info"][0] isKindOfClass:[NSDictionary class]]) {
                [HUAMBProgress MBProgressOnlywithLabelText:@"点赞成功"];
                [sender setTitle:[NSString stringWithFormat:@"%ld",sender.titleLabel.text.integerValue+1] forState:UIControlStateNormal];
            }else {
                [HUAMBProgress MBProgressOnlywithLabelText:@"取消点赞"];
                [sender setTitle:[NSString stringWithFormat:@"%ld",sender.titleLabel.text.integerValue-1] forState:UIControlStateNormal];
            }
            self.block([sender.titleLabel.text integerValue]);
        } failure:^(NSError *error) {
                HUALog(@"%@",error);
        }];

    }
}


- (void)getData {
    NSString *url = [HUA_URL stringByAppendingPathComponent:Shop_index];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"shop_id"] = self.shop_id;
    parameters[@"user_id"] = self.detailInfo.user_id;
    [HUAHttpTool GETWithTokenAndUrl:url params:parameters success:^(id responseObject) {
        HUALog(@"%@",responseObject);
        self.shopIntroduce = [HUAShopIntroduce parseFrontShopPageWithDictionary:responseObject[@"info"][@"shop_info"]];
        self.userInfo = [HUAUserInfomation mj_objectWithKeyValues:responseObject[@"info"][@"user_info"]];
        
        [self setHeaderView:self.shopIntroduce];
        NSArray *cover = [HUADataTool activeCover:responseObject];
        HUAShopIntroduce *coverIntroduce = cover.firstObject;
        self.coverArray = coverIntroduce.coverArray;
        NSArray *activeID = [HUADataTool activeID:responseObject];
        HUAShopIntroduce *IDIntroduce = activeID.firstObject;
        self.idArray = IDIntroduce.idArray;
        [self setFooterViewWithCoverArray:self.coverArray andIdArray:self.idArray];
        [self setNavigationItem];
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        HUALog(@"%@",error);

    }];
}

- (void)setHeaderView:(HUAShopIntroduce *)shopIntroduce {
    //判断是不是会员
    if (![self.is_Vip isKindOfClass:[NSDictionary class]]) {
        HUAShopTopView *headerView = [[HUAShopTopView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, hua_scale(390))];
        headerView.delegate = self;
        headerView.shopIntroduce = shopIntroduce;
        self.tableView.tableHeaderView = headerView;
        
        CGRect becomeVIPButtonFrame = CGRectMake(hua_scale(10), hua_scale(200), hua_scale(145), hua_scale(53));
        
        UIButton *becomeVIPButton = [UIButton buttonWithFrame:becomeVIPButtonFrame title:@"成为会员" image:@"becomevip" font:hua_scale(15) titleColor:HUAColor(0x333333)];
        becomeVIPButton.backgroundColor = HUAColor(0xF6F6F6);
        [becomeVIPButton addTarget:self action:@selector(becomeVIP:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:becomeVIPButton];
        
        CGRect purchaseButtonFrame = CGRectMake(hua_scale(165), hua_scale(200), hua_scale(145), hua_scale(53));
        UIButton *purchaseButton = [UIButton buttonWithFrame:purchaseButtonFrame title:@"预约" image:@"appointment" font:hua_scale(15) titleColor:HUAColor(0xFFFFFF)];
        purchaseButton.backgroundColor = HUAColor(0x4da000);
        [purchaseButton addTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:purchaseButton];
        
        
        CGRect distanceFrame = CGRectMake(hua_scale(50), hua_scale(339),hua_scale(60), 0);
        UILabel *distanceLabel = [UILabel labelWithFrame:distanceFrame text:[NSString stringWithFormat:@"[%@]",self.shopIntroduce.distance] color:HUAColor(0x939391) font:hua_scale(12)];
        [headerView addSubview:distanceLabel];
        [distanceLabel sizeToFit];
        
        CGRect addressFrame = CGRectMake(hua_scale(50), hua_scale(339),screenWidth - hua_scale(60), 0);
        UILabel *addressLabel = [UILabel labelWithFrame:addressFrame text:self.shopIntroduce.address color:HUAColor(0x4da800) font:hua_scale(12)];
        addressLabel.numberOfLines = 2;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.shopIntroduce.address];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];//调整行间距
        [paragraphStyle setFirstLineHeadIndent:distanceLabel.width];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [addressLabel.text length])];
        addressLabel.attributedText = attributedString;
        [headerView addSubview:addressLabel];
        [addressLabel sizeToFit];
        
        
        
        UIView *bottomSeperateLine = [[UIView alloc]initWithFrame:CGRectMake(hua_scale(10), hua_scale(390), screenWidth-hua_scale(20), 0.5)];
        bottomSeperateLine.backgroundColor = HUAColor(0xCBCBCB);
        [headerView addSubview:bottomSeperateLine];

    }else {
        HUAVIPShopTopView *headerView = [[HUAVIPShopTopView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, hua_scale(455))];
        headerView.delegate = self;
        headerView.shopIntroduce = shopIntroduce;
        self.tableView.tableHeaderView = headerView;
        
        UIView *topSeparateLine = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(10), hua_scale(235), screenWidth - hua_scale(20), 0.5)];
        topSeparateLine.backgroundColor = HUAColor(0xd2d2d2);
        [headerView addSubview:topSeparateLine];
        
        UIView *centerSeparateLine = [[UIView alloc] initWithFrame:CGRectMake(screenWidth/2, hua_scale(197.5), hua_scale(0.5), hua_scale(30))];
        centerSeparateLine.backgroundColor = HUAColor(0xd2d2d2);
        [headerView addSubview:centerSeparateLine];
        
        
        CGRect balanceFrame = CGRectMake(hua_scale(18), hua_scale(206),hua_scale(130), 0);
        UILabel *balanceLabel = [[UILabel alloc]initWithFrame:balanceFrame];
        balanceLabel.numberOfLines = 1;
        NSString *string1 = @"余额：";
        NSString *string2 = [NSString stringWithFormat:@"¥%@",self.userInfo.money];
        balanceLabel.text = [NSString stringWithFormat:@"%@%@",string1,string2];
        [headerView addSubview:balanceLabel];
        [balanceLabel sizeToFit];
        
        NSMutableAttributedString *balanceAttributedString = [[NSMutableAttributedString alloc] initWithString:balanceLabel.text];
        
        [balanceAttributedString addAttribute:NSForegroundColorAttributeName value:HUAColor(0x999999) range:NSMakeRange(0 ,[string1 length])];
        [balanceAttributedString addAttribute:NSForegroundColorAttributeName value:HUAColor(0x4da800) range:NSMakeRange([string1 length],[string2 length])];
        [balanceAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:hua_scale(15)] range:NSMakeRange([string1 length],[string2 length])];
        [balanceAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:hua_scale(10)] range:NSMakeRange(0, [string1 length])];
        balanceLabel.attributedText = balanceAttributedString;
        
        
        CGRect recordFrame = CGRectMake(screenWidth/2+hua_scale(10), hua_scale(197.5), screenWidth/2-hua_scale(20), hua_scale(30));
        UIButton *recordButton = [UIButton buttonWithFrame:recordFrame title:@"消费记录" image:@"my_order" font:hua_scale(15) titleColor:HUAColor(0x333333)];
        [recordButton addTarget:self action:@selector(recordsOfConsumption:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:recordButton];
        
        
        
        CGRect rechargeFrame = CGRectMake(hua_scale(10), hua_scale(265), hua_scale(145), hua_scale(53));
        UIButton *rechargeButton = [UIButton buttonWithFrame:rechargeFrame title:@"充值" image:@"recharge" font:hua_scale(15) titleColor:HUAColor(0x333333)];
        rechargeButton.backgroundColor = HUAColor(0xF6F6F6);
        [rechargeButton addTarget:self action:@selector(recharge:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:rechargeButton];
        
        CGRect rechargeLabelFrame = CGRectMake(hua_scale(10), hua_scale(300), hua_scale(145), hua_scale(18));
        UILabel *rechargeLabel = [UILabel labelWithFrame:rechargeLabelFrame text:[NSString stringWithFormat:@"充值满%@送%@",self.shopIntroduce.refill_setting[@"money"],self.shopIntroduce.refill_setting[@"give_money"]] color:HUAColor(0x999999) font:hua_scale(9)];
        rechargeLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:rechargeLabel];
        
        CGRect purchaseButtonFrame = CGRectMake(hua_scale(165), hua_scale(265), hua_scale(145), hua_scale(53));
        UIButton *purchaseButton = [UIButton buttonWithFrame:purchaseButtonFrame title:@"预约" image:@"appointment" font:hua_scale(15) titleColor:HUAColor(0xFFFFFF)];
        purchaseButton.backgroundColor = HUAColor(0x4da000);
        [purchaseButton addTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:purchaseButton];
        
        
        CGRect distanceFrame = CGRectMake(hua_scale(50), hua_scale(404),hua_scale(60), 0);
        UILabel *distanceLabel = [UILabel labelWithFrame:distanceFrame text:[NSString stringWithFormat:@"[%@]",self.shopIntroduce.distance] color:HUAColor(0x939391) font:hua_scale(12)];
        [headerView addSubview:distanceLabel];
        [distanceLabel sizeToFit];
        
        CGRect addressFrame = CGRectMake(hua_scale(50), hua_scale(404),screenWidth - hua_scale(60), 0);
        UILabel *addressLabel = [UILabel labelWithFrame:addressFrame text:self.shopIntroduce.address color:HUAColor(0x4da800) font:hua_scale(12)];
        addressLabel.numberOfLines = 2;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:addressLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];//调整行间距
        [paragraphStyle setFirstLineHeadIndent:distanceLabel.width];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [addressLabel.text length])];
        addressLabel.attributedText = attributedString;
        [headerView addSubview:addressLabel];
        [addressLabel sizeToFit];
        
        
        UIView *bottomSeperateLine = [[UIView alloc]initWithFrame:CGRectMake(hua_scale(10), hua_scale(455), screenWidth-hua_scale(20), 0.5)];
        bottomSeperateLine.backgroundColor = HUAColor(0xd2d2d2);
        [headerView addSubview:bottomSeperateLine];
    }
    
}

- (void)makePhoneCall {
    [self vipMakePhoneCall];
}

- (void)vipMakePhoneCall {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //添加取消按钮
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击");
    }];
    //添加电话按钮
    UIAlertAction *phoneAction = [UIAlertAction actionWithTitle:self.shopIntroduce.phone style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.shopIntroduce.phone]]];
    }];
    [alertC addAction:cancleAction];
    [alertC addAction:phoneAction];
    [self presentViewController:alertC animated:YES completion:nil];
}
//非会员和非注册用户（成为会员）
- (void)becomeVIP:(UIButton *)sender {
    //没有注册的用户点击购买跳转到登录页面
    if (![HUAUserDefaults getUserDetailInfo].user_id) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"未登录,正在跳转登录页面..." dispatch_get_main_queue:^{
            HUALoginController *loginVC = [[HUALoginController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
    }else {
        HUARechargeViewController *rechargeVC = [HUARechargeViewController new];
        [self.navigationController pushViewController:rechargeVC animated:YES];
    }
    
    HUALog(@"成为会员");
}





//非会员和非注册用户（购买）
- (void)purchase:(UIButton *)sender {
    //没有注册的用户点击购买跳转到登录页面

    HUAShopServiceViewController *shopServiceVC = [HUAShopServiceViewController new];
    shopServiceVC.shop_id = self.shop_id;
    shopServiceVC.url = [HUA_URL stringByAppendingPathComponent:Service_list];
    shopServiceVC.shopName = self.shopName;
    [self.navigationController pushViewController:shopServiceVC animated:YES];

}



- (void)recordsOfConsumption:(UIButton *)sender {
    HUALog(@"消费记录");
    HUAConsumptionController *consumptionVC = [HUAConsumptionController new];
    consumptionVC.shop_id = self.shop_id;
    consumptionVC.user_id = self.user_id;
    [self.navigationController pushViewController:consumptionVC animated:YES];
}

- (void)recharge:(UIButton *)sender {
    HUALog(@"充值");
    HUARechargeViewController *rechargeVC = [HUARechargeViewController new];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}




- (void)setFooterViewWithCoverArray:(NSArray *)coverArray andIdArray:(NSArray *)idArray {
    UIView *topSeperateLine = [[UIView alloc]initWithFrame:CGRectMake(hua_scale(10), 0, screenWidth-hua_scale(20), 0.5)];
    topSeperateLine.backgroundColor = HUAColor(0xCBCBCB);
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(hua_scale(10), hua_scale(25), hua_scale(100), hua_scale(13))];
    titleLabel.text = @"店铺简介";
    titleLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.frame = CGRectMake(hua_scale(10), hua_scale(52), screenWidth- hua_scale(20), 0);
    detailLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    detailLabel.numberOfLines = 0;
    detailLabel.textColor = HUAColor(0x494949);
    detailLabel.text = self.shopIntroduce.desc;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:detailLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:10];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailLabel.text length])];
    detailLabel.attributedText = attributedString;
    
    
    [detailLabel sizeToFit];
    
    UIView *seperateLine = [[UIView alloc]initWithFrame:CGRectMake(hua_scale(10), hua_scale(77)+detailLabel.height, screenWidth-hua_scale(20), 0.5)];
    seperateLine.backgroundColor = HUAColor(0xCBCBCB);
    
    
    UILabel*newestActive = [[UILabel alloc]initWithFrame:CGRectMake(hua_scale(10), hua_scale(102)+detailLabel.height, hua_scale(100), hua_scale(13))];
    newestActive.text = @"最新活动";
    newestActive.font = [UIFont systemFontOfSize:hua_scale(14)];
    
    CGFloat height = 0.0;
    if (coverArray.count == 0) {
        height =detailLabel.height+hua_scale(134);
    }else {
        for (int i = 0; i < coverArray.count; i++) {
            if (i%3  == 0 || i%3  == 1) {
                height = hua_scale(116)+(i / 3) *hua_scale(252)+detailLabel.height+hua_scale(134);
            }
            if (i%3  == 2) {
                height = hua_scale(242)+(i / 3) *hua_scale(252)+detailLabel.height+hua_scale(134);
            }
        }
        
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, height+hua_scale(20))];
    [footerView addSubview:topSeperateLine];
    [footerView addSubview:titleLabel];
    [footerView addSubview:detailLabel];
    [footerView addSubview:seperateLine];
    [footerView addSubview:newestActive];
    
    for (int i = 0; i < coverArray.count; i ++) {
        if (i % 3 == 0) {
            CGRect buttonFrame = CGRectMake(hua_scale(10), (i / 3) *hua_scale(252)+detailLabel.height+hua_scale(132), hua_scale(147), hua_scale(116));
            UIButton *button = [UIButton buttonWithTarget:self action:@selector(click:) Frame:buttonFrame url:coverArray[i]];
            button.tag = [idArray[i] integerValue];
            [footerView addSubview:button];
        }
        if (i % 3 == 1) {
            CGRect buttonFrame = CGRectMake(hua_scale(163), (i / 3) *hua_scale(252)+detailLabel.height+hua_scale(132), hua_scale(147), hua_scale(116));
            UIButton *button = [UIButton buttonWithTarget:self action:@selector(click:) Frame:buttonFrame url:coverArray[i]];
            button.tag = [idArray[i] integerValue];
            [footerView addSubview:button];
        }
        if (i % 3 == 2) {
            CGRect buttonFrame = CGRectMake(hua_scale(10), (i / 3) *hua_scale(252)+hua_scale(126)+detailLabel.height+hua_scale(132), hua_scale(300), hua_scale(116));
            UIButton *button = [UIButton buttonWithTarget:self action:@selector(click:) Frame:buttonFrame url:coverArray[i]];
            button.tag = [idArray[i] integerValue];
            [footerView addSubview:button];
        }
    }
    
    self.tableView.tableFooterView = footerView;
}

- (void)click:(UIButton *)sender {
    NSInteger id = sender.tag;
    NSString *activeID = [NSString stringWithFormat:@"%ld",(long)id];
    HUALog(@"%@",activeID);
    HUADetailController *vc = [HUADetailController new];
    vc.active_id = activeID;
    vc.shop_id = self.shop_id;
    [self.navigationController pushViewController:vc animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }
    cell.textLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"shop_product"];
            cell.textLabel.text = @"产品";
            cell.detailTextLabel.text = @"10";
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"service"];
            cell.textLabel.text = @"服务";
            cell.detailTextLabel.text = self.shopIntroduce.service_count;
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"technician"];
            cell.textLabel.text = @"技师";
            cell.detailTextLabel.text = self.shopIntroduce.service_count;
            break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"newtrends"];
            cell.textLabel.text = @"最新动态";
            cell.detailTextLabel.text = self.shopIntroduce.master_count;
            break;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HUAShopProductController *shopProductVC = [HUAShopProductController new];
        shopProductVC.shop_id = self.shop_id;
        shopProductVC.url = [HUA_URL stringByAppendingPathComponent:Product_list];
        shopProductVC.shopName = self.shopName;
        [self.navigationController pushViewController:shopProductVC animated:YES];
    }
    if (indexPath.row == 1) {
        HUAShopServiceViewController *shopServiceVC = [HUAShopServiceViewController new];
        shopServiceVC.shop_id = self.shop_id;
        shopServiceVC.url = [HUA_URL stringByAppendingPathComponent:Service_list];
        shopServiceVC.shopName = self.shopName;
        [self.navigationController pushViewController:shopServiceVC animated:YES];
    }
    if (indexPath.row == 2) {
        HUAMasterListController *masterListVC = [HUAMasterListController new];
        masterListVC.shop_id = self.shop_id;
        masterListVC.url = [HUA_URL stringByAppendingPathComponent:Master_list];
        masterListVC.shopName = self.shopName;
        [self.navigationController pushViewController:masterListVC animated:YES];
    }
    if (indexPath.row == 3) {
        HUStatusAViewController *statusVC = [HUStatusAViewController new];
        statusVC.shop_id = self.shop_id;
        statusVC.shopName = self.shopName;
        [self.navigationController pushViewController:statusVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}


@end
