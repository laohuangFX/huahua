//
//  HUAServiceOrderDetailsViewController.m
//  Flower
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAServiceOrderDetailsViewController.h"
#import "HUATranslateTime.h"
#import "HUAServiceDetailController.h"
@interface HUAServiceOrderDetailsViewController (){
    UIImageView *_iconImage;//头像
    UILabel     *_name;//商品名称
    UILabel     *_money;//金钱

    //订单信息类
    UILabel     *_orderID;//订单号
    UILabel     *_technician;//技师
    UILabel     *_unitPrice;//单价
    UILabel     *_downTime;//下单时间
    UILabel     *_time;//预约时间
    UILabel     *_state;//状态
    
    //服务内容类
    UILabel     *_serve;//服务内容文本
    
    
}
@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)NSDictionary *modelDic;
@end

@implementation HUAServiceOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getData];
    
    
}
- (void)getData{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSLog(@"%@",token);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [HUA_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"user/bill_detail_service?bill_id=%@&service_id=%@",self.bill_id,self.service_id]];
    
    NSLog(@"%@",url);
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    //parameter[@"per_page"] = @"1";
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        //NSLog(@"%@",dic);
        self.modelDic = dic[@"info"][@"service"];
        
        //初始化
        [self initScrollView];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];

}

- (void)initScrollView{
    self.scrollView = [UIScrollView new];
    [self.view addSubview:self.scrollView];
    
    //1线
    UIView *thView = [UIView new];
    thView.backgroundColor = HUAColor(0xeeeeee);
    [_scrollView addSubview:thView];
    [thView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_equalTo(hua_scale(10));
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-10));
        make.height.mas_equalTo(hua_scale(1));
        make.top.mas_equalTo(hua_scale(75));
    }];
    
    //背景图
    UIView *backView = [UIView new];
    //backView.backgroundColor = [UIColor yellowColor];
    [_scrollView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(thView.mas_top);
        make.top.mas_equalTo(0);
    }];
    //添加手势
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
    
    //图像
    _iconImage = [UIImageView new];
    //_iconImage.backgroundColor = [UIColor redColor];
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:self.modelDic[@"item"][@"cover"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [backView addSubview:_iconImage];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hua_scale(15));
        make.left.mas_equalTo(self.view.mas_left).mas_equalTo(hua_scale(10));
        make.bottom.mas_equalTo(thView.mas_top).mas_equalTo(hua_scale(-15));
        make.width.mas_equalTo(hua_scale(75));
    }];
    
    //商品名称
    _name = [UILabel labelText:@"满修雷顿水润" color:nil font:hua_scale(11)];
    //_name = [UILabel labelWithFrame:CGRectMake(30, 30, 40, 40) text:@"ssss" color:nil font:12];
    [backView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconImage.mas_right).mas_equalTo(hua_scale(10));
        make.top.mas_equalTo(backView.mas_top).mas_equalTo(hua_scale(20));
    }];
    
    [_name setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //金钱
    _money = [UILabel labelText:@"" color:HUAColor(0x4da800) font:hua_scale(15)];
    [backView addSubview:_money];
    [_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_name);
        make.top.mas_equalTo(_name.mas_bottom).mas_equalTo(hua_scale(7));
    }];
    [_money setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];

    
    
    //向右箭头图标
    UIImageView *iconsImage =[UIImageView new];
    iconsImage.image = [UIImage imageNamed:@"select_right"];
    //iconsImage.backgroundColor = [UIColor redColor];
    [backView addSubview:iconsImage];
    [iconsImage  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(hua_scale(-15));
        make.height.width.mas_equalTo(10);
    }];
    

    //订单信息
    UILabel *order = [UILabel labelText:@"订单信息" color:HUAColor(0x000000) font:hua_scale(13)];
    [_scrollView addSubview:order];
    [order mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView.mas_bottom).mas_equalTo(hua_scale(25));
        make.left.mas_equalTo(thView);
    }];
    [order setSingleLineAutoResizeWithMaxWidth:200];
    order.sd_layout
    .autoHeightRatio(0);
    
    
    NSArray *array = @[@"订单号:",@"技师:",@"单价:",@"下单时间:",@"预约时间:",@"状态 :"];
    //订单号
    UIView *lastLabel = nil;
    UIView *fileLbale = nil;
    for (int i = 0; i < array.count; i++) {
        
        UILabel *label = [UILabel labelText:array[i] color:HUAColor(0x999999) font:hua_scale(11)];
        [_scrollView addSubview:label];
        [label setSingleLineAutoResizeWithMaxWidth:200];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(order);
            if (i==0) {
                make.top.mas_equalTo(order.mas_bottom).mas_equalTo(hua_scale(15));
                
            }else{
                make.top.mas_equalTo(lastLabel.mas_bottom).mas_equalTo(hua_scale(10));
            }
        }];
        if (i==0) {
            fileLbale = label;
        }
        //记录上一个视图
        lastLabel = label;
    }
        
    //订单号
    _orderID = [UILabel labelText:@"1234567890" color:HUAColor(0x4da800) font:hua_scale(15)];
    [_scrollView addSubview:_orderID];
    [_orderID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lastLabel.mas_right).mas_equalTo(hua_scale(30));
        make.bottom.mas_equalTo(fileLbale);
    }];
    [_orderID setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];

    
    //订单信息类
    //技师
    _technician = [UILabel labelText:@"张三" color:nil font:hua_scale(11)];
    [_scrollView addSubview:_technician];
    [_technician mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_orderID.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_orderID);
    }];
    [_technician setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //单价
    _unitPrice = [UILabel labelText:@"¥ 349" color:nil font:hua_scale(11)];
    [_scrollView addSubview:_unitPrice];
    [_unitPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_technician.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_technician);
    }];
    [_unitPrice setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //下单时间
    _downTime = [UILabel labelText:@"2015-08-08 10:30" color:HUAColor(0x999999) font:hua_scale(11)];
    [_scrollView addSubview:_downTime];
    [_downTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_unitPrice.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_unitPrice);
    }];
    [_downTime setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //预约时间
    _time = [UILabel labelText:@"2015-08-08 10:30" color:HUAColor(0x999999) font:hua_scale(11)];
    
    [_scrollView addSubview:_time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_downTime.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_downTime);
    }];
    [_time setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //状态
    _state = [UILabel labelText:@"未使用/已交易完成" color:HUAColor(0x999999) font:hua_scale(11)];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:_state.text];
    [attributed addAttributes:@{NSForegroundColorAttributeName:HUAColor(0x4da800)} range:NSMakeRange(0, 3)];
    _state.attributedText = attributed;
    [_scrollView addSubview:_state];
    [_state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_time.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_time);
    }];
    [_state setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];

    
    //2线
    UIView *thView2 = [UIView new];
    thView2.backgroundColor = HUAColor(0xeeeeee);
    [_scrollView addSubview:thView2];
    [thView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(thView);
        make.top.mas_equalTo(_state.mas_bottom).mas_equalTo(hua_scale(25));
        make.height.mas_equalTo(1);
    }];
    
    //服务内容
    UILabel *serveLabel = [UILabel labelText:@"服务内容" color:nil font:hua_scale(13)];
    [_scrollView addSubview:serveLabel];
    [serveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(thView2);
        make.top.mas_equalTo(thView2.mas_bottom).mas_equalTo(hua_scale(25));
    }];
    [serveLabel setSingleLineAutoResizeWithMaxWidth:200];

   
    //服务内容文本
    _serve = [UILabel labelText:@"服务流程:温柔乡按摩,服务流程:温柔乡按摩,服务流程:温柔乡按摩,服务流程:温柔乡按摩,服务流程:温柔乡按摩,服务流程:温柔乡按摩,服务流程:温柔乡按摩,服务流程:温柔乡按摩,服务流程:温柔乡按摩,服务流程:温柔乡按摩,服务流程:温柔乡按摩,服务流程:温柔乡按摩,;" color:HUAColor(0x494949) font:hua_scale(11)];
    _serve.numberOfLines = 0;
 
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_serve.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:hua_scale(10)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_serve.text length])];
    _serve.attributedText = attributedString;
    [_scrollView addSubview:_serve];
    [_serve sizeToFit];
    [_serve mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(thView2);
        make.right.mas_equalTo(thView2);
        make.top.mas_equalTo(serveLabel.mas_bottom).mas_equalTo(hua_scale(15));
    }];
    
    
    //3线
    UIView *thView3 = [UIView new];
    thView3.backgroundColor = HUAColor(0xeeeeee);
    [_scrollView addSubview:thView3];
    [thView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(thView);
        make.top.mas_equalTo(_serve.mas_bottom).mas_equalTo(hua_scale(25));
        make.height.mas_equalTo(1);
    }];
   
    NSDictionary *itemDic = self.modelDic[@"item"];
    //赋值
    
    _name.text = itemDic[@"name"];//商品名称
    _money.text = [NSString stringWithFormat:@"¥ %ld",[itemDic[@"price"] integerValue]];//金钱
    
    //订单信息类
    _orderID.text = self.bill_id;//订单号
    //_technician.text = ;//技师
    _unitPrice.text = [NSString stringWithFormat:@"¥ %@",itemDic[@"price"]];//单价
    _downTime.text = [HUATranslateTime translateTimeIntoCurrurents:[itemDic[@"create_time"] integerValue]];//下单时间
    //UILabel     *_time;//预约时间

    if ([self.is_use isEqualToString:@"0"]) {
        _state.text = @"未使用 / 已完成交易" ;//状态
        [HUAConstRowHeight adjustTheLabel:_state adjustColor:HUAColor(0x4da800) adjustRang:NSMakeRange(0, 3)];
        
    }else{
        _state.text = @"未使用 / 已完成交易" ;//状态
        [HUAConstRowHeight adjustTheLabel:_state adjustColor:HUAColor(0x4da800) adjustRang:NSMakeRange(6, 5)];
    }
    
    
    //服务内容类
    _serve.text = itemDic[@"desc"];//服务内容文本
    

    
    
    
    
    //商品详情
    UILabel *label = [UILabel labelText:@"商品详情" color:nil font:hua_scale(13)];
    [_scrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView3.mas_bottom).mas_equalTo(hua_scale(25));
        make.left.mas_equalTo(thView3);
    }];
    [label setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //NSArray *imageArray = self.modelDic[@"media_lis"];
    //图片
    UIView *imageV = nil;
    NSArray *imageArray = self.modelDic[@"media_lis"];
    for (int i = 0; i<imageArray.count; i++) {
        UIImageView *image = [UIImageView new];
        image.backgroundColor = [UIColor yellowColor];
        [image sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [_scrollView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(hua_scale(10));
            make.size.mas_equalTo(CGSizeMake(hua_scale(300), hua_scale(191)));
            if (i==0) {
                make.top.mas_equalTo(label.mas_bottom).mas_equalTo(hua_scale(15));
            }else{
                make.top.mas_equalTo(imageV.mas_bottom).mas_equalTo(hua_scale(5));
            }
            
        }];
        imageV = image;
    }

    
    
    //scrollView自适应
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [self.scrollView setupAutoContentSizeWithBottomView:imageV bottomMargin:hua_scale(25)];
    
}

- (void)click:(UITapGestureRecognizer *)tap{
    HUAServiceDetailController *vc = [HUAServiceDetailController new];
    vc.service_id = self.service_id;
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"点击跳转");

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
