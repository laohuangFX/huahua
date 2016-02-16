//
//  HUAMyInformationViewController.m
//  Flower
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Update_info @"user/update_info"
#import "HUAMyInformationViewController.h"
#import "HUAMyInformationTableViewCell.h"
#import "HUANameViewController.h"
#import "HUAReceivingViewController.h"
#import "HUAUserDetailInfo.h"
#import "HATransparentView.h"
#import "STPhotoBrowserController.h"

@interface HUAMyInformationViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,HATransparentViewDelegate>{
    NSString *yearStr ;
    NSString *moonStr ;
    NSString *sunStr  ;
    NSData *imgData;

}
@property (nonatomic, strong)HATransparentView *transparentView;

@property (nonatomic,strong)UITableView *tablewView;
@property (nonatomic, strong)NSArray *myInformationArray;
@property (nonatomic, strong)NSArray *model;
//获取cell的图片
@property (nonatomic, strong)UIImageView *imageView;
//性别选择器
@property (nonatomic, strong)UIView *keyboard;
//生日选择器
@property (nonatomic, strong)UIPickerView *dayPickerView;
@property (nonatomic, strong)UIView *dayboard;

@property (nonatomic, strong)NSArray *sexArray;
@property (nonatomic, strong)NSArray *darArray;
@property (nonatomic, strong)NSString *selectStr;

//性别
@property (nonatomic, strong)UILabel *sexLable;
//生日
@property (nonatomic, strong)UILabel *birthdayLabel;
//昵称
@property (nonatomic, strong)UILabel *nameLabel;
//遮盖图
@property (nonatomic, strong)UIView *outView;

//记录当前是第几行
@property (nonatomic, assign)NSInteger index;

//时间
@property (nonatomic, strong)NSMutableArray *yearArray;
@property (nonatomic, strong)NSMutableArray *moonArray;
@property (nonatomic, strong)NSMutableArray *sunArray;
@property (nonatomic, strong)NSString *dateStr;
@end

@implementation HUAMyInformationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取时间
    [self getDate];
    self.myInformationArray = @[@"头像",@"昵称",@"性别",@"生日",@"收货地址"];
    
   
    
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tablewView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.tablewView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tablewView.delegate = self;
    self.tablewView.dataSource = self;
    [self.view addSubview:self.tablewView];
    [self.tablewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-200);
    }];
    
    [self setSexPickerView];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
    HUAUserDetailInfo *detailInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.nameLabel.text = detailInfo.nickname;
    self.sexLable.text = [detailInfo.sex isEqualToString:@"0"]?@"女":@"男";
    self.birthdayLabel.text = [HUATranslateTime translateTimeIntoCurrurent:detailInfo.birth.longLongValue];
    HUALog(@"dfsfsdfsfs%@,,%@,,%@",detailInfo.nickname,detailInfo.sex,detailInfo.birth);
    self.model =@[@"jjj",detailInfo.nickname,[detailInfo.sex isEqualToString:@"0"]?@"女":@"男",[HUATranslateTime translateTimeIntoCurrurent:detailInfo.birth.longLongValue],@" "];
    [self setbirthdayPickerView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    NSString *url = [HUA_URL stringByAppendingPathComponent:Update_info];
    
    NSString *birthday = [HUATranslateTime translateDateIntoTimestamp:self.birthdayLabel.text];
    HUALog(@"shengri%@,,,%@,,%@,%@",birthday,self.nameLabel.text,self.sexLable.text,self.birthdayLabel.text);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"nickname"] = self.nameLabel.text;
    parameters[@"sex"] = [self.sexLable.text isEqualToString:@"男"]?@"1":@"0";
    //parameters[@"birth"] = birthday;
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HUALog(@"data%@",responseObject);
      
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
    
}

- (void) getDate{
    _yearArray =[NSMutableArray array];
    _moonArray = [NSMutableArray array];
    _sunArray = [NSMutableArray array];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //获取当前的年份
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *timeStr = [formatter stringFromDate:[NSDate date]];
    
    //添加任务到全局队列；异步执行任务
    dispatch_async(queue, ^{
        for (int i = 1930; i < timeStr.intValue; i++) {
     
            [_yearArray addObject:[NSString stringWithFormat:@"%d年",i]];
           
        }
    });
    //NSLog(@"打印年份完毕");
    dispatch_async(queue, ^{
        for (int i = 1; i < 13; i++) {
           
            [_moonArray addObject:[NSString stringWithFormat:@"%d月",i]];
        }
    });
    
    //NSLog(@"打印月份完毕");

    dispatch_async(queue, ^{
        for (int i = 1; i < 32; i++) {
            [_sunArray addObject:[NSString stringWithFormat:@"%d日",i]];
        }
    });
    
      //NSLog(@"打印日完毕");
}
//自定义SexPickerView
- (void)setSexPickerView{
    
    //遮盖视图
    _outView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-hua_scale(200))];
    _outView.backgroundColor = [UIColor blackColor];
    _outView.alpha = 0;
    _outView.hidden = YES;
    [self.view addSubview:_outView];
    
    
    //底部视图
    _keyboard = [[UIView alloc] init];
    _keyboard.backgroundColor = HUAColor(0xf9f9f9);
    [self.view addSubview:_keyboard];
    [_keyboard mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view.mas_bottom).mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(hua_scale(200));
    }];

    
    //底部视图
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [_keyboard addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hua_scale(6));
        make.right.mas_equalTo(hua_scale(-6));
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(hua_scale(169));
    }];
    
    //取消按钮
    UIButton *romeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    romeButton.tag = 107;
    romeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [romeButton setTitleColor:HUAColor(0x666666) forState:0];
    [romeButton setTitle:@"取消" forState:UIControlStateNormal];
    [romeButton addTarget:self action:@selector(ActionChange:) forControlEvents:UIControlEventTouchUpInside];
    [_keyboard addSubview:romeButton];
    [romeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(hua_scale(10));
        make.top.mas_equalTo(hua_scale(4));
        make.bottom.mas_equalTo(backView.mas_top).mas_equalTo(hua_scale(-4));
        make.width.mas_equalTo(hua_scale(30));
        
    }];
    
    //确定按钮
    UIButton *fixedButton = [UIButton buttonWithType:UIButtonTypeSystem];
    fixedButton.tag = 108;
    fixedButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [fixedButton setTitleColor:HUAColor(0x4da800) forState:0];
    [fixedButton setTitle:@"确定" forState:UIControlStateNormal];
    [fixedButton addTarget:self action:@selector(ActionChange:) forControlEvents:UIControlEventTouchUpInside];
    [_keyboard addSubview:fixedButton];
    [fixedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(hua_scale(-10));
        make.size.mas_equalTo(romeButton);
        make.top.mas_equalTo(romeButton);
        
    }];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    // 显示选中框
    
    pickerView.showsSelectionIndicator=YES;
    pickerView.dataSource = self;
    [pickerView selectedRowInComponent:0];
    pickerView.delegate = self;
    [_keyboard addSubview:pickerView];
    _sexArray = @[@"男",@"女"];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(backView.mas_top).mas_equalTo(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(hua_scale(100));
    }];
   

}
- (void)setbirthdayPickerView{
//   NSLog(@"%ld",_sunArray.count);
//    NSLog(@"%ld",_moonArray.count);
//    NSLog(@"%ld",_yearArray.count);
    //底部视图
    _dayboard = [[UIView alloc] init];
    _dayboard.backgroundColor = HUAColor(0xf9f9f9);
    [self.view addSubview:_dayboard];
    [_dayboard mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view.mas_bottom).mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(hua_scale(200));
    }];
    
    
    //底部视图
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [_dayboard addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hua_scale(6));
        make.right.mas_equalTo(hua_scale(-6));
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(hua_scale(169));
    }];
    
    //取消按钮
    UIButton *romeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    romeButton.tag = 109;
    romeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [romeButton setTitleColor:HUAColor(0x666666) forState:0];
    [romeButton setTitle:@"取消" forState:UIControlStateNormal];
    [romeButton addTarget:self action:@selector(ActionChange:) forControlEvents:UIControlEventTouchUpInside];
    [_dayboard addSubview:romeButton];
    [romeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(hua_scale(10));
        make.top.mas_equalTo(hua_scale(4));
        make.bottom.mas_equalTo(backView.mas_top).mas_equalTo(hua_scale(-4));
        make.width.mas_equalTo(hua_scale(30));
        
    }];
    
    //确定按钮
    UIButton *fixedButton = [UIButton buttonWithType:UIButtonTypeSystem];
    fixedButton.tag = 110;
    fixedButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [fixedButton setTitleColor:HUAColor(0x4da800) forState:0];
    [fixedButton setTitle:@"确定" forState:UIControlStateNormal];
    [fixedButton addTarget:self action:@selector(ActionChange:) forControlEvents:UIControlEventTouchUpInside];
    [_dayboard addSubview:fixedButton];
    [fixedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(hua_scale(-10));
        make.size.mas_equalTo(romeButton);
        make.top.mas_equalTo(romeButton);
        
    }];
    
    _dayPickerView = [[UIPickerView alloc] init];
    // 显示选中框
    //_dayPickerView.backgroundColor = [UIColor redColor];
    _dayPickerView.showsSelectionIndicator=YES;
    _dayPickerView.dataSource = self;
    [_dayPickerView selectedRowInComponent:0];
    _dayPickerView.delegate = self;
    [_dayboard addSubview:_dayPickerView];
    _darArray = @[@"一天",@"两天"];
    [_dayPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(backView.mas_top).mas_equalTo(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(hua_scale(100));
    }];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
       return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
    HUAUserDetailInfo *detailInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.nameLabel.text = detailInfo.nickname;
    self.sexLable.text = [detailInfo.sex isEqualToString:@"0"]?@"女":@"男";
    self.birthdayLabel.text = [HUATranslateTime translateTimeIntoCurrurent:self.birthString.longLongValue];

    static NSString *identifier  = @"cell";
    HUAMyInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HUAMyInformationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
  
    if (indexPath.row==0) {
        cell.InformationLabel.hidden = YES;
        cell.headImage.hidden=NO;
        cell.headImage.image = [UIImage imageNamed:self.model[indexPath.row]];
        //添加手势进入浏览大图
        [cell.headImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browseImage:)]];
        
        //把self.imageView的指针指向cell.headImage
        self.imageView  = [UIImageView new];
        self.imageView = cell.headImage;
        
    }
  
    cell.InformationLabel.text = self.model[indexPath.row];

    cell.textLabel.text = self.myInformationArray[indexPath.row];
    cell.textLabel.textColor = HUAColor(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 60;
    }
    return 44;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HUAMyInformationTableViewCell *cell = [_tablewView cellForRowAtIndexPath:indexPath];
   
    
    if (indexPath.row==2) {
        
        _sexLable = cell.InformationLabel;
        HUALog(@"%@",self.sexLable.text);
        _index = indexPath.row;
        
        [self clickk];
    }else if (indexPath.row==3){
        
        _birthdayLabel  =cell.InformationLabel;
        _index = indexPath.row;
        [self clickk];
    }else if (indexPath.row==1){
        
        _nameLabel = cell.InformationLabel;
        _index = indexPath.row;
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
        HUAUserDetailInfo *detailInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        HUANameViewController *vc = [[HUANameViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.name = detailInfo.nickname;
        [self.navigationController pushViewController:vc animated:YES];
        
        //调用block
        vc.nameBlock = ^(NSString *text){
        
            _nameLabel.text = text;
        
        };
    
    }else if (indexPath.row == 4){
       
        HUAReceivingViewController *vc = [[HUAReceivingViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }else {
        //换头像
        [self changeHeadIcon];
    }

}
//浏览大图
- (void)browseImage:(UITapGestureRecognizer *)tap{
    UIImageView *Imageview = (UIImageView *)tap.view;

    _transparentView = [[HATransparentView alloc] init];
    _transparentView.delegate = self;
    _transparentView.tapBackgroundToClose = YES;
    _transparentView.hideCloseButton = YES;
    _transparentView.backgroundColor = [UIColor blackColor];
    [_transparentView open];
    
    UIScrollView *scrollView = [UIScrollView new];
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.showsVerticalScrollIndicator = NO;
      scrollView.scrollsToTop = YES;
   scrollView.directionalLockEnabled = YES;
   scrollView.delegate = self;
     scrollView.contentSize = CGSizeMake(self.view.width,self.view.height);
    scrollView.minimumZoomScale = 0.5;
    scrollView.maximumZoomScale = 2;
   
    scrollView.backgroundColor = [UIColor blackColor];
    [_transparentView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_transparentView);

    }];
   
    UIImageView *view = [[UIImageView alloc] init];
    view.tag = 1990;
    view.frame = self.imageView.frame;
    view.y = view.frame.origin.y+64;
    view.image = self.imageView.image;
    [scrollView addSubview:view];
    
    [scrollView updateLayout];
    [UIView animateWithDuration:1 animations:^{

        view.left = _transparentView.left;
        view.width =self.view.width;
        view.height = hua_scale(200);
        view.centerY = _transparentView.centerY;
        
    }];
    
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)]];

}


//退出浏览模式
- (void)removeView:(UITapGestureRecognizer *)tap{
    UIImageView *view = [_transparentView viewWithTag:1990];
    [UIView animateWithDuration:0.5 animations:^{
        view.frame = self.imageView.frame;
        view.y = self.imageView.origin.y+64;
        _transparentView.alpha = 0;
    } completion:^(BOOL finished) {
        [_transparentView close];
    }];
    
    
}

//改变头像
- (void)changeHeadIcon{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //添加取消按钮
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击");
        
    }];
    
    //添加从手机相册选择
    UIAlertAction *phoneAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *pc = [UIImagePickerController new];
        //获取图片以后，图片会从代理中回传给我们
        pc.delegate = self;
        // 开启编辑状态
        pc.allowsEditing = YES;
        
        [self presentViewController:pc animated:YES completion:nil];
    }];
    
    //添加拍照
    UIAlertAction *pictureAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImagePickerController *pc = [UIImagePickerController new];
        //获取图片以后，图片会从代理中回传给我们
        pc.delegate = self;
        //数据的获取源，模式是相册
        pc.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pc animated:YES completion:nil];
        
    }];
    
    [alertC addAction:cancleAction];
    [alertC addAction:pictureAction];
    [alertC addAction:phoneAction];
    
    // [alertC showDetailViewController:[HUAMyInformationViewController new] sender:nil];
    
    [self presentViewController:alertC animated:YES completion:nil];

}


- (void)clickk{
    

    
    if (_index == 3) {
        [UIView animateWithDuration:0.5 animations:^{
            
            _outView.hidden = NO;
            _outView.alpha = 0.3;
            
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _dayboard.frame = CGRectMake(0, self.view.height-hua_scale(200), self.view.width, hua_scale(200));
            
            
        }];

    }else{
    
        [UIView animateWithDuration:0.5 animations:^{
            
            _outView.hidden = NO;
            _outView.alpha = 0.3;
            
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _keyboard.frame = CGRectMake(0, self.view.height-hua_scale(200), self.view.width, hua_scale(200));
  
        }];

    }
 
}

- (void)initkeyBoard{
 
}

- (void)ActionChange:(UIButton *)button{
  
    if (button.tag == 107 || button.tag == 109) {
        [UIView animateWithDuration:0.3 animations:^{
            
            _keyboard.frame = CGRectMake(0, self.view.bottom, self.view.width, 200);
            _dayboard.frame = CGRectMake(0, self.view.bottom, self.view.width, 200);
            _outView.alpha = 0;
            _outView.hidden = YES;

        }];
        
    }else if(button.tag == 108) {
       
        [UIView animateWithDuration:0.3 animations:^{
            
            _keyboard.frame = CGRectMake(0, self.view.bottom, self.view.width, 200);
            
            _outView.alpha = 0;
            _outView.hidden = YES;
            
        }];
        
        if (_selectStr==nil) {
            
            _sexLable.text = _sexArray.firstObject;
        }else{
            _sexLable.text = _selectStr;
        }
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
        HUAUserDetailInfo *detailInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        //_birthdayLabel.text = detailInfo.sex;
        detailInfo.sex = [_sexLable.text isEqualToString:@"男"]?@"1":@"0";
        //HUALog(@"````````%@,,,%@",_selectStr,detailInfo.birth);
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:detailInfo] forKey:@"data"];
        //修改性别
        NSString *token = [HUAUserDefaults getToken];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];

        //传入的参数
        NSDictionary *parameters = @{@"sex":[_selectStr isEqualToString:@"男"]? @"1":@"0"};
        NSString *url = [HUA_URL stringByAppendingPathComponent:@"user/update_info"];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
  
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
            NSLog(@"%@",error);
        }];


    }else{
       
        [UIView animateWithDuration:0.3 animations:^{
            
            _dayboard.frame = CGRectMake(0, self.view.bottom, self.view.width, 200);
            
            _outView.alpha = 0;
            _outView.hidden = YES;
            
        }];
        
        if (_index == 3) {
            
            if ([sunStr rangeOfString:@"日"].location != NSNotFound) {
                NSRange rang = [sunStr rangeOfString:@"日"];
                sunStr = [sunStr substringWithRange:NSMakeRange(0, rang.location)];
                NSLog(@"%@",sunStr);
            }
            if ([moonStr rangeOfString:@"月"].location != NSNotFound){
                NSRange rang = [moonStr rangeOfString:@"月"];
                moonStr = [moonStr substringWithRange:NSMakeRange(0, rang.location)];
                NSLog(@"%@",moonStr);
            }
            if ([yearStr rangeOfString:@"年"].location !=NSNotFound){
                NSRange rang = [yearStr rangeOfString:@"年"];
                yearStr = [yearStr substringWithRange:NSMakeRange(0, rang.location)];
                NSLog(@"%@",yearStr);
            }


            
            if (sunStr==nil) {
                sunStr = [NSString stringWithFormat:@"01"];
            }else if(sunStr.length == 1){
                sunStr = [NSString stringWithFormat:@"0%@",sunStr];
            }
            
            
            if (moonStr==nil) {
                moonStr = [NSString stringWithFormat:@"01"];
            }else if(moonStr.length == 1){
                moonStr = [NSString stringWithFormat:@"0%@",moonStr];
            }
            if (yearStr==nil) {
                yearStr = [NSString stringWithFormat:@"2000"];
            }


            _birthdayLabel.text = [NSString stringWithFormat:@"%@-%@-%@",yearStr,moonStr,sunStr];
            
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
            HUAUserDetailInfo *detailInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];

            detailInfo.birth = [HUATranslateTime translateDateIntoTimestamp:_birthdayLabel.text];

            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:detailInfo] forKey:@"data"];
            
            //修改性别
            NSString *token = [HUAUserDefaults getToken];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
            //申明返回的结果是json类型
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
           
            NSString *url = [HUA_URL stringByAppendingPathComponent:@"user/update_info"];
              NSDictionary *parameters = @{@"birth":[HUATranslateTime translateDateIntoTimestamp:_birthdayLabel.text]};
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
                
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
                NSLog(@"%@",error);
            }];

        }
       
    }

}

#pragma mark - UIImagePickerControllerDelegate
//相片选取控制器 不会把本身消失掉，需要我们在回调中处理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [self fixOrientation:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
        
        imgData = UIImageJPEGRepresentation(image, 0.01);
        
        NSLog(@"您选择了图片");
        NSLog(@"%lu", imgData.length);
    //  获取原始视图
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
    //  获取编辑状态的视图
    self.imageView.image = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
  }

}

    //修正照片方向(手机转90度方向拍照)
- (UIImage *)fixOrientation:(UIImage *)aImage {
        
        // No-op if the orientation is already correct
        if (aImage.imageOrientation == UIImageOrientationUp)
            return aImage;
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        switch (aImage.imageOrientation) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
                transform = CGAffineTransformRotate(transform, M_PI);
                break;
                
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
                
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
                break;
            default:
                break;
        }
        
        switch (aImage.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
                
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
            default:
                break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                                 CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                                 CGImageGetColorSpace(aImage.CGImage),
                                                 CGImageGetBitmapInfo(aImage.CGImage));
        CGContextConcatCTM(ctx, transform);
        switch (aImage.imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                // Grr...
                CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
                break;
                
            default:
                CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
                break;
        }
        
        // And now we just create a new UIImage from the drawing context
        CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
        UIImage *img = [UIImage imageWithCGImage:cgimg];
        CGContextRelease(ctx);
        CGImageRelease(cgimg);
        return img;
}





    
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---- UIPickerViewDelegate
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    if (_dayPickerView==pickerView) {
        return 3;
    }
    
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (_dayPickerView==pickerView) {
        if (component==0) {
            return _yearArray.count;
        }else if (component==1){
        return _moonArray.count;
        }else{
        return _sunArray.count;
        }
    }

    
    return _sexArray.count;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (component == 0) {
        return 90;
    }
    else{
        return 65;
    }
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if (_dayPickerView == pickerView) {
        if (component==0) {
            yearStr = [NSString stringWithFormat:@"%@",_yearArray[row]];
            //NSLog(@"%@",yearStr);
        }else if (component==1){
            moonStr = [NSString stringWithFormat:@"%@",_moonArray[row]];
           // NSLog(@"%@",moonStr);

        }else{
            sunStr = [NSString stringWithFormat:@"%@",_sunArray[row]];
        //NSLog(@"%@",sunStr);
        }
        
       
        //截取最后一个字符
        NSLog(@"年：%@，月：%@，ri：%@",yearStr,moonStr,sunStr);
//        _dateStr = [NSString stringWithFormat:@"%@-%@-%@",yearStr,moonStr,sunStr];
//            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
//            HUAUserDetailInfo *detailInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//           _birthdayLabel.text = [HUATranslateTime translateTimeIntoCurrurent:detailInfo.birth.longLongValue];
        //NSLog(@"%@",_birthdayLabel.text);
//            detailInfo.birth = [HUATranslateTime translateDateIntoTimestamp:[NSString stringWithFormat:@"%@-%@-%@",yearStr,moonStr,sunStr]];
//            HUALog(@"````````%@,,,%@",_birthdayLabel.text,detailInfo.birth);
//            
//            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:detailInfo] forKey:@"data"];
            //[self.tablewView reloadData];
        
    }else{
        _selectStr = _sexArray[row];

        //[self.tablewView reloadData];
    }
}





//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_dayPickerView == pickerView) {
        if (component==0) {
            return _yearArray[row];
        }else if (component==1){
            
            return _moonArray[row];
           
        }else{
          return _sunArray[row];
        }
        
    }
    
       return _sexArray[row];
}

#pragma mark - scrollview代理方法

// 返回一个放大或者缩小的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [_transparentView viewWithTag:1990];
    
}
// 缩放结束时
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    UIImageView *imageView = [_transparentView viewWithTag:1990];
    
    [UIView animateWithDuration:0.1 animations:^{
        
        imageView.centerY = _transparentView.centerY;
    }];
    
    
}


- (void)HATransparentViewDidClosed
{
    NSLog(@"Did close");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

