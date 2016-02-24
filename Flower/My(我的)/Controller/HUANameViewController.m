//
//  HUANameViewController.m
//  Flower
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUANameViewController.h"

@interface HUANameViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UITableView *tablewView;
@property (nonatomic, strong)UITextField *textField;
@end

@implementation HUANameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"昵称";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveNickname)];
    rightItem.tintColor = HUAColor(0x4da800);
    self.navigationItem.rightBarButtonItems = @[rightItem];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:hua_scale(15)]} forState:UIControlStateNormal];
    self.tablewView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.tablewView.delegate = self;
    self.tablewView.dataSource = self;
    self.tablewView.bounces = NO;
    [self.view addSubview:self.tablewView];
    [self.tablewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self footerView];
    
    //[self.view endEditing:NO];
    //[self.textField endEditing:NO];
}
- (void)saveNickname {
    [self.view endEditing:YES];
    
    if (self.textField.text.length<2 || self.textField.text.length>15) {

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            hud.labelText = @"请输入2-15个字符";
            sleep(1);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
        });

    }else {
       
        //修改昵称
        NSString *token = [HUAUserDefaults getToken];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //传入的参数
        NSDictionary *parameters = @{@"nickname":self.textField.text};
        NSString *url = [HUA_URL stringByAppendingPathComponent:@"user/update_info"];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            _nameBlock(self.textField.text);
            [HUAMBProgress MBProgressFromWindowWithLabelText:@"修改成功!"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
            NSLog(@"%@",error);
        }];

        
//        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
//        HUAUserDetailInfo *detailInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        detailInfo.nickname = self.textField.text;
//        HUALog(@"123%@",detailInfo.nickname);
//        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:detailInfo] forKey:@"data"];
        
        }
    
}




- (void)footerView {

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, hua_scale(44), screenWidth, screenHeight-hua_scale(44)-navigationBarHeight)];
    UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0.5)];
    separateLine.backgroundColor = HUAColor(0xcdcdcd);
    [footerView addSubview:separateLine];
    footerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [footerView addGestureRecognizer:tap];
    self.tablewView.tableFooterView = footerView;
}

- (void)click:(UITapGestureRecognizer *)gr {
    [self.textField resignFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    self.textField = [[UITextField alloc] init];
    //self.textField .clearsOnBeginEditing = YES;
    self.textField.text = self.name;
    self.textField.placeholder = @"请输入昵称,2-10字";
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.font = [UIFont fontWithName:@"Arial" size:15];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    [cell.contentView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(hua_scale(15));
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(40);
    }];

    [self.textField becomeFirstResponder];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return hua_scale(44);
    
}
//- (void)saveUserNickName:(UITextField *)textField {
//    
//}


- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    //当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
   
   
    [self.view endEditing:YES];
    
    return YES;
    
}

#pragma mark----------------textFieldDelegate--------
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 12) {
            return NO;
        }
    
    return YES;
    
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
