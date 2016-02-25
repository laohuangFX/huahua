//
//  HUAMasterDetailController.m
//  Flower
//
//  Created by 程召华 on 16/1/18.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Create_praise      @"user/praise"
#define Master_detail @"master/master_detail"
#import "HUAMasterDetailController.h"
#import "HUAMienCell.h"
#import "HUAMasterDetailInfo.h"
#import "STPhotoBrowserController.h"
#import "STConfig.h"
#import "UIButton+WebCache.h"
#import "HUAMakeAnAppointmentViewController.h"


@interface HUAMasterDetailController ()<UITableViewDataSource, UITableViewDelegate, SDPhotoBrowserDelegate, STPhotoBrowserDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *acheivementArray;
@property (nonatomic, strong) HUAMasterDetailInfo *masterDetailInfo;
@property (nonatomic ,strong) UIScrollView *achievementScrollView;
@property (nonatomic, strong) NSArray *serviceArray;
@property (nonatomic, strong) NSArray *mienArray;
@property (nonatomic, strong) HUAUserDetailInfo *detailInfo;
@end

@implementation HUAMasterDetailController
- (HUAUserDetailInfo *)detailInfo {
    if (!_detailInfo) {
        _detailInfo = [HUAUserDefaults getUserDetailInfo];
    }
    return _detailInfo;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-navigationBarHeight)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HUAMienCell class] forCellReuseIdentifier:@"Cell"];
        //_tableView.separatorInset = UIEdgeInsetsMake(0, hua_scale(10), 0, hua_scale(10));
        _tableView.separatorColor = HUAColor(0xcdcdcd);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)setNavigationBar {
//    UIButton *praiseButton = [UIButton buttonWithType:0];
//    praiseButton.frame = CGRectMake(hua_scale(268), hua_scale(9), hua_scale(42), hua_scale(16));
//    [praiseButton setImage:[UIImage imageNamed:@"praise_black_empty"] forState:UIControlStateNormal];
//    [praiseButton setImage:[UIImage imageNamed:@"praise_tech"] forState:UIControlStateSelected];
//    [praiseButton setTitle:self.masterDetailInfo.praise_count forState:UIControlStateNormal];
//    [praiseButton setTitleColor:HUAColor(0x000000) forState:UIControlStateNormal];
//    praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//    praiseButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
//    if ([[[[NSNumberFormatter alloc] init] stringFromNumber:self.masterDetailInfo.have_praised] isEqualToString:@"1"] ) {
//        praiseButton.selected = YES;
//        
//    }
//    [praiseButton setTitle:[NSString stringWithFormat:@"%ld",self.masterDetailInfo.praise_count.integerValue] forState:UIControlStateNormal];
//    [praiseButton addTarget:self action:@selector(clickToPraise:) forControlEvents:UIControlEventTouchUpInside];
//    
//    praiseButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(14)];
//    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:praiseButton]];
    HUAPraiseButton *praiseButton = [[HUAPraiseButton alloc] initWithFrame:CGRectMake(hua_scale(268), hua_scale(9), hua_scale(42), hua_scale(15))];
    UIBarButtonItem *leftSpace = [UIBarButtonItem leftSpace:-20];
    self.navigationItem.rightBarButtonItems = @[leftSpace,[[UIBarButtonItem alloc]initWithCustomView:praiseButton]];
    if ([[[[NSNumberFormatter alloc] init] stringFromNumber:self.masterDetailInfo.have_praised] isEqualToString:@"1"] ) {
        praiseButton.selected = YES;
        praiseButton.praiseImageView.image = [UIImage imageNamed:@"praise_tech"];
    }else {
        praiseButton.praiseImageView.image = [UIImage imageNamed:@"praise_black_empty"];
    }
    praiseButton.label.text = [NSString stringWithFormat:@"%ld",self.masterDetailInfo.praise_count.integerValue];
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
        parameter[@"target"] = @"master";
        parameter[@"id"] = self.master_id;
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
        } failure:^(NSError *error) {
            HUALog(@"%@",error);
        }];
    }
}

- (void)getData {
    NSString *url = [HUA_URL stringByAppendingPathComponent:Master_detail];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"user_id"] = self.detailInfo.user_id;
    parameters[@"master_id"] = self.master_id;
    [HUAHttpTool GETWithTokenAndUrl:url params:parameters success:^(id responseObject) {
        HUALog(@"%@",responseObject);
        self.serviceArray = responseObject[@"info"][@"service"];
        self.masterDetailInfo = [HUAMasterDetailInfo getMasterDetailInfoWithDictionary:responseObject];
        //self.masterDetailInfo = [HUAMasterDetailInfo mj_objectWithKeyValues:responseObject[@"info"][@"item"]];
        self.mienArray = [HUADataTool mienArray:responseObject];
        HUALog(@"%@",self.mienArray);
        self.acheivementArray = [HUADataTool achievementArray:responseObject];
        [self setHeaderView:self.masterDetailInfo];
        [self setNavigationBar];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
         HUALog(@"%@",error);
    }];
}


#pragma mark -- headerView
- (void)setHeaderView:(HUAMasterDetailInfo *)detailInfo {
    UIImageView *masterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, hua_scale(200))];
    [masterImageView sd_setImageWithURL:[NSURL URLWithString:detailInfo.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    CGRect nameFrame = CGRectMake(hua_scale(10), hua_scale(215), hua_scale(50), hua_scale(14)) ;
    UILabel *nameLabel = [UILabel labelWithFrame:nameFrame text:detailInfo.masterName color:HUAColor(0x333333) font:hua_scale(14)];
    [nameLabel sizeToFit];
    
    CGRect typeFrame = CGRectMake(hua_scale(20) + nameLabel.width, hua_scale(219), hua_scale(100), hua_scale(10)) ;
    UILabel *typeLabel = [UILabel labelWithFrame:typeFrame text:detailInfo.masterType color:HUAColor(0x999999) font:hua_scale(10)];
    [nameLabel sizeToFit];
    
    CGRect briefFrame = CGRectMake(hua_scale(10), hua_scale(244), screenWidth - hua_scale(20), 0) ;
    UILabel *briefLabel = [UILabel labelWithFrame:briefFrame text:detailInfo.brief color:HUAColor(0x333333) font:hua_scale(11)];
    briefLabel.numberOfLines = 0;
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:briefLabel.text];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:hua_scale(10)];//调整行间距
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [briefLabel.text length])];
    briefLabel.attributedText = attributedString1;
    [briefLabel sizeToFit];
    
    CGRect purchaseFrame = CGRectMake(hua_scale(20), hua_scale(264) + briefLabel.height, screenWidth- hua_scale(40), hua_scale(53));

    UIButton *purchaseButton = [UIButton buttonWithFrame:purchaseFrame title:@"预约" image:@"appointment" font:hua_scale(15) titleColor:HUAColor(0xffffff)];

    purchaseButton.backgroundColor = HUAColor(0x4da800);
    [purchaseButton addTarget:self action:@selector(clickToPurchase:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect achievementTitleFrame = CGRectMake(hua_scale(10), hua_scale(347) + briefLabel.height, hua_scale(100), hua_scale(13));
    UILabel *achievementTitleLabel = [UILabel labelWithFrame:achievementTitleFrame text:@"作品展示" color:HUAColor(0x000000) font:hua_scale(13)];
    
    self.achievementScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(hua_scale(10), hua_scale(373) + briefLabel.height, screenWidth - hua_scale(20), hua_scale(90))];
    self.achievementScrollView.contentSize = CGSizeMake(self.acheivementArray.count *hua_scale(94)-hua_scale(4), 0);
    self.achievementScrollView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < self.acheivementArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:0];
        button.frame = CGRectMake(hua_scale(94)*i, 0, hua_scale(90), hua_scale(90));
        [button setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.acheivementArray[i]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        button.tag = i;
        [button addTarget:self action:@selector(clickImageView:) forControlEvents:UIControlEventTouchUpInside];
        [self.achievementScrollView addSubview:button];
    }
    
    UIView *separateLine1 = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(10), hua_scale(488)+briefLabel.height, screenWidth- hua_scale(20), 0.5)];
    separateLine1.backgroundColor = HUAColor(0xcdcdcd);
    
    CGRect serviceTitleFrame = CGRectMake(hua_scale(10), hua_scale(513)+briefLabel.height, hua_scale(100), hua_scale(13));
    UILabel *serviceLabel = [UILabel labelWithFrame:serviceTitleFrame text:@"服务项目" color:HUAColor(0x000000) font:hua_scale(13)];
    
    
    
    CGFloat height = hua_scale(608)+briefLabel.height+self.serviceArray.count*hua_scale(21);
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, height)];
    
    for (int i = 0; i < self.serviceArray.count; i++) {
        CGRect labelFrame = CGRectMake(hua_scale(10), hua_scale(540)+briefLabel.height+hua_scale(21)*i, screenWidth - hua_scale(20), hua_scale(11));
        UILabel *label = [UILabel labelWithFrame:labelFrame text:[NSString stringWithFormat:@"· %@",self.serviceArray[i]] color:HUAColor(0x494949) font:hua_scale(11)];
        [header addSubview:label];
    }
    
    UIView *separateLine2 = [[UIView alloc] initWithFrame:CGRectMake(hua_scale(10), hua_scale(555)+briefLabel.height+self.serviceArray.count*hua_scale(21), screenWidth- hua_scale(20), 0.5)];
    separateLine2.backgroundColor = HUAColor(0xcdcdcd);
    
    CGRect mienTitleFrame = CGRectMake(hua_scale(10), hua_scale(580)+briefLabel.height+self.serviceArray.count*hua_scale(21), hua_scale(100), hua_scale(13));
    UILabel *mienLabel = [UILabel labelWithFrame:mienTitleFrame text:@"技师风采" color:HUAColor(0x000000) font:hua_scale(13)];
    
    
    [header addSubview:masterImageView];
    [header addSubview:nameLabel];
    [header addSubview:typeLabel];
    [header addSubview:briefLabel];
    [header addSubview:purchaseButton];
    [header addSubview:achievementTitleLabel];
    [header addSubview:self.achievementScrollView];
    [header addSubview:separateLine1];
    [header addSubview:serviceLabel];
    [header addSubview:separateLine2];
    [header addSubview:mienLabel];
    self.tableView.tableHeaderView = header;
    
}

- (void)clickToPurchase:(UIButton *)sender {
    //跳转技师预约
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
        HUAMakeAnAppointmentViewController *vc = [HUAMakeAnAppointmentViewController new];
        vc.master_id = self.master_id;
        vc.model = self.masterDetailInfo;
        vc.shop_id = self.shop_id;
        NSLog(@"%@",vc.master_id);
        [self.navigationController pushViewController:vc animated:YES];
    }
    HUALog(@"点击");
}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(STPhotoBrowserController *)browser placeholderImageForIndex:(NSInteger)index
{
    return [self.achievementScrollView.subviews[index] currentImage];
}

- (NSURL *)photoBrowser:(STPhotoBrowserController *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = self.acheivementArray[index];
    return [NSURL URLWithString:urlStr];
}



- (void)clickImageView:(UIButton *)sender {
    HUALog(@"%ld",(long)sender.tag);
    //启动图片浏览器
    STPhotoBrowserController *browserVc = [[STPhotoBrowserController alloc] init];
    browserVc.sourceImagesContainerView = self.achievementScrollView; // 原图的父控件
    browserVc.countImage = self.acheivementArray.count; // 图片总数
    browserVc.currentPage = (int)sender.tag;
    browserVc.delegate = self;
    [browserVc show];
}



#pragma mark - tableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mienArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HUAMienCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.detailInfo = self.mienArray[indexPath.row];
    cell.userInteractionEnabled = NO;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.mienArray.count-1) {
        return hua_scale(207);
    } else {
        return hua_scale(188);
    }
}
@end
