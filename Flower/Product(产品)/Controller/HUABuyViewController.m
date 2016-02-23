//
//  HUABuyViewController.m
//  Flower
//
//  Created by apple on 16/1/15.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUABuyViewController.h"
//#import "HUABuyTableViewCell.h"
#import "HUAMembersPayViewController.h"
@interface HUABuyViewController ()
//个数
@property(nonatomic,strong)UILabel *numberTypelabel ;
@property (nonatomic, strong)UILabel *memberLabel;
//选定的的支付方式
@property (nonatomic, strong)UIButton *selecteButton;
@end

@implementation HUABuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单确认";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initScrollView];
    
    
}
- (void)initScrollView{
    UIView *footView = [UIView new];
    //footView.backgroundColor = [UIColor redColor];
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(hua_scale(50));
    }];
    
    //9线
    UIView *thView9 = [UIView new];
    thView9.backgroundColor = HUAColor(0xe1e1e1);
    [footView addSubview:thView9];
    thView9.sd_layout
    .topEqualToView(footView)
    .heightIs(hua_scale(0.5))
    .widthIs(self.view.width);
    
    UILabel *commonLabel = [UILabel new];
    commonLabel.textColor = HUAColor(0x888888);
    commonLabel.text = @"共 :";
    commonLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    [footView addSubview:commonLabel];
    [commonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.view.mas_left).mas_equalTo(hua_scale(15));
    }];
    [commonLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel *commonValue = [UILabel new];
    commonValue.textColor = HUAColor(0x4da800);
    commonValue.tag = 200;
    commonValue.text = @"¥45";
    commonValue.font = [UIFont systemFontOfSize:hua_scale(16)];
    [footView addSubview:commonValue];
    [commonValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(commonLabel);
        make.left.mas_equalTo(commonLabel.mas_right).mas_equalTo(hua_scale(3));
    }];
    [commonValue setSingleLineAutoResizeWithMaxWidth:200];
    
    UIButton *successButton = [UIButton buttonWithType:UIButtonTypeCustom];
    successButton.backgroundColor = HUAColor(0x4da800);
    successButton.tag = 194;
    successButton.clipsToBounds = YES;
    successButton.layer.borderWidth =1;
    successButton.layer.borderColor = HUAColor(0x4da800).CGColor;//设置边框颜色
    successButton.layer.cornerRadius =3.f;
    [successButton setTitle:@"提交并支付" forState:0];
    [successButton setTitleColor:HUAColor(0xffffff) forState:0];
    [successButton addTarget:self action:@selector(submitPayment:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:successButton];
    [successButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(commonLabel);
        make.size.mas_equalTo(CGSizeMake(hua_scale(166), hua_scale(34)));
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-10));
    }];

    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-hua_scale(50))];
    //scrollView.backgroundColor = [UIColor yellowColor];
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    //UIView *mianView = self.view;
    
    //商品
    UILabel *goodsLabel = [UILabel new];
    goodsLabel.text = @"商店:";
    goodsLabel.textColor = HUAColor(0x666666);
    goodsLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
    [scrollView addSubview:goodsLabel];
    goodsLabel.sd_layout
    .leftSpaceToView(scrollView,hua_scale(15))
    .heightIs(hua_scale(14));
    goodsLabel.y = (hua_scale(35.0/2.0)-hua_scale(14.0/2.0));
    [goodsLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    //商店名
    UILabel *shopName = [UILabel new];
    //shopName.backgroundColor =[UIColor redColor];
    shopName.textColor = HUAColor(0x333333);
    shopName.text = @"曼秀雷敦水彩润唇膏3g粉红主义唇修护锁";
    shopName.font = [UIFont systemFontOfSize:hua_scale(11)];
    [scrollView addSubview:shopName];
    shopName.sd_layout
    .leftSpaceToView(goodsLabel,hua_scale(5))
    .heightIs(hua_scale(13));
    [shopName setSingleLineAutoResizeWithMaxWidth:300];
    shopName.y = (hua_scale(35.0/2.0)-hua_scale(shopName.height/2));
    
    //1线
    UIView *thView1 = [UIView new];
    thView1.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView1];
    thView1.sd_layout
    .topSpaceToView(scrollView,hua_scale(35))
    .heightIs(hua_scale(0.5))
    .widthIs(scrollView.width);
    
    
    
    //名字
    UILabel *name = [UILabel new];
    name.textColor = HUAColor(0x000000);
    name.font = [UIFont systemFontOfSize:hua_scale(13)];
    name.text = self.membersName;
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
    memberType.font = [UIFont systemFontOfSize:hua_scale(11)];
    [scrollView addSubview:memberType];
    [memberType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(11);
        make.top.mas_equalTo(thView1.mas_bottom).mas_equalTo(hua_scale(50.0/2)-hua_scale(11.0/2.0));
        make.left.mas_equalTo(name.mas_right).mas_equalTo(hua_scale(5));
    }];
    
    //余额
    UILabel *pageLabel = [[UILabel alloc] init];
    pageLabel.textAlignment = NSTextAlignmentCenter;
    pageLabel.text = [NSString stringWithFormat:@"余额 : ¥%ld",self.membersMoney.integerValue];
    pageLabel.textColor = HUAColor(0x4da800);
    pageLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:pageLabel.text];
    
    [att addAttributes:@{NSForegroundColorAttributeName:HUAColor(0x888888)}  range:NSMakeRange(0, 4)];
    [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:hua_scale(11)]} range:NSMakeRange(0, 4)];
    pageLabel.attributedText = att;
    [scrollView addSubview:pageLabel];
    [pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(name);
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-30));
    }];
    [pageLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    UIView *basketImageView = [[UIView alloc] init];
    //basketImageView.backgroundColor = [UIColor redColor];
    basketImageView.layer.masksToBounds = YES;
    [basketImageView.layer setBorderWidth:hua_scale(0.5)];
    [basketImageView.layer setBorderColor: HUAColor(0x4da800).CGColor];
    [scrollView addSubview:basketImageView];
    [basketImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(memberType);
        make.right.mas_equalTo(self.view.right-hua_scale(15));
        make.height.mas_equalTo(hua_scale(29));
        make.left.mas_equalTo(pageLabel.mas_left).mas_equalTo(hua_scale(-15));
    }];
    
    
    
    //2线
    UIView *thView2 = [UIView new];
    thView2.backgroundColor = HUAColor(0xf3f3f3);
    [scrollView addSubview:thView2];
    thView2.sd_layout
    .topSpaceToView(thView1,hua_scale(50))
    .heightIs(hua_scale(0.5))
    .leftSpaceToView(scrollView,hua_scale(15))
    .widthIs(scrollView.width);
    
    //判断是否是会员
    if (self.showType == NO) {
        name.hidden = YES;
        basketImageView.hidden = YES;
        memberType.hidden = YES;
        thView2.hidden = YES;
    }
    
    
    //购买数量
    UILabel *quantityLabel = [UILabel new];
    quantityLabel.text = @"购买数量";
    quantityLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    [scrollView addSubview:quantityLabel];
    [quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.showType == NO) {
            make.top.mas_equalTo(thView1.mas_bottom).mas_equalTo(hua_scale(50.0/2)-hua_scale(13.0/2.0));
        }else{
            make.top.mas_equalTo(thView2.mas_bottom).mas_equalTo(hua_scale(50.0/2)-hua_scale(13.0/2.0));
        }
        
        make.height.mas_equalTo(13);
        make.left.mas_equalTo(hua_scale(15));
    }];
    [quantityLabel setSingleLineAutoResizeWithMaxWidth:200];
    quantityLabel.sd_layout
    .autoHeightRatio(0);
    
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
    _numberTypelabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    _numberTypelabel.text = @"1";
    _numberTypelabel.textAlignment = NSTextAlignmentCenter;
    [backImageView addSubview:_numberTypelabel];
    [_numberTypelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(0);
        make.left.mas_equalTo(subtractButton.mas_right);
        make.right.mas_equalTo(addButton.mas_left);
    }];
    
    //3线
    [backImageView updateLayout];
    UIView *thView3 = [UIView new];
    thView3.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView3];
    thView3.sd_layout
    .topSpaceToView(backImageView,hua_scale(11))
    .heightIs(hua_scale(0.5))
    .widthIs(scrollView.width);
    
    
    
    
    //4线
    UIView *thView4 = [UIView new];
    thView4.backgroundColor = HUAColor(0xf3f3f3);
    [scrollView addSubview:thView4];
    thView4.sd_layout
    .topSpaceToView(thView3,hua_scale(82))
    .leftSpaceToView(self.view,hua_scale(15))
    .heightIs(0.5)
    .widthIs(scrollView.width);
    

    
    UILabel *modeLabel = [[UILabel alloc] init];
    modeLabel.text = @"支付方式";
    modeLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    [scrollView addSubview:modeLabel];
    [modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView3.mas_bottom).mas_equalTo(hua_scale(15));
        make.left.mas_equalTo(hua_scale(15));
    }];
    [modeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    UIImageView *iocnImage = [[UIImageView alloc] init];
    iocnImage.image = [UIImage imageNamed:@"vip1"];
    [scrollView addSubview:iocnImage];
    [iocnImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hua_scale(15));
        make.top.mas_equalTo(modeLabel.mas_bottom).mas_equalTo(hua_scale(14));
        make.height.mas_equalTo(hua_scale(25));
        make.width.mas_equalTo(hua_scale(25));
    }];
    
    UILabel *huiyuanLbale  = [[UILabel alloc] init];
    huiyuanLbale.text = @"会员余额";
    huiyuanLbale.font = [UIFont systemFontOfSize:hua_scale(11)];
    [scrollView addSubview:huiyuanLbale];
    [huiyuanLbale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iocnImage.mas_right).mas_equalTo(hua_scale(8));
        make.top.mas_equalTo(iocnImage);
    }];
    [huiyuanLbale setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UILabel *title  = [[UILabel alloc] init];
    title.text = @"使用会员余额,服务价格降低";
    title.font = [UIFont systemFontOfSize:hua_scale(9)];
    title.textColor = HUAColor(0x4da800);
    [scrollView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iocnImage.mas_right).mas_equalTo(hua_scale(8));
        make.bottom.mas_equalTo(iocnImage.mas_bottom);
    }];
    [title setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.tag = 191;
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"do_not_select"] forState:0];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"chooseButton_yes"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.right-hua_scale(15));
        make.top.mas_equalTo(iocnImage);
        make.height.mas_equalTo(hua_scale(15));
        make.width.mas_equalTo(hua_scale(15));
    }];
    
    //手势背景
    UIView *bgView1 = [UIView new];
    bgView1.backgroundColor = [UIColor clearColor];
    bgView1.tag = 1231;
    [bgView1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton:)]];
    [scrollView addSubview:bgView1];
    [bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iocnImage.mas_top).mas_equalTo(hua_scale(-5));
        make.bottom.mas_equalTo(thView4.mas_top);
        make.right.left.mas_equalTo(self.view);
    }];
    
    //5线
    UIView *thView5 = [UIView new];
    thView5.backgroundColor = HUAColor(0xf3f3f3);
    [scrollView addSubview:thView5];
    thView5.sd_layout
    .topSpaceToView(thView4,hua_scale(44))
    .leftSpaceToView(self.view,hua_scale(15))
    .heightIs(hua_scale(0.5))
    .widthIs(scrollView.width);
   
    //手势背景
    UIView *bgView2 = [UIView new];
    bgView2.backgroundColor = [UIColor clearColor];
    bgView2.tag = 1232;
    [bgView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton:)]];
    [scrollView addSubview:bgView2];
    [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView4.mas_bottom);
        make.bottom.mas_equalTo(thView5.mas_top);
        make.right.left.mas_equalTo(self.view);
    }];
    
    
    UIImageView *iocnImageView = [[UIImageView alloc] init];
    iocnImageView.image = [UIImage imageNamed:@"zhifubao"];
    [scrollView addSubview:iocnImageView];
    [iocnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hua_scale(15));
        make.top.mas_equalTo(thView4.mas_bottom).mas_equalTo(hua_scale(10));
        make.size.mas_equalTo(CGSizeMake(hua_scale(25), hua_scale(25)));
    }];
    
    UILabel *yuanLbale  = [[UILabel alloc] init];
    yuanLbale.text = @"支付宝";
    yuanLbale.font = [UIFont systemFontOfSize:hua_scale(11)];
    [scrollView addSubview:yuanLbale];
    [yuanLbale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iocnImageView.mas_right).mas_equalTo(hua_scale(8));
        make.top.mas_equalTo(iocnImageView);
    }];
    [yuanLbale setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UILabel *titleL  = [[UILabel alloc] init];
    titleL.text = @"推荐拥有支付宝的用户使用";
    titleL.font = [UIFont systemFontOfSize:hua_scale(9)];
    titleL.textColor = HUAColor(0x494949);
    [scrollView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iocnImageView.mas_right).mas_equalTo(hua_scale(8));
        make.bottom.mas_equalTo(iocnImageView.mas_bottom);
    }];
    [titleL setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UIButton *selectsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectsBtn.tag = 192;
    [selectsBtn setBackgroundImage:[UIImage imageNamed:@"do_not_select"] forState:0];
    [selectsBtn setBackgroundImage:[UIImage imageNamed:@"chooseButton_yes"] forState:UIControlStateSelected];
    [selectsBtn addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectsBtn];
    [selectsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.width-hua_scale(15));
        make.top.mas_equalTo(iocnImageView);
        make.height.mas_equalTo(hua_scale(15));
        make.width.mas_equalTo(hua_scale(15));
    }];
    
    
    
    //6线
    UIView *thView6 = [UIView new];
    thView6.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView6];
    thView6.sd_layout
    .topSpaceToView(thView5,hua_scale(44))
    .heightIs(hua_scale(0.5))
    .widthIs(scrollView.width);
    
    //手势背景
    UIView *bgView3 = [UIView new];
    bgView3.backgroundColor = [UIColor clearColor];
    bgView3.tag = 1233;
    [bgView3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton:)]];
    [scrollView addSubview:bgView3];
    [bgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView5.mas_bottom);
        make.bottom.mas_equalTo(thView6.mas_top);
        make.right.left.mas_equalTo(self.view);
    }];
    
    UIImageView *winImageView = [[UIImageView alloc] init];
    winImageView.image = [UIImage imageNamed:@"weixin"];
    [scrollView addSubview:winImageView];
    [winImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hua_scale(15));
        make.top.mas_equalTo(thView5.mas_bottom).mas_equalTo(hua_scale(10));
        make.size.mas_equalTo(CGSizeMake(hua_scale(25), hua_scale(25)));
    }];
    
    UILabel *winLbale  = [[UILabel alloc] init];
    winLbale.text = @"微信";
    winLbale.font = [UIFont systemFontOfSize:hua_scale(11)];
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
    [winselectsBtn addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:winselectsBtn];
    [winselectsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.width-hua_scale(15));
        make.top.mas_equalTo(winImageView);
        make.height.mas_equalTo(hua_scale(15));
        make.width.mas_equalTo(hua_scale(15));
    }];
    
    
    
    //7线
    UIView *thView7 = [UIView new];
    thView7.backgroundColor = HUAColor(0xf3f3f3);
    [scrollView addSubview:thView7];
    thView7.sd_layout
    .topSpaceToView(thView6,hua_scale(44))
    .heightIs(hua_scale(0.5))
    .leftSpaceToView(scrollView,scrollView.width/2)
    .widthIs(scrollView.width/2);
    

    
    
    UILabel *memberTitle  = [[UILabel alloc] init];
    memberTitle.font = [UIFont systemFontOfSize:hua_scale(13)];
    memberTitle.text = @"产品金额:";
    [scrollView addSubview:memberTitle];
    [memberTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(thView7);
        make.height.mas_equalTo(13);
        make.top.mas_equalTo(thView6.mas_bottom).mas_equalTo(hua_scale(44.0/2.0-13.0/2.0));
    }];
    [memberTitle setSingleLineAutoResizeWithMaxWidth:200];
    
    _memberLabel = [[UILabel alloc] init];
    _memberLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    _memberLabel.text = @"¥45 * 1";
    [scrollView addSubview:_memberLabel];
    [_memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.width-hua_scale(15));
        make.top.mas_equalTo(memberTitle);
    }];
    [_memberLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UILabel *ResultLable  = [[UILabel alloc] init];
    ResultLable.font = [UIFont systemFontOfSize:hua_scale(13)];
    ResultLable.tag = 199;
    ResultLable.text = @"¥45";
    ResultLable.textColor = HUAColor(0x4da800);
    [scrollView addSubview:ResultLable];
    [ResultLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.width-hua_scale(15));
        make.top.mas_equalTo(thView7.mas_bottom).mas_equalTo(hua_scale(17));
    }];
    [ResultLable setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel *ResultTitle  = [[UILabel alloc] init];
    ResultTitle.font = [UIFont systemFontOfSize:hua_scale(13)];
    ResultTitle.text = @"合计:";
    ResultTitle.textColor = HUAColor(0x4da800);
    [scrollView addSubview:ResultTitle];
    [ResultTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(memberTitle);
        make.top.mas_equalTo(thView7.mas_bottom).mas_equalTo(hua_scale(17));
    }];
    [ResultTitle setSingleLineAutoResizeWithMaxWidth:200];
    

    scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [scrollView setupAutoContentSizeWithBottomView:thView7 bottomMargin:hua_scale(116)];
    
    
}

//按钮点击事件
UIButton *lastButton = nil;
- (void)pageAdd:(UIButton *)button{
    if (button!=lastButton) {
        button.selected = YES;
        lastButton.selected = NO;
    }else{
        
        button.selected = YES;
    }
    
    //点击减少数量
    if (button.tag == 189 && [_numberTypelabel.text integerValue] >=1) {
        if (_numberTypelabel.text.integerValue<=1) {
            //个数不能小于1；
            lastButton = button;
            return;
        }
        _numberTypelabel.text = [NSString stringWithFormat:@"%ld",[_numberTypelabel.text integerValue]-1];
        //产品金额
        _memberLabel.text = [NSString stringWithFormat:@"¥45 * %ld",[_numberTypelabel.text integerValue]];
        
    }else if(button.tag == 190){
        //点击减少数量
        _numberTypelabel.text = [NSString stringWithFormat:@"%ld",[_numberTypelabel.text integerValue]+1];
        //产品金额
        
        _memberLabel.text = [NSString stringWithFormat:@"¥45 * %ld",[_numberTypelabel.text integerValue]];
        
    }
    //合计
    UILabel *label1 = [self.view viewWithTag:199];
    label1.text = [NSString stringWithFormat:@"¥ %ld",45*_numberTypelabel.text.integerValue];
    //共
    UILabel *label2 = [self.view viewWithTag:200];
    label2.text = [NSString stringWithFormat:@"¥ %ld",45*_numberTypelabel.text.integerValue];
    lastButton = button;
    
    
    
}
//选择支付类型
- (void)selectButton:(UIButton *)sender{
    if (_selecteButton!=sender) {
        sender.selected = YES;
        _selecteButton.selected = NO;
    }else{
        
        sender.selected = YES;
    }
    
    _selecteButton = sender;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//手势
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
- (void)submitPayment:(UIButton *)sender{

    if (_selecteButton.tag == 191) {
      
        HUAMembersPayViewController *vc = [HUAMembersPayViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    
    }

}

@end
