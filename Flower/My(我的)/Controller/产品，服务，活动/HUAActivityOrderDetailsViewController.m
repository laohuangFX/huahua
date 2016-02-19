//
//  HUAActivityOrderDetailsViewController.m
//  Flower
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAActivityOrderDetailsViewController.h"
#import "HUADetailController.h"
@interface HUAActivityOrderDetailsViewController (){
    UIImageView *_iconImage;//头像
    UILabel     *_name;//商品名称
    UILabel     *_money;//金钱
    UILabel     *_memberMoney;//会员价
    
    //订单信息类
    UILabel     *_orderID;//订单号
    UILabel     *_unitPrice;//单价
    UILabel     *_numLbale;//次数
    UILabel     *_downTime;//下单时间
    UILabel     *_time;//活动时间
    UILabel     *_state;//状态
    
    //商家信息
    UILabel     *_shopName;//商店名称
    UIButton    *_addressButton;//地址button
    
    //活动时间
    UILabel     *_activityTime;//时间
    
    //活动详情
    UILabel     *_activity;//活动
    UILabel     *_activityCentent;//活动内容
    
}
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)NSDictionary *modelDic;
@end

@implementation HUAActivityOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getData];
    
    
    
}
- (void)getData{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSLog(@"%@",token);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [HUA_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"user/bill_detail_active?bill_id=%@&active_id=%@",self.bill_id,self.active_id]];
    
    NSLog(@"%@",url);
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
 
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
       // NSLog(@"%@",dic);
        self.modelDic = dic[@"info"][@"active"];
        
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
    _iconImage.backgroundColor = [UIColor redColor];
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:self.modelDic[@"active_cover"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [backView addSubview:_iconImage];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hua_scale(15));
        make.left.mas_equalTo(self.view.mas_left).mas_equalTo(hua_scale(10));
        make.bottom.mas_equalTo(thView.mas_top).mas_equalTo(hua_scale(-15));
        make.width.mas_equalTo(hua_scale(74));
    }];
    
    //商品名称
    _name = [UILabel labelText:@"满修雷顿水润" color:nil font:hua_scale(11)];
    //_name = [UILabel labelWithFrame:CGRectMake(30, 30, 40, 40) text:@"ssss" color:nil font:12];
    [backView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconImage.mas_right).mas_equalTo(hua_scale(10));
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-50));
        make.top.mas_equalTo(backView.mas_top).mas_equalTo(hua_scale(20));
    }];
    
    [_name setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //金钱
    _money = [UILabel labelText:@"¥349" color:HUAColor(0x4da800) font:hua_scale(15)];
    [backView addSubview:_money];
    [_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_name);
        make.top.mas_equalTo(_name.mas_bottom).mas_equalTo(hua_scale(7));
    }];
    [_money setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
  
    //会员价格
    _memberMoney = [UILabel labelText:@"(会员价 ¥ 300)" color:HUAColor(0x4da800) font:hua_scale(10)];
    [backView addSubview:_memberMoney];
    [_memberMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_money.mas_right).mas_equalTo(hua_scale(5));
        make.centerY.mas_equalTo(_money);
    }];
    [_memberMoney setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    
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
    
    
    NSArray *array = @[@"订单号:",@"单价:",@"次数:",@"下单时间:",@"活动时间:",@"状态 :"];
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

    //单价
    _unitPrice = [UILabel labelText:@"¥ 349" color:HUAColor(0x000000) font:hua_scale(11)];
    [_scrollView addSubview:_unitPrice];
    [_unitPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_orderID.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_orderID);
    }];
    [_unitPrice setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //次数
    _numLbale = [UILabel labelText:@"2" color:HUAColor(0x000000) font:hua_scale(11)];
    [_scrollView addSubview:_numLbale];
    [_numLbale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_unitPrice.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_unitPrice);
    }];
    [_numLbale setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //下单时间
    _downTime = [UILabel labelText:@"2015-08-08 10:30" color:HUAColor(0x999999) font:hua_scale(11)];
    [_scrollView addSubview:_downTime];
    [_downTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_numLbale.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_numLbale);
    }];
    [_downTime setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //活动时间
    _time = [UILabel labelText:@"2015-08-08 至 2015-08-30" color:HUAColor(0x999999) font:hua_scale(11)];
    
    [_scrollView addSubview:_time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_downTime.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(_downTime);
    }];
    [_time setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //状态
    _state = [UILabel labelText:@"剩余2次" color:HUAColor(0x999999) font:hua_scale(11)];
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
    
  
    
    //商家信息
    UILabel *serveLabel = [UILabel labelText:@"商家信息" color:nil font:hua_scale(13)];
    [_scrollView addSubview:serveLabel];
    [serveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(thView2);
        make.top.mas_equalTo(thView2.mas_bottom).mas_equalTo(hua_scale(25));
    }];
    [serveLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    //商店名称
    _shopName = [UILabel labelText:@"漂亮女人美容店" color:HUAColor(0x4da800) font:hua_scale(13)];
    [_scrollView addSubview:_shopName];
    [_shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(serveLabel);
        make.top.mas_equalTo(serveLabel.mas_bottom).mas_equalTo(hua_scale(15));
    }];
    [_shopName setSingleLineAutoResizeWithMaxWidth:200];
    
    //电话
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //phoneButton.backgroundColor = [UIColor redColor];
    [phoneButton setBackgroundImage:[UIImage imageNamed:@"telephone"] forState:0];
    [phoneButton addTarget:self action:@selector(phones:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:phoneButton];
    [phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-15));
        make.top.mas_equalTo(_shopName.mas_top).mas_equalTo(hua_scale(35.0/2.0)-hua_scale(25.0/2.0));
        make.size.mas_equalTo(CGSizeMake(hua_scale(25), hua_scale(25)));
    }];
    
    UIView *view =[UIView new];
    view.backgroundColor = HUAColor(0xeeeeee);
    [_scrollView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(phoneButton.mas_left).mas_equalTo(hua_scale(-20));
        make.width.mas_equalTo(hua_scale(1));
        make.top.mas_equalTo(_shopName);
        make.height.mas_equalTo(hua_scale(35));
    }];
    
    //地址
    _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addressButton setTitle:@"广州市天河区中山大道西御富科贸园B1栋402..." forState:0];
    [_addressButton setImage:[UIImage imageNamed:@"location"] forState:0];
    _addressButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(10)];
    _addressButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail,
    [_addressButton setTitleColor:HUAColor(0x969696) forState:0];
    [_addressButton setTitleEdgeInsets:UIEdgeInsetsMake(0, hua_scale(5), 0, 0)];
    [_addressButton setImageEdgeInsets:UIEdgeInsetsMake(0, hua_scale(0), 0, 0)];
    [_scrollView addSubview:_addressButton];
    [_addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.bottom.mas_equalTo(view);
        make.left.mas_equalTo(_shopName);
        make.right.mas_equalTo(view.mas_left).mas_equalTo(hua_scale(-10));
        make.height.mas_equalTo(hua_scale(12));
        make.top.mas_equalTo(_shopName.mas_bottom).mas_equalTo(hua_scale(10));
    }];
    
    //3线
    UIView *thView3 = [UIView new];
    thView3.backgroundColor = HUAColor(0xeeeeee);
    [_scrollView addSubview:thView3];
    [thView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(thView);
        make.top.mas_equalTo(_addressButton.mas_bottom).mas_equalTo(hua_scale(25));
        make.height.mas_equalTo(1);
    }];
    
    //活动时间
    UILabel *label1 = [UILabel labelText:@"活动时间" color:nil font:hua_scale(13)];
    [_scrollView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView3.mas_bottom).mas_equalTo(hua_scale(25));
        make.left.mas_equalTo(thView3);
    }];
    [label1 setSingleLineAutoResizeWithMaxWidth:200];
    
    //时间
    UILabel *timeLabel = [UILabel labelText:_time.text color:HUAColor(0x4da800) font:hua_scale(11)];
    [_scrollView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1);
        make.top.mas_equalTo(label1.mas_bottom).mas_equalTo(hua_scale(15));
    }];
    [timeLabel setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    _activityTime = timeLabel;
    
    //4线
    UIView *thView4 = [UIView new];
    thView4.backgroundColor = HUAColor(0xeeeeee);
    [_scrollView addSubview:thView4];
    [thView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(thView);
        make.top.mas_equalTo(_activityTime.mas_bottom).mas_equalTo(hua_scale(25));
        make.height.mas_equalTo(1);
    }];
    
    ///////////////赋值
    
    _name.text = self.modelDic[@"name"];//商品名称
    _money.text =[NSString stringWithFormat:@"¥ %@",self.modelDic[@"price"]] ;//金钱
    _memberMoney.text = [NSString stringWithFormat:@"(会员价 ¥ %@)",self.modelDic[@"vip_discount"]];//会员价
    
    //订单信息类
    _orderID.text = self.bill_id;//订单号
    _unitPrice.text = [NSString stringWithFormat:@"¥ %@",self.modelDic[@"price"]];//单价
    _numLbale.text = self.number;//次数
    _downTime.text = [HUATranslateTime translateTimeIntoCurrurents:[self.modelDic[@"start_time"] integerValue]];//下单时间
    
   
    _time.text = [NSString stringWithFormat:@"%@ 至 %@",[HUATranslateTime translateTimeIntoCurrurent:[self.modelDic[@"start_time"] integerValue]],[HUATranslateTime translateTimeIntoCurrurent:[self.modelDic[@"end_time"] integerValue]]];//活动时间
    _state.text = [NSString stringWithFormat:@"剩余%@次",self.number];//状态
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:_state.text];
    [attributed addAttributes:@{NSForegroundColorAttributeName:HUAColor(0x4da800)} range:NSMakeRange(2, self.number.length)];
    _state.attributedText = attributed;
    
    //商家信息
    _shopName.text = self.modelDic[@"shopname"];//商店名称
    [_addressButton setTitle:self.modelDic[@"address"] forState:0];//地址button
    
    //活动时间
    _activityTime.text = _time.text;//时间
    
    //活动详情
    _activity.text = self.modelDic[@"name"];//活动
    //_activityCentent.text = self.modelDic[@"detail"][@"article"];//活动内容

    
    
    
    
    //活动详情
    UILabel *activityTitle = [UILabel labelText:@"活动详情" color:nil font:hua_scale(13)];
    [_scrollView addSubview:activityTitle];
    [activityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView4.mas_bottom).mas_equalTo(hua_scale(25));
        make.left.mas_equalTo(thView4);
    }];
    [activityTitle setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //活动
    UILabel *activity = [UILabel labelText:self.modelDic[@"detail"][@"article"] color:HUAColor(0x969696) font:hua_scale(11)];
    activity.numberOfLines = 0;
    NSMutableAttributedString *attributedStrings = [[NSMutableAttributedString alloc] initWithString:activity.text];
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyles setLineSpacing:hua_scale(10)];
    [attributedStrings addAttribute:NSParagraphStyleAttributeName value:paragraphStyles range:NSMakeRange(0, [activity.text length])];
    activity.attributedText = attributedStrings;
    [activity sizeToFit];

    [_scrollView addSubview:activity];
    [activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(activityTitle.mas_bottom).mas_equalTo(hua_scale(15));
        make.left.mas_equalTo(thView4);
        make.right.mas_equalTo(thView4);
    }];
    //[activity setSingleLineAutoResizeWithMaxWidth:hua_scale(300)];
    _activity = activity;
    
    
    
    NSArray *imageArray = self.modelDic[@"detail"][@"txt_pic"];
    NSLog(@"%ld",imageArray.count);
    //记录上一张图片
    UIView *_lastImage = nil;
    //记录上一张label
    UIView *_lastAndLabel = nil;
    for (int i = 0; i<imageArray.count; i++) {
        //活动图片
        UIImageView *imageView1 = [[UIImageView alloc] init];
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:imageArray[i][@"pic"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [_scrollView addSubview:imageView1];
        [imageView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (i==0) {
                make.top.mas_equalTo(activity.mas_bottom).mas_equalTo(hua_scale(10));
            }else{
                make.top.mas_equalTo(_lastAndLabel.mas_bottom).mas_equalTo(hua_scale(10));
            }
            make.left.mas_equalTo(activity);
            make.size.mas_equalTo(CGSizeMake(hua_scale(300), hua_scale(165)));
        }];
        //记录上一个图片位置
         _lastImage = imageView1;
    
        
        
        _activityCentent = [UILabel labelText:@"单号武汉大武汉丢啊我还要勾搭我国的通过挖得噶玩过的与他无关的与他我发的圆通发我要头发都有他我发的圆通发武汉大武汉丢啊我还要勾搭我国的通过挖得噶玩过的武汉大武汉丢啊我还要勾搭我国的通过挖得噶玩过的武汉大武汉丢啊我还要勾搭我国的通过挖得噶玩过的武汉大武汉丢啊我还要勾搭我国的通过挖得噶玩过的武汉大武汉丢啊我还要勾搭我国的通过挖得噶玩过的" color:HUAColor(0x969696) font:hua_scale(11)];
        _activityCentent.numberOfLines = 0;
        _activityCentent.text = imageArray[i][@"text"];
        // 调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_activityCentent.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:hua_scale(10)];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_activityCentent.text length])];
        _activityCentent.attributedText = attributedString;
        [_activityCentent sizeToFit];
        [_scrollView addSubview:_activityCentent];
        [_activityCentent mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (i==0) {
                  make.top.mas_equalTo(imageView1.mas_bottom).mas_equalTo(hua_scale(10));
            }else{
                make.top.mas_equalTo(_lastImage.mas_bottom).mas_equalTo(hua_scale(10));
            
            }
            make.left.right.mas_equalTo(imageView1);
        }];

        //记录上一个label的位置
        _lastAndLabel = _activityCentent;
       

    }
    
    
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [self.scrollView setupAutoContentSizeWithBottomView:_lastAndLabel bottomMargin:hua_scale(25)];
}

- (void)click:(UITapGestureRecognizer *)tap{
    HUADetailController *vc = [HUADetailController new];
    vc.active_id = self.active_id;
    vc.shop_id =self.shop_id;
    [self.navigationController pushViewController:vc animated:YES];
    HUALog(@"跳转页面");

}

//打电话时间
- (void)phones:(UIButton *)sender{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"18271628434"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    HUALog(@"打电话");

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
