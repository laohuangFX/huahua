//
//  HUAProductDetailController.m
//  Flower
//
//  Created by 程召华 on 16/1/13.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Product_detail @"general/product_detail"
#import "HUAProductDetailController.h"
#import "HUATopInfoView.h"
#import "HUAProductDetailInfo.h"
#import "HUAProductsToBuyViewController.h"
#import "HUAProductDetailCell.h"


@interface HUAProductDetailController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *photoArray;
@property (nonatomic, strong) HUAProductDetailInfo *detailInfo;
@end

@implementation HUAProductDetailController

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
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品详情";
    [self.view addSubview:self.tableView];
}



- (void)getData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    NSString *url = [HUA_URL stringByAppendingPathComponent:Product_detail];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"product_id"] = self.product_id;
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        self.detailInfo = [HUAProductDetailInfo getProductDetailInfoWithDictionary:responseObject[@"item"]];
        self.photoArray = responseObject[@"media_lis"];
        HUALog(@"%@",responseObject);
        [self setTableViewHeadrView:self.detailInfo];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
}

#pragma mark - tableViewHeaderView

- (void)setTableViewHeadrView:(HUAProductDetailInfo *)detailInfo {
    
    UILabel *instructionLabel = [[UILabel alloc]init];
    instructionLabel.frame = CGRectMake(hua_scale(10), hua_scale(617), screenWidth- hua_scale(20), 0);
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
    
    UIView *seperateLine = [[UIView alloc]initWithFrame:CGRectMake(hua_scale(10), instructionLabel.y+instructionLabel.height+hua_scale(25), screenWidth-hua_scale(20), 0.5)];
    seperateLine.backgroundColor = HUAColor(0xeeeeee);
    
    CGRect frame = CGRectMake(hua_scale(10), instructionLabel.y+instructionLabel.height+hua_scale(50), hua_scale(100), hua_scale(13));
    UILabel *goodsDetailLabel = [UILabel labelWithFrame:frame text:@"商品详情" color:HUAColor(0x000000) font:hua_scale(13)];

    CGFloat height = instructionLabel.height + hua_scale(697);
    HUATopInfoView *header = [[HUATopInfoView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, height)];
    [header addSubview:instructionLabel];
    [header addSubview:seperateLine];
    [header addSubview:goodsDetailLabel];
    header.detailInfo = detailInfo;
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
            HUAProductsToBuyViewController *buyVC = [HUAProductsToBuyViewController new];
            buyVC.product_id = self.product_id;
            [self.navigationController pushViewController:buyVC animated:YES];
        }
        
    }];

}



#pragma mark - navigationitem
- (void)setNavigationItem {

    UIButton *praiseButton = [UIButton buttonWithType:0];
    praiseButton.frame = CGRectMake(hua_scale(268), hua_scale(9), hua_scale(42), hua_scale(16));
    [praiseButton setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
    [praiseButton setTitle:@"11" forState:UIControlStateNormal];
    [praiseButton setTitleColor:HUAColor(0x000000) forState:UIControlStateNormal];
    praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    praiseButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    
    praiseButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(14)];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:praiseButton]];
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.photoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HUAProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:self.photoArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
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
