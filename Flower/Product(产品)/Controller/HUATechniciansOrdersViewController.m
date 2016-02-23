//
//  HUATechniciansOrdersViewController.m
//  Flower
//
//  Created by apple on 16/1/29.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUATechniciansOrdersViewController.h"
#import "HUAcardTableViewCell.h"
@interface HUATechniciansOrdersViewController ()<HATransparentViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    UILabel *_projectlabel; //项目
    UILabel *_nameLabel; //名字
    
    UIButton *_selecteButton;//记录选中的button的订单方式
    
    UIView *_tanBgView;//弹窗
    NSArray *_cardArray;//产品卡的数组
    
    //记录用户选择过的产品卡
    UIButton *_cardButton;
}

///////////////////技师和服务的订单页/////////////////////////////////////////////////////

//个数

@property(nonatomic,strong)UILabel *numberTypelabel ;
@property (nonatomic, strong)UILabel *memberLabel;
//弹出的产品卡框
@property (nonatomic, strong)UITableView *tanBgTableView;
@property (nonatomic, strong)HATransparentView *transparentView;
@end

@implementation HUATechniciansOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单确认";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initScrollView];
    
}
- (void)initScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    //scrollView.backgroundColor = [UIColor yellowColor];
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    //UIView *mianView = self.view;
    
    //项目
    UILabel *goodsLabel = [UILabel new];
    goodsLabel.text = @"项目 :";
    goodsLabel.textColor = HUAColor(0x666666);
    goodsLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
    [goodsLabel sizeToFit];
    [scrollView addSubview:goodsLabel];
    [goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hua_scale(12));
        make.left.mas_equalTo(hua_scale(15));
    }];
    
    //项目内容
    _projectlabel = [UILabel labelText:@"洗头" color:HUAColor(0x4da800) font:hua_scale(11)];
    [goodsLabel sizeToFit];
    [scrollView addSubview:_projectlabel];
    [_projectlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(goodsLabel);
        make.left.mas_equalTo(goodsLabel.mas_right).mas_equalTo(hua_scale(5));
    }];
    
    //技师
    UILabel *shopName = [UILabel new];
    //shopName.backgroundColor =[UIColor redColor];
    shopName.textColor = HUAColor(0x666666);
    shopName.text = @"技师 :";
    shopName.font = [UIFont systemFontOfSize:hua_scale(11)];
    [scrollView addSubview:shopName];
    [shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(goodsLabel.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(goodsLabel);
    }];
    
    //技师名字
    _nameLabel = [UILabel labelText:@"张三" color:HUAColor(0x4da800) font:hua_scale(11)];
    [goodsLabel sizeToFit];
    [scrollView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(shopName);
        make.left.mas_equalTo(shopName.mas_right).mas_equalTo(hua_scale(5));
    }];
    
    
    //1线
    UIView *thView1 = [UIView new];
    thView1.backgroundColor = HUAColor(0xf3f3f3);
    [scrollView addSubview:thView1];
    thView1.sd_layout
    .topSpaceToView(_nameLabel,hua_scale(12))
    .heightIs(hua_scale(0.5))
    .leftSpaceToView(scrollView,hua_scale(15))
    .widthIs(scrollView.width);
    
    //2线
    UIView *thView2 = [UIView new];
    thView2.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView2];
    thView2.sd_layout
    .topSpaceToView(thView1,hua_scale(50))
    .heightIs(hua_scale(0.5))
    .widthIs(scrollView.width);
    
    //名字
    UILabel *name = [UILabel new];
    name.textColor = HUAColor(0x000000);
    name.text = self.membersName;
    name.font = [UIFont systemFontOfSize:hua_scale(13)];
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
    pageLabel.text =[NSString stringWithFormat:@"余额 : ¥%ld",self.membersMoney.integerValue];
    pageLabel.textAlignment = NSTextAlignmentCenter;
    pageLabel.textColor = HUAColor(0x4da800);
    pageLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:pageLabel.text];
    
    [att addAttributes:@{NSForegroundColorAttributeName:HUAColor(0x888888)}  range:NSMakeRange(0, 4)];
    [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:hua_scale(11)]} range:NSMakeRange(0, 4)];
    pageLabel.attributedText = att;
    [basketImageView addSubview:pageLabel];
    [pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(basketImageView);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(basketImageView);
        
    }];
    [pageLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    //判断是否是会员
    if (self.showType == NO) {
        basketImageView.hidden = YES;
        name.hidden = YES;
        memberType.hidden = YES;
        thView2.hidden = YES;
    }

    
    
    
    UILabel *modeLabel = [[UILabel alloc] init];
    modeLabel.text = @"支付方式";
    modeLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    [scrollView addSubview:modeLabel];
    [modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.showType == NO) {
            make.top.mas_equalTo(thView1.mas_bottom).mas_equalTo(hua_scale(15));
        }else{
            make.top.mas_equalTo(thView2.mas_bottom).mas_equalTo(hua_scale(15));
        }
        
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
    selectBtn.tag = 190;
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"do_not_select"] forState:0];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"chooseButton_yes"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(pageAdd:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.right-hua_scale(15));
        make.top.mas_equalTo(iocnImage);
        make.height.mas_equalTo(hua_scale(15));
        make.width.mas_equalTo(hua_scale(15));
    }];
    //4线
    [iocnImage updateLayout];
    UIView *thView4 = [UIView new];
    thView4.backgroundColor = HUAColor(0xf3f3f3);
    [scrollView addSubview:thView4];
    thView4.sd_layout
    .topSpaceToView(iocnImage,hua_scale(10))
    .heightIs(hua_scale(0.5))
    .leftSpaceToView(scrollView,hua_scale(15))
    .widthIs(scrollView.width);
    

    //手势背景
    [thView4 updateLayout];
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
    .leftSpaceToView(scrollView,hua_scale(15))
    .heightIs(hua_scale(0.5))
    .widthIs(scrollView.width);
    
    //手势背景
    [thView5 updateLayout];
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
    selectsBtn.tag = 191;
    [selectsBtn setBackgroundImage:[UIImage imageNamed:@"do_not_select"] forState:0];
    [selectsBtn setBackgroundImage:[UIImage imageNamed:@"chooseButton_yes"] forState:UIControlStateSelected];
    [selectsBtn addTarget:self action:@selector(pageAdd:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectsBtn];
    [selectsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.width-hua_scale(15));
        make.top.mas_equalTo(iocnImageView);
        make.height.mas_equalTo(hua_scale(15));
        make.width.mas_equalTo(hua_scale(15));
    }];
    
    
    
    //6线
    UIView *thView6 = [UIView new];
    thView6.backgroundColor = HUAColor(0xf3f3f3);
    [scrollView addSubview:thView6];
    thView6.sd_layout
    .topSpaceToView(thView5,hua_scale(44))
    .leftSpaceToView(scrollView,hua_scale(15))
    .heightIs(hua_scale(0.5))
    .widthIs(scrollView.width);
    
    //手势背景
    [thView6 updateLayout];
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
    wintitleL.font = [UIFont systemFontOfSize:hua_scale(9)];
    wintitleL.textColor = HUAColor(0x494949);
    [scrollView addSubview:wintitleL];
    [wintitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(winImageView.mas_right).mas_equalTo(hua_scale(8));
        make.bottom.mas_equalTo(winImageView.mas_bottom);
    }];
    [wintitleL setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UIButton *winselectsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    winselectsBtn.tag = 192;
    [winselectsBtn setBackgroundImage:[UIImage imageNamed:@"do_not_select"] forState:0];
    [winselectsBtn setBackgroundImage:[UIImage imageNamed:@"chooseButton_yes"] forState:UIControlStateSelected];
    [winselectsBtn addTarget:self action:@selector(pageAdd:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:winselectsBtn];
    [winselectsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.width-hua_scale(15));
        make.top.mas_equalTo(winImageView);
        make.height.mas_equalTo(hua_scale(15));
        make.width.mas_equalTo(hua_scale(15));
    }];
    
    //产品卡
    
    
    UIImageView *chanImageView = [[UIImageView alloc] init];
    chanImageView.image = [UIImage imageNamed:@"productcard"];
    [scrollView addSubview:chanImageView];
    [chanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hua_scale(15));
        make.top.mas_equalTo(thView6.mas_bottom).mas_equalTo(hua_scale(10));
        make.size.mas_equalTo(CGSizeMake(hua_scale(25), hua_scale(25)));
    }];
    
    UILabel *chanLbale  = [[UILabel alloc] init];
    chanLbale.text = @"产品卡";
    chanLbale.font = [UIFont systemFontOfSize:hua_scale(11)];
    [scrollView addSubview:chanLbale];
    [chanLbale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(chanImageView.mas_right).mas_equalTo(hua_scale(8));
        make.top.mas_equalTo(chanImageView);
    }];
    [chanLbale setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UILabel *chanTitleL  = [[UILabel alloc] init];
    chanTitleL.text = @"推荐已购买产品卡的用户使用";
    chanTitleL.font = [UIFont systemFontOfSize:hua_scale(9)];
    chanTitleL.textColor = HUAColor(0x494949);
    [scrollView addSubview:chanTitleL];
    [chanTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(chanImageView.mas_right).mas_equalTo(hua_scale(8));
        make.bottom.mas_equalTo(chanImageView.mas_bottom);
    }];
    [chanTitleL setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UIButton *chanSelectsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chanSelectsBtn.tag = 193;
    [chanSelectsBtn setBackgroundImage:[UIImage imageNamed:@"do_not_select"] forState:0];
    [chanSelectsBtn setBackgroundImage:[UIImage imageNamed:@"chooseButton_yes"] forState:UIControlStateSelected];
    [chanSelectsBtn addTarget:self action:@selector(pageAdd:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:chanSelectsBtn];
    [chanSelectsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.width-hua_scale(15));
        make.top.mas_equalTo(chanImageView);
        make.height.mas_equalTo(hua_scale(15));
        make.width.mas_equalTo(hua_scale(15));
    }];
    
    
    //线
    UIView *addThView = [UIView new];
    addThView.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:addThView];
    addThView.sd_layout
    .topSpaceToView(thView6,hua_scale(45))
    .heightIs(hua_scale(0.5))
    .leftEqualToView(scrollView)
    .rightEqualToView(thView6);
    
    //手势背景
    [addThView updateLayout];
    UIView *bgView4 = [UIView new];
    bgView4.backgroundColor = [UIColor clearColor];
    bgView4.tag = 1234;
    [bgView4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton:)]];
    [scrollView addSubview:bgView4];
    [bgView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView6.mas_bottom);
        make.bottom.mas_equalTo(addThView.mas_top);
        make.right.left.mas_equalTo(self.view);
    }];
    
    
    
    //7线
    UIView *thView7 = [UIView new];
    thView7.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView7];
    thView7.sd_layout
    .topSpaceToView(addThView,hua_scale(45))
    .heightIs(hua_scale(0.5))
    .leftSpaceToView(scrollView,scrollView.width/2)
    .widthIs(scrollView.width/2);
    
    
    
    UILabel *memberTitle  = [[UILabel alloc] init];
    memberTitle.font = [UIFont systemFontOfSize:hua_scale(13)];
    memberTitle.text = @"产品金额:";
    //memberTitle.backgroundColor = [UIColor redColor];
    [scrollView addSubview:memberTitle];
    [memberTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(thView7);
        //make.height.mas_equalTo(13);
        make.top.mas_equalTo(addThView.mas_bottom).mas_equalTo(hua_scale(45.0/2.0-13.0/2.0));
    }];
    [memberTitle setSingleLineAutoResizeWithMaxWidth:200];
    
    _memberLabel = [[UILabel alloc] init];
    _memberLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    _memberLabel.text = @"¥ 45";
     //_memberLabel.backgroundColor = [UIColor redColor];
    [scrollView addSubview:_memberLabel];
    [_memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.width-hua_scale(15));
        make.top.mas_equalTo(memberTitle);
    }];
    [_memberLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UILabel *ResultLable  = [[UILabel alloc] init];
    ResultLable.font = [UIFont systemFontOfSize:hua_scale(13)];
    ResultLable.text = @"¥ 45";
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
    
    //8线
    UIView *thView8 = [UIView new];
    thView8.backgroundColor = HUAColor(0xf3f3f3);
    [scrollView addSubview:thView8];
    thView8.sd_layout
    .topSpaceToView(thView7,hua_scale(116))
    .heightIs(hua_scale(0.5))
    .widthIs(scrollView.width);
    
    UILabel *commonLabel = [UILabel new];
    commonLabel.textColor = HUAColor(0x888888);
    commonLabel.text = @"共 :";
    commonLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    [scrollView addSubview:commonLabel];
    [commonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(hua_scale(13));
        make.top.mas_equalTo(thView8.mas_bottom).mas_equalTo(hua_scale(50.0/2.0-13.0/2.0));
        make.left.mas_equalTo(self.view.mas_left).mas_equalTo(hua_scale(15));
    }];
    [commonLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel *commonValue = [UILabel new];
    commonValue.textColor = HUAColor(0x4da800);
    commonValue.text = @"¥45";
    commonValue.font = [UIFont systemFontOfSize:hua_scale(16)];
    [scrollView addSubview:commonValue];
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
    [successButton addTarget:self action:@selector(Confirm:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:successButton];
    [successButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(commonLabel);
        make.size.mas_equalTo(CGSizeMake(hua_scale(166), hua_scale(34)));
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-10));
    }];
    
    
    //9线
    UIView *thView9 = [UIView new];
    thView9.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView9];
    thView9.sd_layout
    .topSpaceToView(thView8,hua_scale(50))
    .heightIs(hua_scale(0.5))
    .widthIs(scrollView.width);
    
    scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [scrollView setupAutoContentSizeWithBottomView:thView9 bottomMargin:hua_scale(0)];
    
    //赋值
    //技师名字
    _nameLabel.text = self.technicianName;
    //项目
    _projectlabel.text = self.projectType;
    //产品金额
    _memberLabel.text = [NSString stringWithFormat:@"¥ %@",self.moneyNumber];
    //共
    commonValue.text = [NSString stringWithFormat:@"¥ %@",self.moneyNumber];
    //合计
    ResultLable.text = [NSString stringWithFormat:@"¥ %@",self.moneyNumber];
}
//添加显示产品卡订单
- (void)showCardView{

    _tanBgView = [UIView new];
    _tanBgView.backgroundColor = HUAColor(0xcdcdcd);
    [_transparentView addSubview:_tanBgView];
    [_tanBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.bottom);
        //make.height.mas_equalTo(hua_scale(80*_cardArray.count+40+50));
        make.height.mas_equalTo(self.view.height-hua_scale(312.0/2.0));
    }];
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    [_tanBgView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(hua_scale(40));
        
    }];
    
    UILabel *title = [UILabel labelText:@"请选择" color:HUAColor(0x333333) font:hua_scale(15)];
    [title sizeToFit];
    [_tanBgView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(bgView);
    }];
    
    //xx按钮
    UIButton *bakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bakeButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"close"]];
    [bakeButton addTarget:self action:@selector(removeBgView) forControlEvents:UIControlEventTouchUpInside];
    [_tanBgView addSubview:bakeButton];
    [bakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hua_scale(15));
        make.size.mas_equalTo(CGSizeMake(hua_scale(13), hua_scale(13)));
        make.centerY.mas_equalTo(bgView);
    }];

    [_tanBgView updateLayout];
    
    UITableView *tanBgTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, hua_scale(40), _tanBgView.width,_tanBgView.height-hua_scale(40+34+16)) style:UITableViewStylePlain];
    tanBgTableView.delegate =self;
    tanBgTableView.dataSource =self;
    [_tanBgView addSubview:tanBgTableView];
    self.tanBgTableView = tanBgTableView;
    

    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor =[UIColor whiteColor];
    cancelButton.tag = 1009;
    [cancelButton setTitle:@"取消" forState:0];
    cancelButton.clipsToBounds = YES;
    cancelButton.layer.borderWidth =1;
    cancelButton.layer.borderColor = [UIColor grayColor].CGColor;//设置边框颜色
    cancelButton.layer.cornerRadius =3.f;
    [cancelButton setTitleColor:HUAColor(0x000000) forState:0];
    [cancelButton addTarget:self action:@selector(tanBgButton:) forControlEvents:UIControlEventTouchUpInside];
    [_tanBgView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tanBgTableView.mas_bottom).mas_equalTo(hua_scale(8));
        make.bottom.mas_equalTo(hua_scale(-8));
        make.left.mas_equalTo(hua_scale(10));
        make.width.mas_equalTo(_tanBgView.width/2-hua_scale(15));
    }];

    //确定按钮
    UIButton *certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    certainButton.backgroundColor = HUAColor(0x4da800);
    certainButton.tag = 1010;
    [certainButton setTitle:@"确认支付" forState:0];
    certainButton.clipsToBounds = YES;
    certainButton.layer.borderWidth =1;
    certainButton.layer.borderColor = HUAColor(0x4da800).CGColor;//设置边框颜色
    certainButton.layer.cornerRadius =3.f;
    [certainButton setTitleColor:HUAColor(0xffffff) forState:0];
    [certainButton addTarget:self action:@selector(tanBgButton:) forControlEvents:UIControlEventTouchUpInside];
    [_tanBgView addSubview:certainButton];
    [certainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tanBgTableView.mas_bottom).mas_equalTo(hua_scale(8));
        make.bottom.mas_equalTo(hua_scale(-8));
        make.right.mas_equalTo(hua_scale(-10));
        make.width.mas_equalTo(cancelButton);
    }];

}
//按钮点击事件,选择支付方式
UIButton *bttn = nil;
- (void)pageAdd:(UIButton *)button{
    
    if (bttn != button) {
        button.selected = YES;
        _selecteButton.selected = NO;
    }else{
        button.selected = YES;
    }
    
    bttn = button;
    
    _selecteButton = button;
}
//确认提交订单
- (void)Confirm:(UIButton *)sender{

    if (_selecteButton.tag == 193) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
      
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        
        NSString *url = [HUA_URL stringByAppendingPathComponent:@"user/user_product_card"];
        
        
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

           
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];

            _cardArray = dic[@"info"][@"list"];
            NSLog(@"%ld",_cardArray.count);
            _transparentView = [[HATransparentView alloc] init];
            _transparentView.delegate = self;
            _transparentView.tapBackgroundToClose = YES;
            _transparentView.hideCloseButton = YES;
            _transparentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
            [_transparentView open];
            
            [self showCardView];
            
            [_tanBgView updateLayout];
            
            [UIView animateWithDuration:0.5 animations:^{
               
                _tanBgView.top = self.view.height-_tanBgView.height+64;
                
            }];
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            HUALog(@"%@",error);
        }];

        NSLog(@"弹出窗口");
    }else{
        NSLog(@"其他支付");
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//弹窗按钮时间
- (void)removeBgView{
//xx按钮
   
        [UIView animateWithDuration:0.3 animations:^{
            
            _tanBgView.top = self.view.bottom;
            
        } completion:^(BOOL finished) {
            
            [_transparentView close];
        }];
}
//确认
- (void)tanBgButton:(UIButton *)sender{

    if (sender.tag == 1009) {
        [UIView animateWithDuration:0.3 animations:^{
            
            _tanBgView.top = self.view.bottom;
            
        } completion:^(BOOL finished) {
            
        [_transparentView close];
        }];

    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return _cardArray.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *cellStr = @"cell";
    
    HUAcardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[HUAcardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    [cell setSelecteBlock:^(UIButton *sender){
        if (_cardButton != sender) {
            sender.selected = YES;
            _cardButton.selected = NO;
        }else{
            sender.selected = YES;
        }
            _cardButton = sender;
        
    }];
    cell.dataDic = _cardArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return hua_scale(80);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tanBgTableView) {
        _transparentView.userInteractionEnabled = YES;
        HUAcardTableViewCell *cell = [self.tanBgTableView cellForRowAtIndexPath:indexPath];
        
        if (_cardButton == cell.selecteBuuton) {
            cell.selecteBuuton.selected = YES;
        }else{
            cell.selecteBuuton.selected = YES;
            _cardButton.selected = NO;
        }
        
        _cardButton = cell.selecteBuuton;

    }
 
}
- (void)HATransparentViewDidClosed
{
    NSLog(@"Did close");
}

-(void)clickButton:(UITapGestureRecognizer *)tap{

    UIButton *button1 = [self.view viewWithTag:tap.view.tag-1231+190];

    if (_selecteButton != button1) {
            button1.selected = YES;
            _selecteButton.selected = NO;
        }else{
            button1.selected = YES;
        }
  
    
       _selecteButton = button1;
    NSLog(@"%ld",_selecteButton.tag);
}
@end
