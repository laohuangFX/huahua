//
//  HUATechniciansOrdersViewController.m
//  Flower
//
//  Created by apple on 16/1/29.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUATechniciansOrdersViewController.h"

@interface HUATechniciansOrdersViewController (){
    
    UILabel *_projectlabel; //项目
    UILabel *_nameLabel; //名字
    
    
}



///////////////////技师和服务的订单页/////////////////////////////////////////////////////

//个数
@property(nonatomic,strong)UILabel *numberTypelabel ;
@property (nonatomic, strong)UILabel *memberLabel;
@end

@implementation HUATechniciansOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"技师订单确认";
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
    _projectlabel = [UILabel labelText:@"洗头" color:HUAColor(0x4da800) font:hua_scale(13)];
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
    _nameLabel = [UILabel labelText:@"张三" color:HUAColor(0x4da800) font:hua_scale(13)];
    [goodsLabel sizeToFit];
    [scrollView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(shopName);
        make.left.mas_equalTo(shopName.mas_right).mas_equalTo(hua_scale(5));
    }];
    
    
    //1线
    UIView *thView1 = [UIView new];
    thView1.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView1];
    thView1.sd_layout
    .topSpaceToView(_nameLabel,hua_scale(12))
    .heightIs(1)
    .leftSpaceToView(scrollView,hua_scale(15))
    .widthIs(scrollView.width);
    
    //2线
    UIView *thView2 = [UIView new];
    thView2.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView2];
    thView2.sd_layout
    .topSpaceToView(thView1,hua_scale(50))
    .heightIs(1)
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
    //
    //    //购买数量
    //    UILabel *quantityLabel = [UILabel new];
    //    quantityLabel.text = @"购买数量";
    //    quantityLabel.font = [UIFont systemFontOfSize:13];
    //    [scrollView addSubview:quantityLabel];
    //    [quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.height.mas_equalTo(13);
    //        make.top.mas_equalTo(thView2.mas_bottom).mas_equalTo(hua_scale(50.0/2)-hua_scale(13.0/2.0));
    //        make.left.mas_equalTo(hua_scale(15));
    //    }];
    //    [quantityLabel setSingleLineAutoResizeWithMaxWidth:200];
    //    quantityLabel.sd_layout
    //    .autoHeightRatio(0);
    //
    //    //背景图
    //    UIImageView *backImageView = [[UIImageView alloc] init];
    //    backImageView.userInteractionEnabled = YES;
    //    backImageView.image = [UIImage imageNamed:@"numer"];
    //    [scrollView addSubview:backImageView];
    //    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.mas_equalTo(self.view.right-hua_scale(15));
    //        make.centerY.mas_equalTo(quantityLabel);
    //        make.size.mas_equalTo(CGSizeMake(hua_scale(91), hua_scale(29)));
    //    }];
    //
    //    //减少
    //    UIButton *subtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    subtractButton.tag = 189;
    //    [subtractButton setBackgroundImage:[UIImage imageNamed:@"btn_minus"] forState:0];
    //    [subtractButton setBackgroundImage:[UIImage imageNamed:@"btn_minus_select"] forState:UIControlStateSelected];
    //    [backImageView addSubview:subtractButton];
    //    [subtractButton addTarget:self action:@selector(pageAdd:) forControlEvents:UIControlEventTouchUpInside];
    //    [subtractButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(0);
    //        make.top.mas_equalTo(0);
    //        make.width.mas_equalTo(hua_scale(28));
    //        make.bottom.mas_equalTo(0);
    //    }];
    //    //增加
    //    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    addButton.tag = 190;
    //    [addButton setBackgroundImage:[UIImage imageNamed:@"btn_add_select"] forState:0];
    //    [addButton setBackgroundImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateSelected];
    //    [addButton addTarget:self action:@selector(pageAdd:) forControlEvents:UIControlEventTouchUpInside];
    //    [backImageView addSubview:addButton];
    //    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.mas_equalTo(0);
    //        make.top.mas_equalTo(0);
    //        make.bottom.mas_equalTo(0);
    //        make.width.mas_equalTo(hua_scale(28));
    //    }];
    //
    //    _numberTypelabel = [UILabel new];
    //    _numberTypelabel.font = [UIFont systemFontOfSize:13];
    //    _numberTypelabel.text = @"1";
    //    _numberTypelabel.textAlignment = NSTextAlignmentCenter;
    //    [backImageView addSubview:_numberTypelabel];
    //    [_numberTypelabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.top.mas_equalTo(0);
    //        make.left.mas_equalTo(subtractButton.mas_right);
    //        make.right.mas_equalTo(addButton.mas_left);
    //    }];
    
    //    //3线
    //    UIView *thView3 = [UIView new];
    //    thView3.backgroundColor = HUAColor(0xe1e1e1);
    //    [scrollView addSubview:thView3];
    //    thView3.sd_layout
    //    .topSpaceToView(thView2,hua_scale(50))
    //    .heightIs(1)
    //    .widthIs(scrollView.width);
    
    
    
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
        make.height.mas_equalTo(hua_scale(27));
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
    thView4.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView4];
    thView4.sd_layout
    .topSpaceToView(iocnImage,hua_scale(10))
    .heightIs(1)
    .widthIs(scrollView.width);
    
    
    //5线
    UIView *thView5 = [UIView new];
    thView5.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView5];
    thView5.sd_layout
    .topSpaceToView(thView4,hua_scale(44))
    .heightIs(1)
    .widthIs(scrollView.width);
    
    UIImageView *iocnImageView = [[UIImageView alloc] init];
    iocnImageView.image = [UIImage imageNamed:@"zhifubao"];
    [scrollView addSubview:iocnImageView];
    [iocnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hua_scale(15));
        make.top.mas_equalTo(thView4.mas_bottom).mas_equalTo(hua_scale(10));
        make.size.mas_equalTo(CGSizeMake(hua_scale(25), hua_scale(27)));
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
    thView6.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView6];
    thView6.sd_layout
    .topSpaceToView(thView5,hua_scale(44))
    .heightIs(1)
    .widthIs(scrollView.width);
    
    UIImageView *winImageView = [[UIImageView alloc] init];
    winImageView.image = [UIImage imageNamed:@"weixin"];
    [scrollView addSubview:winImageView];
    [winImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hua_scale(15));
        make.top.mas_equalTo(thView5.mas_bottom).mas_equalTo(hua_scale(10));
        make.size.mas_equalTo(CGSizeMake(hua_scale(25), hua_scale(27)));
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
    winselectsBtn.tag = 193;
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
        make.size.mas_equalTo(CGSizeMake(hua_scale(25), hua_scale(27)));
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
    .heightIs(1)
    .leftEqualToView(thView6)
    .rightEqualToView(thView6);
    
    
    //7线
    UIView *thView7 = [UIView new];
    thView7.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView7];
    thView7.sd_layout
    .topSpaceToView(addThView,hua_scale(45))
    .heightIs(1)
    .leftSpaceToView(scrollView,scrollView.width/2)
    .widthIs(scrollView.width/2);
    
    
    
    UILabel *memberTitle  = [[UILabel alloc] init];
    memberTitle.font = [UIFont systemFontOfSize:hua_scale(13)];
    memberTitle.text = @"产品金额:";
    [scrollView addSubview:memberTitle];
    [memberTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(thView7);
        make.height.mas_equalTo(13);
        make.top.mas_equalTo(addThView.mas_bottom).mas_equalTo(hua_scale(45.0/2.0-13.0/2.0));
    }];
    [memberTitle setSingleLineAutoResizeWithMaxWidth:200];
    
    _memberLabel = [[UILabel alloc] init];
    _memberLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    _memberLabel.text = @"¥ 45";
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
    thView8.backgroundColor = HUAColor(0xe1e1e1);
    [scrollView addSubview:thView8];
    thView8.sd_layout
    .topSpaceToView(thView7,hua_scale(116))
    .heightIs(1)
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
    [successButton addTarget:self action:@selector(pageAdd:) forControlEvents:UIControlEventTouchUpInside];
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
    .heightIs(1)
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

//按钮点击事件
UIButton *bttn = nil;
- (void)pageAdd:(UIButton *)button{
    
    if (bttn != button) {
        button.selected = YES;
        bttn.selected = NO;
    }else{
        button.selected = YES;
    }
    
    bttn = button;
    //    //点击减少数量
    //    if (button.tag == 189 && [_numberTypelabel.text integerValue] >=1) {
    //        _numberTypelabel.text = [NSString stringWithFormat:@"%ld",[_numberTypelabel.text integerValue]-1];
    //        //产品金额
    //        _memberLabel.text = [NSString stringWithFormat:@"¥45 * %ld",[_numberTypelabel.text integerValue]];
    //
    //    }else if(button.tag == 190){
    //        //点击减少数量
    //        _numberTypelabel.text = [NSString stringWithFormat:@"%ld",[_numberTypelabel.text integerValue]+1];
    //        //产品金额
    //        //  UILabel *lable = [self.contentView viewWithTag:10009];
    //        
    //        _memberLabel.text = [NSString stringWithFormat:@"¥45 * %ld",[_numberTypelabel.text integerValue]];
    //        
    //        
    //    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
