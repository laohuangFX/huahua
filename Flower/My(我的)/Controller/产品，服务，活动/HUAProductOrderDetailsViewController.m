//
//  HUAProductOrderDetailsViewController.m
//  Flower
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAProductOrderDetailsViewController.h"
#import "HUAProductDetailController.h"
#define Bill_list user/bill_detail_product
@interface HUAProductOrderDetailsViewController ()
{
    UIImageView *_iconImage;//头像
    UILabel     *_name;//商品名称
    UILabel     *_specificationsLabel;//规格
    UILabel     *_money;//金钱
    UILabel     *_memberMoney;//会员价
    
    //订单信息类
    UILabel     *_orderID;//订单号
    UILabel     *_number;//数量
    UILabel     *_sumMoney;//总价
    UILabel     *_time;//下单时间
    UILabel     *_state;//状态
    
    //商品信息
    UILabel     *_brand;//品牌
    UILabel     *_place;//产地
    UILabel     *_effect;//功效
    UILabel     *_guaranteePeriod;//保质期
    UILabel     *_SuitableSkinTypes;//适合肤质
    UILabel     *_instructions;//特别说明
    UILabel     *_specifications;//规格型号
    
    
    //使用说明
    UILabel     *_instructionsContent;//使用内容
    UILabel     *_installationLabel;//安装内容
}

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic, strong)NSDictionary *modelDic;
@end

@implementation HUAProductOrderDetailsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"订单详情";
    //获取网络数据
    [self getData];
}

//获取网络数据
- (void)getData{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSLog(@"%@",token);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [HUA_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"user/bill_detail_product?bill_id=%@&product_id=%@",self.bill_num,self.product_id]];
    
    NSLog(@"%@",url);
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    //parameter[@"per_page"] = @"1";
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        self.modelDic = dic[@"info"][@"product"];
  
        [self initScrollView];
    
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
    


}

//自定义scrollView
- (void)initScrollView{
    
    
    UIView *mainView = self.view;
    
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
        make.top.mas_equalTo(hua_scale(105));
    }];
    
    //背景图
    UIView *backView = [UIView new];
    //backView.backgroundColor = [UIColor yellowColor];
    [_scrollView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(mainView);
        make.bottom.mas_equalTo(thView.mas_top);
        make.top.mas_equalTo(0);
    }];
    //添加手势
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
    
    //图像
    _iconImage = [UIImageView new];
    _iconImage.backgroundColor = [UIColor redColor];
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:self.modelDic[@"item"][@"cover"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [backView addSubview:_iconImage];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hua_scale(15));
        make.left.mas_equalTo(mainView.mas_left).mas_equalTo(hua_scale(10));
        make.bottom.mas_equalTo(thView.mas_top).mas_equalTo(hua_scale(-15));
        make.width.mas_equalTo(hua_scale(75));
    }];
    
    //商品名称
    _name = [UILabel labelText:@"满修雷顿水润" color:nil font:hua_scale(11)];
    //_name = [UILabel labelWithFrame:CGRectMake(30, 30, 40, 40) text:@"ssss" color:nil font:12];
    [backView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconImage.mas_right).mas_equalTo(hua_scale(10));
        make.top.mas_equalTo(backView.mas_top).mas_equalTo(hua_scale(25));
    }];
    
    [_name setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //规格
    _specificationsLabel = [UILabel labelText:@"规格 : 700mm x 700mm" color:HUAColor(0x999999) font:10];
    [backView addSubview:_specificationsLabel];
    [_specificationsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_name.mas_bottom).mas_equalTo(hua_scale(7));
        make.left.mas_equalTo(_name);
    }];
    [_specificationsLabel setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    _specificationsLabel.sd_layout
    .autoHeightRatio(0);

    //金钱
    _money = [UILabel labelText:@"¥349" color:HUAColor(0x4da800) font:hua_scale(15)];
    [backView addSubview:_money];
    [_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_name);
        make.top.mas_equalTo(_specificationsLabel.mas_bottom).mas_equalTo(hua_scale(7));
    }];
    [_money setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    _money.sd_layout
    .autoHeightRatio(0);
    
    
    //会员价
    _memberMoney =[UILabel labelText:@"(会员价 ¥300)" color:HUAColor(0x4da800) font:hua_scale(10)];
    [backView addSubview:_memberMoney];
    [_memberMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_money.mas_right).mas_equalTo(hua_scale(5));
        make.centerY.mas_equalTo(_money);
    }];
    [_memberMoney setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    _memberMoney.sd_layout
    .autoHeightRatio(0);
    
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
    
    
    NSArray *array = @[@"订单号:",@"数量:",@"总价:",@"下单时间:",@"状态 :"];
    //订单号
    UIView *lastLabel = nil;
    UIView *fileLbale = nil;
    for (int i = 0; i < 5; i++) {
       
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
    
    //数量
    _number = [UILabel labelText:@"1" color:HUAColor(0x999999) font:hua_scale(11)];
    [_scrollView addSubview:_number];
    [_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_orderID.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_orderID);
    }];
    [_number setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //总价
    _sumMoney = [UILabel labelText:@"200" color:HUAColor(0x999999) font:hua_scale(11)];
    [_scrollView addSubview:_sumMoney];
    [_sumMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_number.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_number);
    }];
    [_sumMoney setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //下单时间
    _time = [UILabel labelText:@"2015-08-08 10:30" color:HUAColor(0x999999) font:hua_scale(11)];
    [_scrollView addSubview:_time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_sumMoney.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_sumMoney);
    }];
    [_time setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //状态
    _state = [UILabel labelText:@"等待发货/等待取货" color:HUAColor(0x999999) font:hua_scale(11)];
    _state.tag = 289;
    [_scrollView addSubview:_state];
    [_state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_time.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_time);
    }];
    [_state setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
   
    //确认收货
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.backgroundColor = HUAColor(0x4da800);
    [confirmButton setTitle:@"确认收货" forState:0];
    [confirmButton setTitleColor:HUAColor(0xffffff) forState:0];
    if ([self.is_receipt isEqualToString:@"1"]) {
        confirmButton.hidden = NO;
    }else{
        confirmButton.hidden = YES;
    }

    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_state.mas_bottom).mas_equalTo(hua_scale(20));
        make.size.mas_equalTo(CGSizeMake(hua_scale(280),hua_scale(44)));
        make.centerX.mas_equalTo(0);
    }];
    
    //2线
    UIView *thView2 = [UIView new];
    thView2.backgroundColor = HUAColor(0xeeeeee);
    thView2.tag = 288;
    [_scrollView addSubview:thView2];
    //判断button是否存在
    if (confirmButton.hidden == YES) {
        [thView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lastLabel.mas_bottom).mas_equalTo(hua_scale(25));
            make.left.right.mas_equalTo(thView);
            make.height.mas_equalTo(hua_scale(1));
        }];
    }else{
        [thView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(confirmButton.mas_bottom).mas_equalTo(hua_scale(25));
            make.left.right.mas_equalTo(thView);
            make.height.mas_equalTo(hua_scale(1));
        }];
    }
  
    //订单信息
    UILabel *shop = [UILabel labelText:@"商品信息" color:HUAColor(0x000000) font:hua_scale(13)];
    [_scrollView addSubview:shop];
    [shop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView2.mas_bottom).mas_equalTo(hua_scale(25));
        make.left.mas_equalTo(thView2);
    }];
    [shop setSingleLineAutoResizeWithMaxWidth:200];
 
    
    
    NSArray *array2 = @[@"品牌 :",@"产地  :",@"功 效:",@"保质期:",@"适合肤质 :",@"特别说明 :",@"规格型号"];
    //订单号
    UIView *lastLabel2 = nil;
    UIView *fileLbale2 = nil;
    for (int i = 0; i < array2.count; i++) {
        
        UILabel *label = [UILabel labelText:array2[i] color:HUAColor(0x999999) font:hua_scale(11)];
        [_scrollView addSubview:label];
        [label setSingleLineAutoResizeWithMaxWidth:200];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(order);
            if (i==0) {
                make.top.mas_equalTo(shop.mas_bottom).mas_equalTo(hua_scale(15));
                
            }else{
                make.top.mas_equalTo(lastLabel2.mas_bottom).mas_equalTo(hua_scale(10));
            }
        }];
        if (i==0) {
            fileLbale2 = label;
        }
        //记录上一个视图
        lastLabel2 = label;
    }

    //品牌
    _brand = [UILabel labelText:@"蓝格子" color:HUAColor(0x4da800) font:hua_scale(11)];
    [_scrollView addSubview:_brand];
    [_brand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lastLabel2.mas_right).mas_equalTo(hua_scale(100));
        make.bottom.mas_equalTo(fileLbale2);
    }];
    [_brand setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //产地
    _place = [UILabel labelText:@"广州" color:HUAColor(0x4da800) font:hua_scale(11)];
    [_scrollView addSubview:_place];
    [_place mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_brand.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_brand);
    }];
    [_place setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];

    //功效
    _effect = [UILabel labelText:@"收纳" color:HUAColor(0x4da800) font:hua_scale(11)];
    [_scrollView addSubview:_effect];
    [_effect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_place.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_place);
    }];
    [_effect setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //保质期
    _guaranteePeriod = [UILabel labelText:@"2018.06.30" color:HUAColor(0x4da800) font:hua_scale(11)];
    [_scrollView addSubview:_guaranteePeriod];
    [_guaranteePeriod mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_effect.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_effect);
    }];
    [_guaranteePeriod setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //适合肤质
    _SuitableSkinTypes = [UILabel labelText:@"非过敏性皮肤" color:HUAColor(0x4da800) font:hua_scale(11)];
    [_scrollView addSubview:_SuitableSkinTypes];
    [_SuitableSkinTypes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_guaranteePeriod.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_guaranteePeriod);
    }];
    [_SuitableSkinTypes setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];

    
    _instructions = [UILabel labelText:@"无" color:HUAColor(0x4da800) font:hua_scale(11)];
    [_scrollView addSubview:_instructions];
    [_instructions mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_SuitableSkinTypes.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_SuitableSkinTypes);
    }];
    [_instructions setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];

    
    _specifications = [UILabel labelText:@"规格型号" color:HUAColor(0x4da800) font:hua_scale(11)];
    [_scrollView addSubview:_specifications];
    [_specifications mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_instructions.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_instructions);
    }];
    [_specifications setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];

    //3线
    UIView *thView3 = [UIView new];
    thView3.backgroundColor = HUAColor(0xeeeeee);
    [_scrollView addSubview:thView3];
    [thView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(mainView.mas_left).mas_equalTo(hua_scale(10));
        make.right.mas_equalTo(mainView.mas_right).mas_equalTo(hua_scale(-10));
        make.top.mas_equalTo(_specifications.mas_bottom).mas_equalTo(hua_scale(25));
        make.height.mas_equalTo(1);
    }];
    
    //使用说明
    UILabel *directions = [UILabel labelText:@"使用说明" color:nil font:hua_scale(13)];
    [_scrollView addSubview:directions];
    [directions mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(thView3);
        make.top.mas_equalTo(thView3.mas_bottom).mas_equalTo(hua_scale(25));
    }];
    [directions setSingleLineAutoResizeWithMaxWidth:200];
    
    //需要注意
    UILabel *payAttentionTo = [UILabel labelText:@"需要注意什么呀:" color:HUAColor(0x4da800) font:(hua_scale(11))];
    //payAttentionTo.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:payAttentionTo];
    [payAttentionTo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(directions.mas_bottom).mas_equalTo(hua_scale(15));
        make.left.mas_equalTo(directions);
    }];
    [payAttentionTo setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //注意内容
    _instructionsContent = [UILabel labelText:@"需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀" color:HUAColor(0x494949) font:(hua_scale(11))];
    _instructionsContent.numberOfLines = 0;
    //调整行间距
    NSMutableAttributedString *attributedStrings = [[NSMutableAttributedString alloc] initWithString:_instructionsContent.text];
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyles setLineSpacing:hua_scale(10)];
    [attributedStrings addAttribute:NSParagraphStyleAttributeName value:paragraphStyles range:NSMakeRange(0, [_instructionsContent.text length])];
    _instructionsContent.attributedText = attributedStrings;
    [_instructionsContent sizeToFit];
    [_scrollView addSubview:_instructionsContent];
    [_instructionsContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(payAttentionTo.mas_bottom).mas_equalTo(hua_scale(15));
        make.left.mas_equalTo(payAttentionTo);
        make.right.mas_equalTo(mainView.mas_right).mas_equalTo(hua_scale(-10));
    }];
    
    //安装流程
    UILabel *payAttentionToto = [UILabel labelText:@"安装流程:" color:HUAColor(0x4da800) font:(hua_scale(11))];
    [_scrollView addSubview:payAttentionToto];
    [payAttentionToto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_instructionsContent.mas_bottom).mas_equalTo(hua_scale(15));
        make.left.mas_equalTo(_instructionsContent);
    }];
    [payAttentionToto setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //流程内容
    _installationLabel = [UILabel labelText:@"注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀需要注意什么呀" color:HUAColor(0x494949) font:(hua_scale(11))];
    _installationLabel.numberOfLines = 0;
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_installationLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:hua_scale(10)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_installationLabel.text length])];
    _installationLabel.attributedText = attributedString;
    [_installationLabel sizeToFit];
    [_scrollView addSubview:_installationLabel];
    [_installationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(payAttentionToto.mas_bottom).mas_equalTo(hua_scale(15));
        make.left.mas_equalTo(payAttentionToto);
        make.right.mas_equalTo(mainView.mas_right).mas_equalTo(hua_scale(-10));
    }];

    //4线
    UIView *thView4 = [UIView new];
    thView4.backgroundColor = HUAColor(0xeeeeee);
    [_scrollView addSubview:thView4];
    [thView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_installationLabel.mas_bottom).mas_equalTo(hua_scale(25));
        make.left.right.mas_equalTo(_installationLabel);
        make.height.mas_equalTo(hua_scale(1));
    }];
    
    
    ////////////赋值
    NSDictionary *itmeDic = self.modelDic[@"item"];
    //商品名称
    _name.text = itmeDic[@"name"];
    //规格
    _specificationsLabel.text = [NSString stringWithFormat:@"规格 :%@",itmeDic[@"size"]];
    //金钱
    _money.text = [NSString stringWithFormat:@"¥ %ld",[itmeDic[@"price"] integerValue]];
    //会员价
    _memberMoney.text = [NSString stringWithFormat:@"(会员价 : ¥%ld)",[itmeDic[@"vip_discount"] integerValue]];
    
    //订单信息类
    _orderID.text = self.bill_num;//订单号
    //_number;//数量
    _sumMoney.text = [NSString stringWithFormat:@"%ld元",[itmeDic[@"price"] integerValue]];//总价
   // _time.text = ;//下单时间
    
    if ([self.is_receipt isEqualToString:@"0"]) {
        _state.text = @"等待发货";//状态
    }else if ([self.is_receipt isEqualToString:@"1"]){
    _state.text = @"已发货";//状态
    }else{
    _state.text = @"已经收货";//状态
    
    }
    
    NSDictionary *informationDic = self.modelDic[@"information"];
    
    //商品信息
    _brand.text = itmeDic[@"category"];//品牌
    _place.text = informationDic[@"产地"];//产地
    _effect.text = informationDic[@"功效"];//功效
    _guaranteePeriod.text = informationDic[@"保质期"];//保质期
    //UILabel     *_SuitableSkinTypes;//适合肤质
    _instructions.text = informationDic[@"yuanlai"];//特别说明
    //UILabel     *_specifications;//规格型号
    
    
    //商品详情
    UILabel *label = [UILabel labelText:@"商品详情" color:nil font:hua_scale(13)];
    [_scrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView4.mas_bottom).mas_equalTo(hua_scale(25));
        make.left.mas_equalTo(thView4);
    }];
    [label setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    NSArray *imageArray = self.modelDic[@"media_lis"];
    //图片
    UIView *imageV = nil;
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
    
    
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [self.scrollView setupAutoContentSizeWithBottomView:imageV bottomMargin:hua_scale(25)];

}

- (void)click:(UITapGestureRecognizer *)tap{
   
    HUAProductDetailController *vc = [HUAProductDetailController new];
    vc.product_id = self.product_id;
    vc.shop_id = self.shop_id;
    [self.navigationController pushViewController:vc animated:YES];
    
    HUALog(@"点击跳转");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//确认收货
- (void)confirm:(UIButton *)sender{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收货" message:@"确认收货" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
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
        NSDictionary *parameters = @{@"bill_id":self.bill_num};
        
        NSString *url = [HUA_URL stringByAppendingPathComponent:@"user/confirm_receipt"];
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            
            NSLog(@"%@",dic);
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
            NSLog(@"%@",error);
            
        }];
        
        
        sender.hidden = YES;
        UIView *thview = [_scrollView viewWithTag:288];
        UILabel *lable = [_scrollView viewWithTag:289];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [thview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lable.mas_bottom).mas_equalTo(hua_scale(25));
                
            }];
        }];
        
        lable.text = @"确认收货完成";
        lable.textColor = HUAColor(0x4da800);
        [_scrollView layoutSubviews];

        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [alert removeFromParentViewController];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
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
