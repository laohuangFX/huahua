//
//  HUAProductsToBuyViewController.m
//  Flower
//
//  Created by apple on 16/1/17.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAProductsToBuyViewController.h"
#import "HUAChooseAddressViewController.h"
#import "HUAAddressModel.h"
@interface HUAProductsToBuyViewController ()
//个数
@property(nonatomic,strong)UILabel *numberTypelabel ;
@property (nonatomic, strong)UILabel *memberLabel;

//合计金额
@property (nonatomic, strong)UILabel *ResultLable;
//共
@property (nonatomic, strong)UILabel *commonValue;

//遮盖视图
@property (nonatomic, strong)UIView *outView;
@property (nonatomic, strong)UIView *contentView;

//金额字典
@property (nonatomic, strong)NSDictionary *moneyDic;

@property (nonatomic, strong)UIScrollView *scrollView;
//记录选定的支付方式
@property (nonatomic, strong)UIButton *selecteButton;

@end

@implementation HUAProductsToBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单确认";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self getData];
}
- (void)getData{
     NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    NSString *url = [HUA_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"product/product_prepay?product_id=%@",self.product_id]];
    NSLog(@"%@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HUALog(@"%@",responseObject);
        
        self.moneyDic = responseObject[@"info"];
        
        [self initScrollView];
        
        //自定义弹出视图
        [self popView];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
    
    
    
}

- (void)initScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:scrollView];
    
    //UIView *mianView = self.view;
    
    //商品
    UILabel *goodsLabel = [UILabel new];
    goodsLabel.text = @"商品:";
    goodsLabel.textColor = HUAColor(0x666666);
    goodsLabel.font = [UIFont systemFontOfSize:11];
    [scrollView addSubview:goodsLabel];
    goodsLabel.sd_layout
    .leftSpaceToView(scrollView,hua_scale(15))
    .heightIs(hua_scale(14));
    goodsLabel.y = (hua_scale(45.0/2.0)-hua_scale(14.0/2.0));
    [goodsLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    //商店名
    UILabel *shopName = [UILabel new];
    //shopName.backgroundColor =[UIColor redColor];
    shopName.textColor = HUAColor(0x333333);
    shopName.text = @"霸王防脱洗发水";
    shopName.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:shopName];
    shopName.sd_layout
    .leftSpaceToView(goodsLabel,hua_scale(5))
    .heightIs(hua_scale(13));
    [shopName setSingleLineAutoResizeWithMaxWidth:300];
    shopName.y = (hua_scale(45.0/2.0)-hua_scale(shopName.height/2));
    
    //1线
    UIView *thView1 = [UIView new];
    thView1.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView1];
    thView1.sd_layout
    .leftSpaceToView(scrollView,hua_scale(15))
    .topSpaceToView(scrollView,hua_scale(45))
    .heightIs(1)
    .widthIs(scrollView.width);
    
    //2线
    UIView *thView2 = [UIView new];
    thView2.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView2];
    thView2.sd_layout
    .topSpaceToView(thView1,hua_scale(50))
    .heightIs(1)
    .leftSpaceToView(scrollView,hua_scale(15))
    .widthIs(scrollView.width);
    
    //名字
    UILabel *name = [UILabel new];
    name.textColor = HUAColor(0x000000);
    name.text = self.membersName;
    name.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(13);
        make.top.mas_equalTo(thView1.mas_bottom).mas_equalTo(hua_scale(50.0/2)-hua_scale(13.0/2.0));
        make.left.mas_equalTo(hua_scale(15));
    }];
    
    //会员类型
    UILabel *memberType = [UILabel new];
    memberType.textColor = HUAColor(0x4da800);
    memberType.text = self.membersType;
    memberType.font = [UIFont systemFontOfSize:11];
    [scrollView addSubview:memberType];
    [memberType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(11);
        make.top.mas_equalTo(thView1.mas_bottom).mas_equalTo(hua_scale(50.0/2)-hua_scale(11.0/2.0));
        make.left.mas_equalTo(name.mas_right).mas_equalTo(hua_scale(5));
    }];
    
    UIImageView *basketImageView = [[UIImageView alloc] init];
    //basketImageView.backgroundColor = [UIColor redColor];
    basketImageView.image = [UIImage imageNamed:@"numer"];
    [scrollView addSubview:basketImageView];
    [basketImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(memberType);
        make.right.mas_equalTo(self.view.right-hua_scale(15));
        make.size.mas_equalTo(CGSizeMake(hua_scale(91), hua_scale(29)));
    }];
    
    //余额
    UILabel *pageLabel = [[UILabel alloc] init];
    pageLabel.text =[NSString stringWithFormat:@"余额 : ¥%ld",[self.membersMoney integerValue]] ;
    pageLabel.textColor = HUAColor(0x4da800);
    pageLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    [HUAConstRowHeight adjustTheLabel:pageLabel adjustColor:HUAColor(0x888888) adjustColorRang:NSMakeRange(0, 3) adjustFont:11 adjustFontRang:NSMakeRange(0, 3) ];
    [basketImageView addSubview:pageLabel];
    [pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        
    }];
    [pageLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    //购买数量
    UILabel *quantityLabel = [UILabel new];
    quantityLabel.text = @"购买数量";
    quantityLabel.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:quantityLabel];
    if (self.typeBool == YES) {
        [quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(13);
            make.top.mas_equalTo(thView2.mas_bottom).mas_equalTo(hua_scale(50.0/2)-hua_scale(13.0/2.0));
            make.left.mas_equalTo(hua_scale(15));
        }];
        [quantityLabel setSingleLineAutoResizeWithMaxWidth:200];
    }else{
        //不是会员 隐藏会员这行
        thView2.hidden = YES;
        basketImageView.hidden = YES;
        name.hidden = YES;
        memberType.hidden = YES;
        
        [quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(13);
            make.top.mas_equalTo(thView1.mas_bottom).mas_equalTo(hua_scale(50.0/2)-hua_scale(13.0/2.0));
            make.left.mas_equalTo(hua_scale(15));
        }];
        [quantityLabel setSingleLineAutoResizeWithMaxWidth:200];
        
    }
    
    
    
    
    //背景图
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"numer"];
    [scrollView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.right-hua_scale(15));
        make.centerY.mas_equalTo(quantityLabel);
        make.size.mas_equalTo(CGSizeMake(hua_scale(91), hua_scale(29)));
    }];
    
    //减少
    UIButton *subtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    subtractButton.tag = 189;
    [subtractButton setBackgroundImage:[UIImage imageNamed:@"btn_minus"] forState:0];
    [subtractButton setBackgroundImage:[UIImage imageNamed:@"btn_minus_select"] forState:UIControlStateSelected];
    [backImageView addSubview:subtractButton];
    [subtractButton addTarget:self action:@selector(pageAdd:) forControlEvents:UIControlEventTouchUpInside];
    [subtractButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(hua_scale(28));
        make.bottom.mas_equalTo(0);
    }];
    //增加
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.tag = 190;
    [addButton setBackgroundImage:[UIImage imageNamed:@"btn_add_select"] forState:0];
    [addButton setBackgroundImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateSelected];
    [addButton addTarget:self action:@selector(pageAdd:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(hua_scale(28));
    }];
    
    _numberTypelabel = [UILabel new];
    _numberTypelabel.font = [UIFont systemFontOfSize:13];
    _numberTypelabel.text = @"1";
    _numberTypelabel.textAlignment = NSTextAlignmentCenter;
    [backImageView addSubview:_numberTypelabel];
    [_numberTypelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(0);
        make.left.mas_equalTo(subtractButton.mas_right);
        make.right.mas_equalTo(addButton.mas_left);
    }];
    
    //3线
    UIView *thView3 = [UIView new];
    thView3.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView3];
    [thView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addButton.mas_bottom).mas_equalTo(10);
        make.width.mas_equalTo(scrollView.width);
        make.height.mas_equalTo(1);
    }];
    
    
    //4线
    UIView *thView4 = [UIView new];
    thView4.tag = 1414;
    thView4.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView4];
    thView4.sd_layout
    .topSpaceToView(thView3,hua_scale(45))
    .heightIs(1)
    .widthIs(scrollView.width);
    
    UILabel *claimType = [[UILabel alloc] init];
    claimType.text = @"取货方式";
    claimType.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:claimType];
    [claimType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView3.mas_bottom).mas_equalTo(hua_scale(45.0/2.0-13.0/2.0));
        make.left.mas_equalTo(hua_scale(15));
    }];
    [claimType setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel *markLabel = [[UILabel alloc] init];
    markLabel.text = @"*";
    markLabel.textColor = [UIColor redColor];
    markLabel.font = [UIFont systemFontOfSize:15];
    [scrollView addSubview:markLabel];
    [markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(claimType);
        make.left.mas_equalTo(claimType.mas_right).mas_equalTo(5);
    }];
    [markLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    //送货方式的按钮
    UIButton *claimBuuton = [UIButton buttonWithType:UIButtonTypeCustom];
    [claimBuuton setTitle:@"请选择" forState:0];
    claimBuuton.tag = 159;
    claimBuuton.titleLabel.font = [UIFont systemFontOfSize:11];
    [claimBuuton setTitleColor:HUAColor(0x999999) forState:0];
    [claimBuuton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, hua_scale(-100))];
    [claimBuuton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, hua_scale(10))];
    [claimBuuton setImage:[UIImage imageNamed:@"select_right"] forState:0];
    [claimBuuton addTarget:self action:@selector(claimChange:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:claimBuuton];
    [claimBuuton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(claimType);
        make.right.mas_equalTo(self.view.right-hua_scale(15));
        make.size.mas_equalTo(CGSizeMake(hua_scale(70), hua_scale(20)));
    }];
    
    //5线
    UIView *thView5 = [UIView new];
    thView5.hidden = YES;
    thView5.tag = 1002;
    thView5.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView5];
    thView5.sd_layout
    .topSpaceToView(thView4,hua_scale(59))
    .heightIs(1)
    .widthIs(scrollView.width);
    
    UIView *newView = [UIView new];
    newView.tag = 166;
    newView.backgroundColor = HUAColor(0xf8f8f8);
    newView.hidden = YES;
    [scrollView addSubview:newView];
    [newView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView4.mas_bottom);
        make.height.mas_equalTo(hua_scale(59));
        make.left.right.mas_equalTo(self.view);
        
    }];
    
    //新增地址
    UIButton *newAddress = [UIButton buttonWithType:UIButtonTypeCustom];
    [newAddress setTitle:@"新增地址" forState:0];
    newAddress.tag = 1000;
    //先隐藏
    newAddress.hidden = YES;
    //newAddress.backgroundColor = [UIColor yellowColor];
    newAddress.titleLabel.font = [UIFont systemFontOfSize:13];
    [newAddress setTitleColor:HUAColor(0x494949) forState:0];
    newAddress.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [newAddress setImageEdgeInsets:UIEdgeInsetsMake(0, hua_scale(70), 0, 0)];
    [newAddress setTitleEdgeInsets:UIEdgeInsetsMake(0, hua_scale(6), 0, 0)];
    [newAddress setImage:[UIImage imageNamed:@"select_right"] forState:0];
    [newAddress addTarget:self action:@selector(address:) forControlEvents:UIControlEventTouchUpInside];
    
    [newView addSubview:newAddress];
    [newAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        
    }];
    
    //有地址类型
    //地址名字，电话
    UILabel *lable1 = [UILabel labelText:@"" color:HUAColor(0x333333) font:hua_scale(13)];
    lable1.tag = 202;
    lable1.hidden = YES;
    [newAddress addSubview:lable1];
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hua_scale(13));
        make.left.mas_equalTo(hua_scale(15));
    }];
    [lable1 setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    //详情地址
    UILabel *label2 = [UILabel labelText:@"" color:HUAColor(0x888888) font:hua_scale(11)];
    label2.tag = 201;
    label2.hidden = YES;
    [newAddress addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(hua_scale(-13));
        make.left.mas_equalTo(lable1);
    }];
    [label2 setSingleLineAutoResizeWithMaxWidth:hua_scale(250)];
    //图标
    UIImageView *imageView = [UIImageView new];
    imageView.hidden = YES;
    imageView.tag = 200;
    imageView.image = [UIImage imageNamed:@"select_right"];
    [newAddress addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(hua_scale(12), hua_scale(12)));
        make.right.mas_equalTo(hua_scale(-15));
    }];
    
    
    UILabel *modeLabel = [[UILabel alloc] init];
    modeLabel.text = @"支付方式";
    modeLabel.tag = 1001;
    modeLabel.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:modeLabel];
    if (newAddress.hidden == YES) {
        [modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(thView4.mas_bottom).mas_equalTo(hua_scale(15));
            make.left.mas_equalTo(hua_scale(15));
        }];
        
    }else{
        [modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(thView5.mas_bottom).mas_equalTo(hua_scale(15));
            make.left.mas_equalTo(hua_scale(15));
        }];
    }
    
    UIImageView *iocnImage = [[UIImageView alloc] init];
    iocnImage.image = [UIImage imageNamed:@"vip1"];
    [scrollView addSubview:iocnImage];
    [iocnImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hua_scale(15));
        make.top.mas_equalTo(modeLabel.mas_bottom).mas_equalTo(hua_scale(10));
        make.height.mas_equalTo(hua_scale(27));
        make.width.mas_equalTo(hua_scale(25));
    }];
    
    UILabel *huiyuanLbale  = [[UILabel alloc] init];
    huiyuanLbale.text = @"会员余额";
    huiyuanLbale.font = [UIFont systemFontOfSize:11];
    [scrollView addSubview:huiyuanLbale];
    [huiyuanLbale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iocnImage.mas_right).mas_equalTo(hua_scale(8));
        make.top.mas_equalTo(iocnImage);
    }];
    [huiyuanLbale setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UILabel *title  = [[UILabel alloc] init];
    title.text = @"使用会员余额,服务价格降低";
    title.font = [UIFont systemFontOfSize:9];
    title.textColor = HUAColor(0x4da800);
    [scrollView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iocnImage.mas_right).mas_equalTo(hua_scale(8));
        make.bottom.mas_equalTo(iocnImage.mas_bottom);
    }];
    [title setSingleLineAutoResizeWithMaxWidth:200];
    [modeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    //6线
    UIView *thView6 = [UIView new];
    thView6.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView6];
    thView6.sd_layout
    .leftSpaceToView(scrollView,hua_scale(15))
    .topSpaceToView(title,hua_scale(10))
    .heightIs(1)
    .widthIs(scrollView.width);
    
    [thView6 updateLayout];
    [iocnImage updateLayout];
    //手势背景
    UIView *tapView1 = [UIView new];
    tapView1.backgroundColor = [UIColor clearColor];
    tapView1.tag = 1231;
    [tapView1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton:)]];
    [scrollView addSubview:tapView1];
    tapView1.sd_layout
    .topEqualToView(iocnImage)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(thView6);
    
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.tag = 191;
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"do_not_select"] forState:0];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"chooseButton_yes"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(seleteAdd:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.right-hua_scale(15));
        //make.top.mas_equalTo(iocnImage);
        make.centerY.mas_equalTo(iocnImage);
        make.height.mas_equalTo(hua_scale(15));
        make.width.mas_equalTo(hua_scale(15));
    }];
    
    
    
    [thView6 updateLayout];
    UIImageView *iocnImageView = [[UIImageView alloc] init];
    iocnImageView.image = [UIImage imageNamed:@"zhifubao"];
    [scrollView addSubview:iocnImageView];
    [iocnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hua_scale(15));
        make.top.mas_equalTo(thView6.mas_bottom).mas_equalTo(hua_scale(10));
        make.size.mas_equalTo(CGSizeMake(hua_scale(25), hua_scale(27)));
    }];
    
    UILabel *yuanLbale  = [[UILabel alloc] init];
    yuanLbale.text = @"支付宝";
    yuanLbale.font = [UIFont systemFontOfSize:11];
    [scrollView addSubview:yuanLbale];
    [yuanLbale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iocnImageView.mas_right).mas_equalTo(hua_scale(8));
        make.top.mas_equalTo(iocnImageView);
    }];
    [yuanLbale setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UILabel *titleL  = [[UILabel alloc] init];
    titleL.text = @"推荐拥有支付宝的用户使用";
    titleL.font = [UIFont systemFontOfSize:9];
    titleL.textColor = HUAColor(0x494949);
    [scrollView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iocnImageView.mas_right).mas_equalTo(hua_scale(8));
        make.bottom.mas_equalTo(iocnImageView.mas_bottom);
    }];
    [titleL setSingleLineAutoResizeWithMaxWidth:200];
    
    //7线
    UIView *thView7 = [UIView new];
    thView7.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView7];
    thView7.sd_layout
    .topSpaceToView(thView6,hua_scale(45))
    .heightIs(1)
    .leftSpaceToView(scrollView,hua_scale(15))
    .widthIs(scrollView.width);
    
    //手势背景
    UIView *tapView2 = [UIView new];
    tapView2.backgroundColor = [UIColor clearColor];
    tapView2.tag = 1232;
    [tapView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton:)]];
    [scrollView addSubview:tapView2];
    [tapView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView6.mas_bottom);
        make.bottom.mas_equalTo(thView7.mas_top);
        make.right.left.mas_equalTo(self.view);
    }];

    
    
    UIButton *selectsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectsBtn.tag = 192;
    [selectsBtn setBackgroundImage:[UIImage imageNamed:@"do_not_select"] forState:0];
    [selectsBtn setBackgroundImage:[UIImage imageNamed:@"chooseButton_yes"] forState:UIControlStateSelected];
    [selectsBtn addTarget:self action:@selector(seleteAdd:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectsBtn];
    [selectsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.width-hua_scale(15));
        make.centerY.mas_equalTo(iocnImageView);
        make.height.mas_equalTo(hua_scale(15));
        make.width.mas_equalTo(hua_scale(15));
    }];
    
    
    
    UIImageView *winImageView = [[UIImageView alloc] init];
    winImageView.image = [UIImage imageNamed:@"weixin"];
    [scrollView addSubview:winImageView];
    [winImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hua_scale(15));
        make.top.mas_equalTo(thView7.mas_bottom).mas_equalTo(hua_scale(10));
        make.size.mas_equalTo(CGSizeMake(hua_scale(25), hua_scale(27)));
    }];
    
    UILabel *winLbale  = [[UILabel alloc] init];
    winLbale.text = @"微信";
    winLbale.font = [UIFont systemFontOfSize:11];
    [scrollView addSubview:winLbale];
    [winLbale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(winImageView.mas_right).mas_equalTo(hua_scale(8));
        make.top.mas_equalTo(winImageView);
    }];
    [winLbale setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UILabel *wintitleL  = [[UILabel alloc] init];
    wintitleL.text = @"推荐已开通微信钱包的用户使用";
    wintitleL.font = [UIFont systemFontOfSize:9];
    wintitleL.textColor = HUAColor(0x494949);
    [scrollView addSubview:wintitleL];
    [wintitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(winImageView.mas_right).mas_equalTo(hua_scale(8));
        make.bottom.mas_equalTo(winImageView.mas_bottom);
    }];
    [wintitleL setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UIButton *winselectsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    winselectsBtn.tag = 193;
    [winselectsBtn setBackgroundImage:[UIImage imageNamed:@"do_not_select"] forState:0];
    [winselectsBtn setBackgroundImage:[UIImage imageNamed:@"chooseButton_yes"] forState:UIControlStateSelected];
    [winselectsBtn addTarget:self action:@selector(seleteAdd:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:winselectsBtn];
    [winselectsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.width-hua_scale(15));
        make.centerY.mas_equalTo(winImageView);
        make.height.mas_equalTo(hua_scale(15));
        make.width.mas_equalTo(hua_scale(15));
    }];
    
    
    //8线
    UIView *thView8 = [UIView new];
    thView8.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView8];
    [thView8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wintitleL.mas_bottom).mas_equalTo(hua_scale(10));
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(scrollView.width);
        
    }];
    
    //手势背景
    UIView *tapView3 = [UIView new];
    tapView3.backgroundColor = [UIColor clearColor];
    tapView3.tag = 1233;
    [tapView3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton:)]];
    [scrollView addSubview:tapView3];
    [tapView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView7.mas_bottom);
        make.bottom.mas_equalTo(thView8.mas_top);
        make.right.left.mas_equalTo(self.view);
    }];

    
    
    
    _memberLabel = [[UILabel alloc] init];
    _memberLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
    _memberLabel.text = @"¥45 * 1";
    [scrollView addSubview:_memberLabel];
    [_memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-15));
        make.top.mas_equalTo(thView8.mas_bottom).mas_equalTo(hua_scale(15));
        
    }];
    [_memberLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UILabel *memberTitle  = [[UILabel alloc] init];
    memberTitle.font = [UIFont systemFontOfSize:hua_scale(11)];
    memberTitle.text = @"产品金额:";
    [scrollView addSubview:memberTitle];
    [memberTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_memberLabel.mas_left).mas_equalTo(hua_scale(-45));
        make.top.mas_equalTo(thView8.mas_bottom).mas_equalTo(hua_scale(15));
    }];
    [memberTitle setSingleLineAutoResizeWithMaxWidth:200];
    
    
    
    //运费
    UILabel *freightLabel = [UILabel new];
    freightLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
    freightLabel.text = @"运费:";
    [scrollView addSubview:freightLabel];
    [freightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(memberTitle.mas_right);
        make.top.mas_equalTo(memberTitle.mas_bottom).mas_equalTo(hua_scale(12));
    }];
    [freightLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    //运费金钱
    UILabel *freight = [UILabel new];
    freight.font = [UIFont systemFontOfSize:hua_scale(11)];
    freight.text = @"¥100";
    [scrollView addSubview:freight];
    [freight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-15));
        make.top.mas_equalTo(freightLabel);
    }];
    [freight setSingleLineAutoResizeWithMaxWidth:200];
    
    
    //9线
    UIView *thView9 = [UIView new];
    thView9.backgroundColor = HUAColor(0xe1e1e1);
    
    [scrollView addSubview:thView9];
    [thView9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.width/2.0);
        make.top.mas_equalTo(freight.mas_bottom).mas_equalTo(hua_scale(15));
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(self.view);
    }];
    
    
    [thView9 updateLayout];
    UILabel *ResultLable  = [[UILabel alloc] init];
    ResultLable.font = [UIFont systemFontOfSize:13];
    ResultLable.text = @"¥45";
    ResultLable.textColor = HUAColor(0x4da800);
    [scrollView addSubview:ResultLable];
    [ResultLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-15));
        make.top.mas_equalTo(thView9.mas_bottom).mas_equalTo(hua_scale(10));
    }];
    [ResultLable setSingleLineAutoResizeWithMaxWidth:200];
    self.ResultLable = ResultLable;
    
    UILabel *ResultTitle  = [[UILabel alloc] init];
    ResultTitle.font = [UIFont systemFontOfSize:13];
    ResultTitle.text = @"合计:";
    ResultTitle.textColor = HUAColor(0x4da800);
    [scrollView addSubview:ResultTitle];
    [ResultTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(memberTitle);
        make.top.mas_equalTo(ResultLable);
    }];
    [ResultTitle setSingleLineAutoResizeWithMaxWidth:200];
    
    
    //10线
    UIView *thView10 = [UIView new];
    thView10.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView10];
    [thView10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ResultLable.mas_bottom).mas_equalTo(hua_scale(22.5));
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(self.view);
        
    }];
    
    
    
    [thView10 updateLayout];
    UILabel *commonLabel = [UILabel new];
    commonLabel.textColor = HUAColor(0x888888);
    commonLabel.text = @"共 :";
    commonLabel.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:commonLabel];
    [commonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(hua_scale(13));
        make.top.mas_equalTo(thView10.mas_bottom).mas_equalTo(hua_scale(20));
        make.left.mas_equalTo(self.view.mas_left).mas_equalTo(hua_scale(15));
    }];
    [commonLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel *commonValue = [UILabel new];
    commonValue.textColor = HUAColor(0x4da800);
    commonValue.text = @"¥45";
    commonValue.font = [UIFont systemFontOfSize:16];
    [scrollView addSubview:commonValue];
    [commonValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(commonLabel);
        make.left.mas_equalTo(commonLabel.mas_right).mas_equalTo(hua_scale(3));
    }];
    [commonValue setSingleLineAutoResizeWithMaxWidth:200];
    self.commonValue = commonValue;
    
    
    UIButton *successButton = [UIButton buttonWithType:UIButtonTypeCustom];
    successButton.backgroundColor = HUAColor(0x4da800);
    successButton.tag = 194;
    successButton.clipsToBounds = YES;
    successButton.layer.borderWidth =1;
    successButton.layer.borderColor = HUAColor(0x4da800).CGColor;//设置边框颜色
    successButton.layer.cornerRadius =3.f;
    [successButton setTitle:@"提交并支付" forState:0];
    [successButton setTitleColor:HUAColor(0xffffff) forState:0];
    [successButton addTarget:self action:@selector(pageAdd:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:successButton];
    [successButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(commonLabel);
        make.size.mas_equalTo(CGSizeMake(hua_scale(166), hua_scale(34)));
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-10));
    }];
    
    //11线
    UIView *thView11 = [UIView new];
    thView11.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView11];
    thView11.sd_layout
    .topSpaceToView(successButton,hua_scale(10))
    .heightIs(1)
    .widthIs(scrollView.width);
    [thView11 updateLayout];
    
    
    //运费
    freight.text =[NSString stringWithFormat:@"¥ %@",self.moneyDic[@"carriage"]];
    
    //产品金额
    _memberLabel.text = [NSString stringWithFormat:@"¥ %@ * %@",self.moneyDic[@"price"],_numberTypelabel.text];
    
    //合计
    ResultLable.text = [NSString stringWithFormat:@"¥ %ld.00",[self.moneyDic[@"price"] integerValue]*[_numberTypelabel.text integerValue]+[self.moneyDic[@"carriage"] integerValue]];
    
    //共
    self.commonValue.text = self.ResultLable.text;
    
    
    
    scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [scrollView setupAutoContentSizeWithBottomView:thView11 bottomMargin:hua_scale(0)];
    self.scrollView = scrollView;
    
}
- (void)popView{
    
    _outView= [UIView new];
    _outView.backgroundColor = [UIColor blackColor];
    _outView.hidden = YES;
    _outView.alpha= 0;
    [self.view addSubview:_outView];
    [_outView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    _contentView = [UIView new];
    _contentView.hidden = YES;
    //_contentView.frame = CGRectMake(self.view.width/2, self.view.height/2, 0, 0);
    _contentView.frame = CGRectMake(hua_scale(25), self.view.height/2-hua_scale(116.5/2.0+hua_scale(100)), hua_scale(550.0/2.0), hua_scale(330.0/2.0));
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    
    UIView *thView1 = [UIView new];
    thView1.backgroundColor = HUAColor(0xe1e1e1);
    [_contentView addSubview:thView1];
    [thView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hua_scale(35));
        make.left.mas_equalTo(hua_scale(15));
        make.right.mas_equalTo(hua_scale(-15));
        make.height.mas_equalTo(1);
    }];
    
    UIView *thView2 = [UIView new];
    thView2.backgroundColor = HUAColor(0xe1e1e1);
    [_contentView addSubview:thView2];
    [thView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView1.mas_bottom).mas_equalTo(hua_scale(45));
        make.left.mas_equalTo(hua_scale(15));
        make.right.mas_equalTo(hua_scale(-15));
        make.height.mas_equalTo(1);
    }];
    UIView *thView3 = [UIView new];
    thView3.backgroundColor = HUAColor(0xe1e1e1);
    [_contentView addSubview:thView3];
    [thView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView2.mas_bottom).mas_equalTo(hua_scale(45));
        make.left.mas_equalTo(hua_scale(15));
        make.right.mas_equalTo(hua_scale(-15));
        make.height.mas_equalTo(1);
    }];
    
    UIView *thView4 = [UIView new];
    thView4.backgroundColor = HUAColor(0xe1e1e1);
    thView4.tag = 1414;
    [_contentView addSubview:thView4];
    [thView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView3);
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    
    UILabel *titleType = [UILabel new];
    titleType.text = @"取货方式";
    titleType.font = [UIFont systemFontOfSize:12];
    [_contentView addSubview:titleType];
    [titleType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hua_scale(35.0/2.0-12.0/2.0));
        make.centerX.mas_equalTo(0);
    }];
    [titleType setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel *title1 = [UILabel new];
    title1.text = @"上门取货";
    title1.font = [UIFont systemFontOfSize:13];
    [_contentView addSubview:title1];
    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView1.mas_bottom).mas_equalTo(hua_scale(45.0/2.0-13.0/2.0));
        make.left.mas_equalTo(15);
    }];
    [title1 setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel *title2 = [UILabel new];
    title2.text = @"送货上门";
    title2.font = [UIFont systemFontOfSize:13];
    [_contentView addSubview:title2];
    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView2.mas_bottom).mas_equalTo(hua_scale(45.0/2.0-13.0/2.0));
        make.left.mas_equalTo(15);
    }];
    [title2 setSingleLineAutoResizeWithMaxWidth:200];
    //door_to_door
    for (int i = 0 ; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i==0) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
        [button setImage:[UIImage imageNamed:@"numer"] forState:0];
        [button setImage:[UIImage imageNamed:@"door_to_door"] forState:UIControlStateSelected];
        
        button.tag = 157+i;
        [_contentView addSubview:button];
        [button addTarget:self action:@selector(clickk:) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-hua_scale(20));
            make.size.mas_equalTo(CGSizeMake(hua_scale(32.0/2.0), hua_scale(32.0/2.0)));
            if (i==0) {
                make.centerY.mas_equalTo(title1);
            }else{
                make.centerY.mas_equalTo(title2);
            }
            
        }];
    }
    
    NSArray *array = @[@"取消",@"确定"];
    for (int i = 0 ; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitleColor:HUAColor(0x666666) forState:0];
        button.tag = 155+i;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitle:array[i] forState:0];
        [_contentView addSubview:button];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(thView3);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(hua_scale(100));
            if (i==0) {
                make.right.mas_equalTo(thView4.mas_left);
            }else {
                
                make.left.mas_equalTo(thView4.mas_right);
            }
        }];
    }
    
}
//按钮点击事件
UIButton *senderBtn = nil;
- (void)pageAdd:(UIButton *)button{
    
    if (senderBtn!=button) {
        button.selected = YES;
        senderBtn.selected = NO;
        
    }else{
        button.selected = YES;
    }
    
    //点击减少数量
    if (button.tag == 189 && [_numberTypelabel.text integerValue] >=1) {
        
        if ([_numberTypelabel.text integerValue] <=1) {
            //个数不能小于1
            senderBtn = button;
            return;
        }
        _numberTypelabel.text = [NSString stringWithFormat:@"%ld",[_numberTypelabel.text integerValue]-1];
        
    }else if(button.tag == 190){
        //点击减少数量
        _numberTypelabel.text = [NSString stringWithFormat:@"%ld",[_numberTypelabel.text integerValue]+1];
    }
    
    //产品金额
    _memberLabel.text = [NSString stringWithFormat:@"¥ %@ * %@",self.moneyDic[@"price"],_numberTypelabel.text];
    
    //合计
    self.ResultLable.text = [NSString stringWithFormat:@"¥ %ld.00",[self.moneyDic[@"price"] integerValue]*[_numberTypelabel.text integerValue]+[self.moneyDic[@"carriage"] integerValue]];
    //共
    self.commonValue.text = self.ResultLable.text;
    
    senderBtn = button;
    
}
//支付方式
UIButton *senderButton = nil;
- (void)seleteAdd:(UIButton *)sender{
    if (senderButton!=sender) {
        sender.selected = YES;
        _selecteButton.selected = NO;
        
    }else{
        sender.selected = YES;
    }
    senderButton = sender;
    _selecteButton = sender;
}

//增加收货地址
- (void)address:(UIButton *)sender{
    //跳转到选择收货地址
    HUAChooseAddressViewController *vc = [HUAChooseAddressViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    UILabel *label1 = [self.view viewWithTag:202];
    UILabel *label2 = [self.view viewWithTag:201];
    UIImageView *imageView = [self.view viewWithTag:200];
    UIButton *button = [self.view viewWithTag:1000];
    [vc setModelBlock:^(HUAAddressModel *model) {
        label1.text = [NSString stringWithFormat:@"%@ %@",model.name,model.phone];
        label2.text = model.address;
        [button setTitle:nil forState:0];
        [button setImage:nil forState:0];
        
        label2.hidden = NO;
        label1.hidden = NO;
        imageView.hidden = NO;
    }];
}
//点击送货方式按钮
- (void)claimChange:(UIButton *)sender{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _outView.hidden = NO;
        _outView.alpha = 0.3;
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _contentView.hidden = NO;
        
    }];
}
//选择取货方式按钮
UIButton *btn = nil;
- (void)clickk:(UIButton *)sender{
    sender.selected = !sender.selected;
    UIButton *button1 = [_contentView viewWithTag:157];
    UIButton *button2 = [_contentView viewWithTag:158];
    if (sender == button1) {
        button1.selected = YES;
        button2.selected = NO;
    }else{
        button2.selected = YES;
        button1.selected = NO;
    }
    
    
    
    btn = sender;
}
//确定按钮和取消按钮
- (void)click:(UIButton *)sender{
    if (sender.tag == 155) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _contentView.hidden = YES;
        } completion:^(BOOL finished) {
            _outView.hidden = YES;
        }];
    }else{
        UIView   *bgView  = [self.view viewWithTag:166];
        UIView   *thView5 = [self.view viewWithTag:1002];
        UIView   *thView4 = [self.view viewWithTag:1414];
        UILabel  *lable   = [self.view viewWithTag:1001];
        UIButton *address = [self.view viewWithTag:1000];
        UIButton *button1 = [_contentView viewWithTag:157];
        UIButton *button2 = [self.view viewWithTag:159];
        //判断当前的按钮的选中状态
        if (button1.selected == YES) {
            address.hidden = YES;
            thView5.hidden = YES;
            bgView.hidden = YES;
            [button2 setTitle:@"上门取货" forState:0];
            [lable mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(thView4.mas_bottom).mas_equalTo(hua_scale(15));
                make.left.mas_equalTo(hua_scale(15));
            }];
            [self.scrollView layoutSubviews];
        }else{
            address.hidden = NO;
            thView5.hidden = NO;
            bgView.hidden = NO;
            [button2 setTitle:@"送货上门" forState:0];
            [lable mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(thView5.mas_bottom).mas_equalTo(hua_scale(15));
                make.left.mas_equalTo(hua_scale(15));
            }];
            [self.scrollView layoutSubviews];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            _contentView.hidden = YES;
        } completion:^(BOOL finished) {
            _outView.hidden = YES;
        }];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//手势事件
- (void)clickButton:(UITapGestureRecognizer *)tap{
  
    UIButton *button1 = [self.view viewWithTag:tap.view.tag-1231+191];
    
    if (_selecteButton != button1) {
        button1.selected = YES;
        _selecteButton.selected = NO;
    }else{
        button1.selected = YES;
    }
    
    
    _selecteButton = button1;
    NSLog(@"%ld",_selecteButton.tag);

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
