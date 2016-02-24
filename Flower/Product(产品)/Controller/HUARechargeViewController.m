//
//  HUARechargeViewController.m
//  Flower
//
//  Created by apple on 16/1/30.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUARechargeViewController.h"
#import "HUAConstRowHeight.h"
@interface HUARechargeViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *textField;
//记录当前button的tag值
@property (nonatomic, assign)NSInteger index;
@end

@implementation HUARechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"充值";
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化界面
    [self initView];
}
//初始化界面
- (void)initView{
    
    //标题
    UILabel *titleLabel = [UILabel labelText:@"选择充值金额 : (冲500送150)" color:HUAColor(0x4da800) font:hua_scale(11)];
    [HUAConstRowHeight adjustTheLabel:titleLabel adjustColor:HUAColor(0x494949) adjustColorRang:NSMakeRange(0, 8) adjustFont:13 adjustFontRang:NSMakeRange(0, 8)];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hua_scale(15));
        make.top.mas_equalTo(hua_scale(20));
    }];
    [titleLabel setSingleLineAutoResizeWithMaxWidth:hua_scale(250)];
    
    
    //标题内容
    UILabel *titleContent = [UILabel labelText:@"充值总额满1000成为初级会员,满2000成为高级会员" color:HUAColor(0x888888) font:hua_scale(11)];
    [HUAConstRowHeight adjustTheLabel:titleContent adjustColor:HUAColor(0X4da800) adjustRang:NSMakeRange(5, 4) towColor:HUAColor(0x4da800) adjustRang:NSMakeRange(17, 4) ];
    [self.view addSubview:titleContent];
    [titleContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(titleLabel);
        
    }];
    [titleContent setSingleLineAutoResizeWithMaxWidth:hua_scale(300)];
    
    //充值金额
    NSArray *array = @[@"200元",@"500元",@"800元",@"1000元",@"2000元",@""];
   __block UIView *view = nil;
    for (int i=0; i<2; i++) {
        for (int x=0; x<3; x++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:array[(i*3)+x] forState:0];
            button.titleLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
            button.layer.masksToBounds = YES;
            [button.layer setBorderWidth:hua_scale(0.5)];
            [button.layer setBorderColor: HUAColor(0xe1e1e1).CGColor];
            [button setBackgroundImage:[UIImage imageNamed:@"rechargerenminbu"] forState:UIControlStateSelected];
            [button setTitleColor:HUAColor(0x494949) forState:0];
            [button setTitleColor:HUAColor(0x4da800) forState:UIControlStateSelected];
            button.tag = 500+(i*3)+x;
            [button addTarget:self action:@selector(selecteClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (i==0) {
                    make.top.mas_equalTo(titleContent.mas_bottom).mas_equalTo(hua_scale(15));
                    if (x==0) {
                        make.left.mas_equalTo(hua_scale(15));
                    }
                    if (x==1) {
                        make.centerX.mas_equalTo(0);
                    }
                    if (x==2) {
                        make.right.mas_equalTo(hua_scale(-15));
                    }
                  
                }else{
            
                    if (x==0) {
                        make.top.mas_equalTo(view.mas_bottom).mas_equalTo(hua_scale(10));
                        make.left.mas_equalTo(hua_scale(15));
                    }
                    if (x==1) {
                        make.top.mas_equalTo(view.mas_top);
                        make.centerX.mas_equalTo(0);
                    }
                    if (x==2) {
                        make.right.mas_equalTo(hua_scale(-15));
                        make.top.mas_equalTo(view.mas_top);
                    }
                  
                }
                make.size.mas_equalTo(CGSizeMake(hua_scale(90), hua_scale(35)));
            }];
            //记录最后一个位置
              view = button;
          
            //最后一个button创建uitextField
            if (i==1&&x==2) {
               
                self.textField = [[UITextField alloc]init];
                self.textField.placeholder = @"输入金额";
                self.textField.font = [UIFont systemFontOfSize:hua_scale(12)];
                self.textField.delegate=self;
                self.textField.keyboardType = UIKeyboardTypeNumberPad;
                self.textField.textAlignment = UITextAlignmentCenter;
                //self.textField.backgroundColor = [UIColor yellowColor];
                [view addSubview:self.textField];
                [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.mas_equalTo(hua_scale(2));
                    make.right.bottom.mas_equalTo(hua_scale(-2));
                    
                }];
            }
        }
    }
    
    
    
    
    UILabel *modeLabel = [[UILabel alloc] init];
    modeLabel.text = @"支付方式";
    modeLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    [self.view addSubview:modeLabel];
    [modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_bottom).mas_equalTo(hua_scale(15));
        make.left.mas_equalTo(hua_scale(15));
    }];
    [modeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    UIImageView *iocnImage = [[UIImageView alloc] init];
    iocnImage.image = [UIImage imageNamed:@"zhifubao"];
    [self.view addSubview:iocnImage];
    [iocnImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hua_scale(15));
        make.top.mas_equalTo(modeLabel.mas_bottom).mas_equalTo(hua_scale(14));
        make.height.mas_equalTo(hua_scale(25));
        make.width.mas_equalTo(hua_scale(25));
    }];
    
    UILabel *huiyuanLbale  = [[UILabel alloc] init];
    huiyuanLbale.text = @"支付宝";
    huiyuanLbale.textColor = HUAColor(0x494949);
    huiyuanLbale.font = [UIFont systemFontOfSize:hua_scale(11)];
    [self.view addSubview:huiyuanLbale];
    [huiyuanLbale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iocnImage.mas_right).mas_equalTo(hua_scale(8));
        make.top.mas_equalTo(iocnImage);
    }];
    [huiyuanLbale setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UILabel *title  = [[UILabel alloc] init];
    title.text = @"推荐拥有支付宝的用户使用";
    title.font = [UIFont systemFontOfSize:hua_scale(9)];
    title.textColor = HUAColor(0x494949);
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iocnImage.mas_right).mas_equalTo(hua_scale(8));
        make.bottom.mas_equalTo(iocnImage.mas_bottom);
    }];
    [title setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.tag = 191;
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"do_not_select"] forState:0];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"chooseButton_yes"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(hua_scale(-15));
        make.top.mas_equalTo(iocnImage);
        make.height.mas_equalTo(hua_scale(15));
        make.width.mas_equalTo(hua_scale(15));
    }];
    //1线
    UIView *thView1 = [UIView new];
    thView1.backgroundColor = HUAColor(0xe1e1e1);
    [self.view addSubview:thView1];
    [thView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(iocnImage);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(hua_scale(0.5));
    }];
    
    //手势背景
    UIView *bgView1 = [UIView new];
    bgView1.backgroundColor = [UIColor clearColor];
    bgView1.tag = 1231;
    [bgView1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton:)]];
    [self.view addSubview:bgView1];
    [bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iocnImage.mas_top).mas_equalTo(hua_scale(-5));
        make.bottom.mas_equalTo(thView1.mas_top);
        make.right.left.mas_equalTo(self.view);
    }];
    
//微信支付
    UIImageView *iocnImageView = [[UIImageView alloc] init];
    iocnImageView.image = [UIImage imageNamed:@"weixin"];
    [self.view addSubview:iocnImageView];
    [iocnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hua_scale(15));
        make.top.mas_equalTo(thView1.mas_bottom).mas_equalTo(hua_scale(10));
        make.size.mas_equalTo(CGSizeMake(hua_scale(25), hua_scale(25)));
    }];
    
    UILabel *yuanLbale  = [[UILabel alloc] init];
    yuanLbale.text = @"微信";
    yuanLbale.font = [UIFont systemFontOfSize:hua_scale(11)];
    [self.view  addSubview:yuanLbale];
    [yuanLbale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iocnImageView.mas_right).mas_equalTo(hua_scale(8));
        make.top.mas_equalTo(iocnImageView);
    }];
    [yuanLbale setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UILabel *titleL  = [[UILabel alloc] init];
    titleL.text = @"推荐已开通微信钱包的用户使用";
    titleL.font = [UIFont systemFontOfSize:hua_scale(9)];
    titleL.textColor = HUAColor(0x494949);
    [self.view  addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iocnImageView.mas_right).mas_equalTo(hua_scale(8));
        make.bottom.mas_equalTo(iocnImageView.mas_bottom);
    }];
    [titleL setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UIButton *selectsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectsBtn.tag = 192;
    [selectsBtn setBackgroundImage:[UIImage imageNamed:@"do_not_select"] forState:0];
    [selectsBtn setBackgroundImage:[UIImage imageNamed:@"chooseButton_yes"] forState:UIControlStateSelected];
    [selectsBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:selectsBtn];
    [selectsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(hua_scale(-15));
        make.top.mas_equalTo(iocnImageView);
        make.height.mas_equalTo(hua_scale(15));
        make.width.mas_equalTo(hua_scale(15));
    }];
    
    //2线
    UIView *thView2 = [UIView new];
    thView2.backgroundColor = HUAColor(0xe1e1e1);
    [self.view addSubview:thView2];
    [thView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(thView1);
        make.top.mas_equalTo(iocnImageView.mas_bottom).mas_equalTo(hua_scale(10));
    }];
   
    //手势背景
    UIView *bgView2 = [UIView new];
    bgView2.backgroundColor = [UIColor clearColor];
    bgView2.tag = 1232;
    [bgView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton:)]];
    [self.view addSubview:bgView2];
    [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iocnImageView.mas_top).mas_equalTo(hua_scale(-5));
        make.bottom.mas_equalTo(thView2.mas_top);
        make.right.left.mas_equalTo(self.view);
    }];

    

    //立即充值
    UIButton *topUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topUpButton setTitle:@"立即充值" forState:0];
    topUpButton.backgroundColor = HUAColor(0x4da800);
    topUpButton.clipsToBounds = YES;
    topUpButton.layer.borderWidth =1;
    topUpButton.layer.borderColor = HUAColor(0x4da800).CGColor;//设置边框颜色
    topUpButton.layer.cornerRadius =3.f;
    [topUpButton addTarget:self action:@selector(top_up:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topUpButton];
    [topUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(hua_scale(-15));
        make.bottom.mas_equalTo(hua_scale(-10));
        make.left.mas_equalTo(hua_scale(15));
        make.height.mas_equalTo(hua_scale(35));
    }];
    
    //3线
    UIView *thView3 = [UIView new];
    thView3.backgroundColor = HUAColor(0xe1e1e1);
    [self.view addSubview:thView3];
    [thView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(topUpButton.mas_top).mas_equalTo(hua_scale(-10));
    }];
    
 
}


//选择充值金额
UIButton *_selecteButton = nil;
- (void)selecteClick:(UIButton *)sender{
  //  sender.selected = !sender.selected;
    _index = sender.tag;
    UIButton *buton = [self.view viewWithTag:505];
    buton.selected = NO;
    [_textField endEditing:YES];
    if (_selecteButton!=sender) {
        sender.selected = YES;
         _selecteButton.selected = NO;
    }else{
        sender.selected = YES;
    }
    _selecteButton = sender;
    
}
//选择充值方式
UIButton *selecte = nil;
- (void)click:(UIButton *)sender{
    [_textField endEditing:YES];
    if (selecte!=sender) {
        sender.selected = YES;
        selecte.selected = NO;
    }else{
    
        sender.selected = YES;
    }
    
    selecte = sender;
}
//立即充值
- (void)top_up:(UIButton *)sender{
    HUALog(@"%ld",_index);
    
    NSString *money = [[NSString alloc] init];
    if (_index==505) {
        //看输入的金额是否小于1
        if (self.textField.text.integerValue < 1) {
            [HUAMBProgress MBProgressFromView:self.view wrongLabelText:@"请输入你要充值的金额"];
            return;
        }else if (self.textField.text.integerValue >5000){
        //看输入的金额是否大于5000
             [HUAMBProgress MBProgressFromView:self.view wrongLabelText:@"最大限制为5000"];
            return;
        }else{
            
            HUALog(@"立即充值%@元",self.textField.text);
            money = self.textField.text;
        }
        
    }else{
        if (_index==0) {
            return;
        }else{
        UIButton *button = [self.view viewWithTag:_index];
            if (button.selected == YES) {
                NSLog(@"%@",button.titleLabel.text);
                money = button.titleLabel.text;
        }
    }
}

    //判断是否选择了支付方式
    if (selecte.selected == YES) {
        NSLog(@"跳转充值,充值的金额为%@,充值的方式为%@",money,selecte.tag==191? @"支付宝":@"微信");
    }else{
    [HUAMBProgress MBProgressFromView:self.view wrongLabelText:@"请选择支付方式"];
    }
    

}


#pragma mark----------------textFieldDelegate--------
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.textField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 4) {
            return NO;
        }
    }
    
    return YES;
}
//点击View的其他区域隐藏软键盘。
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

//开始编辑UITextField时调用的代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _selecteButton.selected = NO;
    _index = 505;
    UIButton *buton = [self.view viewWithTag:505];
    buton.selected = YES;
    return YES;
}


//手势选中
- (void)clickButton:(UITapGestureRecognizer *)tap{
    UIButton *button = [self.view viewWithTag:tap.view.tag-1231+191];
    if (selecte!=button) {
        button.selected = YES;
        selecte.selected = NO;
    }else{
        selecte.selected = YES;
    }

    selecte = button;
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
