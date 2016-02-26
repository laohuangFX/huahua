//
//  HUAProductDetailController.m
//  Flower
//
//  Created by 程召华 on 16/1/13.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Create_praise      @"user/praise"
#define Product_detail     @"product/product_detail"
#import "HUAProductDetailController.h"
#import "HUATopInfoView.h"
#import "HUAProductDetailInfo.h"
#import "HUAProductsToBuyViewController.h"
#import "HUAProductDetailCell.h"


@interface HUAProductDetailController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *photoArray;
@property (nonatomic, strong) HUAProductDetailInfo *productDetailInfo;
//会员信息
@property (nonatomic, strong)NSDictionary *membersInformation;

@property (nonatomic, strong) HUAUserDetailInfo *detailInfo;

@property (nonatomic, strong) NSDictionary *information;

@property (nonatomic, strong) UILabel *keyLabel;

@property (nonatomic, strong) UILabel *valueLabel;
@end

@implementation HUAProductDetailController

- (NSDictionary *)information {
    if (!_information) {
        _information = [NSDictionary dictionary];
    }
    return _information;
}

- (HUAUserDetailInfo *)detailInfo {
    if (!_detailInfo) {
        _detailInfo = [HUAUserDefaults getUserDetailInfo];
    }
    return _detailInfo;
}

- (NSArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSArray array];
    }
    return _photoArray;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-navigationBarHeight)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HUAProductDetailCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //获取会员信息
    [self getMembers];
    
    [self getData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品详情";
    [self.view addSubview:self.tableView];

}

- (void)setNavigationBar {
//    UIButton *praiseButton = [UIButton buttonWithType:0];
//    praiseButton.frame = CGRectMake(hua_scale(268), hua_scale(9), hua_scale(42), hua_scale(16));
//    [praiseButton setImage:[UIImage imageNamed:@"praise_black_empty"] forState:UIControlStateNormal];
//    [praiseButton setImage:[UIImage imageNamed:@"praise_tech"] forState:UIControlStateSelected];
//    [praiseButton setTitle:self.productDetailInfo.praise_count forState:UIControlStateNormal];
//    [praiseButton setTitleColor:HUAColor(0x000000) forState:UIControlStateNormal];
//    praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//    praiseButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
//    if ([[[[NSNumberFormatter alloc] init] stringFromNumber:self.productDetailInfo.have_praised] isEqualToString:@"1"] ) {
//        praiseButton.selected = YES;
//        
//    }
////    [praiseButton setTitle:[NSString stringWithFormat:@"%ld",self.productDetailInfo.praise_count.integerValue] forState:UIControlStateNormal];
//    [praiseButton addTarget:self action:@selector(clickToPraise:) forControlEvents:UIControlEventTouchUpInside];
//    
//    praiseButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(14)];
//    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:praiseButton]];
    
    HUAPraiseButton *praiseButton = [[HUAPraiseButton alloc] initWithFrame:CGRectMake(hua_scale(268), hua_scale(9), hua_scale(42), hua_scale(15))];
    UIBarButtonItem *leftSpace = [UIBarButtonItem leftSpace:-20];
    self.navigationItem.rightBarButtonItems = @[leftSpace,[[UIBarButtonItem alloc]initWithCustomView:praiseButton]];
    if ([[[[NSNumberFormatter alloc] init] stringFromNumber:self.productDetailInfo.have_praised] isEqualToString:@"1"] ) {
        praiseButton.selected = YES;
        praiseButton.praiseImageView.image = [UIImage imageNamed:@"praise_tech"];
    }else {
        praiseButton.praiseImageView.image = [UIImage imageNamed:@"praise_black_empty"];
    }
    praiseButton.label.text = [NSString stringWithFormat:@"%ld",self.productDetailInfo.praise_count.integerValue];
    [praiseButton addTarget:self action:@selector(clickToPraise:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark -- 点击点赞
- (void)clickToPraise:(HUAPraiseButton *)sender {
    if (!self.detailInfo) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"未登录,正在跳转登录页面..." dispatch_get_main_queue:^{
            HUALoginController *loginVC = [[HUALoginController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
        
    }else {
        sender.selected = !sender.selected;
        NSString *url = [HUA_URL stringByAppendingPathComponent:Create_praise];
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        parameter[@"target"] = @"product";
        parameter[@"id"] = self.product_id;
        [HUAHttpTool POSTWithTokenAndUrl:url params:parameter success:^(id responseObject) {
            HUALog(@"%@",responseObject);
            if ([responseObject[@"info"][0] isKindOfClass:[NSDictionary class]]) {
                sender.label.text = [NSString stringWithFormat:@"%ld",sender.label.text.integerValue+1];
                sender.praiseImageView.image = [UIImage imageNamed:@"praise_tech"];
                [HUAMBProgress MBProgressOnlywithLabelText:@"点赞成功"];
                //[sender setTitle:[NSString stringWithFormat:@"%ld",sender.titleLabel.text.integerValue+1] forState:UIControlStateNormal];
            }else {
                sender.label.text = [NSString stringWithFormat:@"%ld",sender.label.text.integerValue-1];
                sender.praiseImageView.image = [UIImage imageNamed:@"praise_black_empty"];
                [HUAMBProgress MBProgressOnlywithLabelText:@"取消点赞"];
                //[sender setTitle:[NSString stringWithFormat:@"%ld",sender.titleLabel.text.integerValue-1] forState:UIControlStateNormal];
            }
            _block([sender.label.text integerValue]);
        } failure:^(NSError *error) {
            HUALog(@"%@",error);
        }];
    }
}


- (void)getData {

    NSString *url = [HUA_URL stringByAppendingPathComponent:Product_detail];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"user_id"] = [HUAUserDefaults getUserDetailInfo].user_id;
    parameters[@"product_id"] = self.product_id;
    [HUAHttpTool GETWithTokenAndUrl:url params:parameters success:^(id responseObject) {
        HUALog(@"reso%@",responseObject);
        self.productDetailInfo = [HUAProductDetailInfo mj_objectWithKeyValues:responseObject[@"item"]];
        self.information = responseObject[@"information"];
        self.photoArray = responseObject[@"media_lis"];
        [self setTableViewHeadrView:self.productDetailInfo];
        [self setNavigationBar];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        HUALog(@"%@",error);
    }];

}
- (void)getMembers{
    
    NSString *token = [HUAUserDefaults getToken];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    NSString *url = [HUA_URL stringByAppendingPathComponent:@"user/is_vip"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"shop_id"] =self.shop_id;
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        self.membersInformation = responseObject;
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
}

#pragma mark - tableViewHeaderView

- (void)setTableViewHeadrView:(HUAProductDetailInfo *)detailInfo {
    HUATopInfoView *header = [[HUATopInfoView alloc] init];
    header.detailInfo = detailInfo;


    
    
    
    NSArray *informationArray = [self.information allKeys];
    for (int i = 0; i < informationArray.count; i++) {
        NSString *keyString = informationArray[i];
        NSString *valueString = self.information[keyString];
        
        self.keyLabel = [UILabel labelText:[NSString stringWithFormat:@"%@ :",keyString] color:HUAColor(0x999999) font:hua_scale(11)];
        self.keyLabel.frame = CGRectMake(hua_scale(10), hua_scale(402)+hua_scale(21)*i, hua_scale(100), hua_scale(11));
        [header addSubview:self.keyLabel];
        self.valueLabel = [UILabel labelText:valueString color:HUAColor(0x4da800) font:hua_scale(11)];
        self.valueLabel.frame = CGRectMake(hua_scale(137), hua_scale(402)+hua_scale(21)*i, hua_scale(100), hua_scale(11));
        [header addSubview:self.valueLabel];
    }
    UIView *topSeparateLine = [[UIView alloc] init];
    topSeparateLine.frame =  CGRectMake(hua_scale(10), CGRectGetMaxY(self.valueLabel.frame)+hua_scale(25), screenWidth-hua_scale(20), 0.5);
    topSeparateLine.backgroundColor = HUAColor(0xeeeeee);
    
    
    UILabel *instructionTitle = [UILabel labelWithFrame:CGRectZero text:@"使用说明" color:HUAColor(0x000000) font:hua_scale(13)];
    instructionTitle.frame = CGRectMake(hua_scale(10), CGRectGetMaxY(self.valueLabel.frame)+hua_scale(50), hua_scale(100), hua_scale(13));

    UILabel *instructionLabel = [[UILabel alloc]init];
    instructionLabel.frame = CGRectMake(hua_scale(10), CGRectGetMaxY(instructionTitle.frame)+hua_scale(15), screenWidth- hua_scale(20), 0);
    instructionLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
    instructionLabel.numberOfLines = 0;
    instructionLabel.textColor = HUAColor(0x494949);
    instructionLabel.text = detailInfo.desc;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:instructionLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:10];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [instructionLabel.text length])];
    instructionLabel.attributedText = attributedString;
    
    
    [instructionLabel sizeToFit];
    HUALog(@"%f",instructionLabel.height);
    
    UIView *seperateLine = [[UIView alloc]init];
    seperateLine.backgroundColor = HUAColor(0xeeeeee);
    
    UILabel *goodsDetailLabel = [UILabel labelWithFrame:CGRectZero text:@"商品详情" color:HUAColor(0x000000) font:hua_scale(13)];
    
    if (instructionLabel.height < 27) {
        seperateLine.frame = CGRectMake(hua_scale(10), CGRectGetMaxY(instructionLabel.frame)+hua_scale(25)-10, screenWidth-hua_scale(20), 0.5);
        
        
        goodsDetailLabel.frame = CGRectMake(hua_scale(10),  CGRectGetMaxY(instructionLabel.frame)+hua_scale(50)-10, hua_scale(100), hua_scale(13));
        
        
        
        CGFloat height = CGRectGetMaxY(goodsDetailLabel.frame)+hua_scale(15)-10;
        header.frame = CGRectMake(0, 0, screenWidth, height);

    }else {
        seperateLine.frame = CGRectMake(hua_scale(10), CGRectGetMaxY(instructionLabel.frame)+hua_scale(25), screenWidth-hua_scale(20), 0.5);
        
        
        goodsDetailLabel.frame = CGRectMake(hua_scale(10),  CGRectGetMaxY(instructionLabel.frame)+hua_scale(50), hua_scale(100), hua_scale(13));
        
        
        
        CGFloat height = CGRectGetMaxY(goodsDetailLabel.frame)+hua_scale(15);
        header.frame = CGRectMake(0, 0, screenWidth, height);

    }
    
    
    
    [header addSubview:topSeparateLine];
    [header addSubview:instructionTitle];
    [header addSubview:instructionLabel];
    [header addSubview:seperateLine];
    [header addSubview:goodsDetailLabel];
    
    self.tableView.tableHeaderView = header;
    //回调block，跳转到购买页面
    [header setPusViewsBlock:^{
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
            HUAProductsToBuyViewController *vc = [HUAProductsToBuyViewController new];
            vc.product_id = self.product_id;
            if ([[self.membersInformation[@"info"]class] isSubclassOfClass:[NSString class]]) {
                //不是会员
                vc.typeBool = NO;
            }else{
                //是会员
                vc.typeBool = YES;
                vc.membersName = self.membersInformation[@"info"][@"nickname"];
                vc.membersType = self.membersInformation[@"info"][@"level"];
                vc.membersMoney = self.membersInformation[@"info"][@"money"];
            }
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];

}





#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.photoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HUAProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:self.photoArray[indexPath.row]] placeholderImage:nil];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.row == self.photoArray.count-1) {
        return hua_scale(191)+24;
    }else {
        return hua_scale(191)+5;
    }
}
@end
