//
//  HUAMakeAnAppointmentViewController.m
//  Flower
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAMakeAnAppointmentViewController.h"
#import "HUAMakeAnAppointmentTableViewCell.h"
#import "HUADate.h"
#import "HUATechniciansOrdersViewController.h"

@interface HUAMakeAnAppointmentViewController ()<UITableViewDataSource,UITableViewDelegate,HATransparentViewDelegate>{
    
    int _page;
    UIView *_bgView;
    //记录上一次视图的位置;
    UIView *_lastView;
    NSDictionary *_dic;
    UIButton *_selecteTimeButton;//选中的时间
    NSArray *_appointmentTime;//早班时间
    //底部弹出的视图
    UIView  *_tanBgview;
    //记录上次选择的项目
    UIImageView *_selecteImageView;
    UIButton    *_selecteSender;
    
}
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dateArray;
@property (nonatomic, strong)UIButton *loadingButton;
@property (nonatomic, strong)UITableView *lastTbaleView;
//选择项目table
@property (nonatomic, strong)UITableView *serviceTableView;
//遮盖视图
@property (strong, nonatomic)HATransparentView *transparentView;

//会员信息
@property (nonatomic, strong)NSDictionary *membersInformation;

@end

@implementation HUAMakeAnAppointmentViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约";
    
    
    //初始化
    _page = 7;
    _lastTbaleView = nil;
    
    self.dateArray = [NSMutableArray array];
    
    //获取会员信息
    [self membersData];
    
    //获取数据
    //[self getData];
    
    
    //获取日期
    [self getDate:0];
    
    [self initScrollView];
    
    
    //初始化选择项目列表
    //[self  initServiceTableView];
    
}
//- (void)getData{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
//    NSString *url = [HUA_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"master/master_appointment?master_id=%@&range_type_id=%@",self.master_id,self.range_type_id]];
//
//    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//       NSString *type = responseObject[@"info"][@"range_type"][@"type_name"];
//        NSArray *array = responseObject[@"info"][@"range_type"][@"time_list"];
//
//        _dic = @{@"type":type,@"array":array,};
//        NSLog(@"%@",_dic[@"type"]);
//
//        [self.tableView reloadData];
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//}
//获取会员数据
- (void)membersData{
    
    NSString *token = [HUAUserDefaults getToken];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    NSString *url = [HUA_URL stringByAppendingPathComponent:@"user/is_vip"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"shop_id"] =self.shop_id;
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        self.membersInformation = responseObject;
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
    
    
}
- (void)getDate:(int )page{
    
    
    //获取当前时间戳的方法
    for (int i= 0; i<7; i++) {
        NSDate *date=[NSDate dateWithTimeIntervalSinceNow:24*60*60*(i+page)];
        
        NSTimeInterval time=[date timeIntervalSince1970];
        
        
        NSString *strTime=[NSString stringWithFormat:@"%.0f",time];
        
        
        NSString *weekStr = [HUADate getWeekDayFordate:[strTime integerValue]];
        // NSLog(@"%@",weekStr);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd"];
        NSString *timeStr = [formatter stringFromDate:date];
        //NSLog(@"%@",timeStr);
        
        NSDictionary *dic = @{@"date":timeStr,@"week":weekStr};
        
        
        
        [self.dateArray addObject:dic];
        
    }
}
- (void)initScrollView{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.model.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.scrollView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(hua_scale(10));
        make.size.mas_equalTo(CGSizeMake(hua_scale(50), hua_scale(50)));
    }];
    //姓名
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = self.model.masterName;
    nameLabel.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImageView.mas_top).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(headImageView.mas_right).mas_equalTo(hua_scale(10));
    }];
    [nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    //技师类型
    UILabel *technicianLabel = [UILabel new];
    technicianLabel.text = self.model.masterType;
    technicianLabel.textColor = HUAColor(0x999999);
    technicianLabel.font = [UIFont systemFontOfSize:11];
    [self.scrollView addSubview:technicianLabel];
    [technicianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel);
        make.left.mas_equalTo(nameLabel.mas_right).mas_equalTo(hua_scale(9));
    }];
    [technicianLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    //点赞按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //addButton.backgroundColor = [UIColor redColor];
    [addButton setTitleColor:HUAColor(0x4da800) forState:0];
    addButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [addButton setTitle:self.model.praise_count forState:0];
    [addButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [addButton setImage:[UIImage imageNamed:@"praise_select"] forState:0];
    [self.scrollView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(nameLabel);
        make.size.mas_equalTo(CGSizeMake(hua_scale(50), hua_scale(14)));
    }];
    
    //线一
    UIView *thView1 = [UIView new];
    thView1.backgroundColor = HUAColor(0xcdcdcd);
    [self.scrollView addSubview:thView1];
    [thView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImageView.mas_bottom).mas_equalTo(hua_scale(10));
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(headImageView);
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-10));
    }];
    
    //选择服务title
    UILabel *serviceLabel = [UILabel new];
    serviceLabel.text = @"选择服务项目";
    serviceLabel.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:serviceLabel];
    [serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView1.mas_bottom).mas_equalTo(hua_scale(15));
        make.left.mas_equalTo(headImageView);
    }];
    [serviceLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    //选择项目按钮
    UIButton *serviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    serviceButton.backgroundColor = HUAColor(0xf8f8f8);
    serviceButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [serviceButton setTitleColor:HUAColor(0x494949) forState:0];
    serviceButton.tag = 155;
    [serviceButton setTitle:@"-- 请选择 --" forState:0];
    serviceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [serviceButton setImage:[UIImage imageNamed:@"select"] forState:0];
    [serviceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, hua_scale(3), 0, 0)];
    [serviceButton setImageEdgeInsets:UIEdgeInsetsMake(0,hua_scale(280), 0,0)];
    [serviceButton setImage:[UIImage imageNamed:@"select_green"] forState:UIControlStateSelected];
    [serviceButton addTarget:self action:@selector(serviceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:serviceButton];
    [serviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(serviceLabel.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(headImageView);
        make.size.mas_equalTo(CGSizeMake(hua_scale(300), hua_scale(26)));
    }];
    
    //价格title
    UILabel *moneyLabel = [UILabel new];
    moneyLabel.text = @"价格:";
    moneyLabel.font = [UIFont systemFontOfSize:11];
    [self.scrollView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(serviceButton.mas_bottom).mas_equalTo(hua_scale(11));
        make.left.mas_equalTo(headImageView);
    }];
    [moneyLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    //金额
    UILabel *money = [UILabel new];
    money.text = @"¥0.00";
    money.font = [UIFont systemFontOfSize:13];
    money.textColor = HUAColor(0x4da800);
    [self.scrollView addSubview:money];
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(moneyLabel);
        make.left.mas_equalTo(moneyLabel.mas_right).mas_equalTo(hua_scale(5));
    }];
    [money setSingleLineAutoResizeWithMaxWidth:200];
    
    //线2
    UIView *thView2 = [UIView new];
    thView2.backgroundColor = HUAColor(0xcdcdcd);
    [self.scrollView addSubview:thView2];
    [thView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(money.mas_bottom).mas_equalTo(hua_scale(20));
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(headImageView);
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-10));
    }];
    
    UILabel *dateLabel = [UILabel new];
    dateLabel.text =@"选择日期";
    dateLabel.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView2.mas_bottom).mas_equalTo(hua_scale(20));
        make.left.mas_equalTo(headImageView);
    }];
    [dateLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    //线3
    UIView *thView3 =[UIView new];
    thView3.backgroundColor = HUAColor(0xe1e1e1);
    [self.scrollView addSubview:thView3];
    [thView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(hua_scale(1));
        make.left.mas_equalTo(self.scrollView.mas_left).mas_equalTo(hua_scale(10));
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-10));
        make.top.mas_equalTo(dateLabel.mas_bottom).mas_equalTo(hua_scale(10));
    }];
    
    
    _bgView =[UIView new];
    //bgView.backgroundColor = [UIColor yellowColor];
    [self.scrollView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_equalTo(hua_scale(10));
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-10));
        make.height.mas_equalTo(hua_scale(256));
        make.top.mas_equalTo(dateLabel.mas_bottom).mas_equalTo(hua_scale(10));
        
    }];
    //底部视图
    UIView *redView = [UIView new];
    redView.backgroundColor = HUAColor(0xfff6f6);
    [_bgView addSubview:redView];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(hua_scale(26));
        make.height.mas_equalTo(hua_scale(66));
    }];
    UIView *lastView1 = nil;
    NSArray *titleArray = @[@"早班",@"中班",@"晚班"];
    
    for (int i=0; i<9; i++) {
        
        
        UIView *view1 = [UIView new];
        view1.backgroundColor = HUAColor(0xe1e1e1);
        [_bgView addSubview:view1];
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(hua_scale(1));
            make.left.mas_equalTo(thView1);
            make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-10));
            if (i==0) {
                make.top.mas_equalTo(0);
            }else if (i==1){
                make.top.mas_equalTo(lastView1.mas_bottom).mas_equalTo(hua_scale(24));
            }else if (i==8){
                make.bottom.mas_equalTo(0);
                
            }else{
                make.top.mas_equalTo(lastView1.mas_bottom).mas_equalTo(hua_scale(33-1));
            }
        }];
        lastView1 = view1;
        if (i>=0&&i<=2) {
            UILabel *label = [UILabel labelText:titleArray[i] color:nil font:hua_scale(12)];
            [_bgView addSubview:label];
            [label sizeToFit];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                NSLog(@"%f",label.width);
                make.top.mas_equalTo(hua_scale(hua_scale(25.0/2.0-10.0/2.0)-2));
                make.left.mas_equalTo(hua_scale(78*i)+(hua_scale(78.0/2.0-label.width/2.0))+hua_scale(73));
                
            }];
            
            [label updateLayout];
            //NSLog(@"%f",label.width);
        }
        
    }
    UIView *lastView2 = nil;
    for (int i=0; i<5; i++) {
        UIView *view1 = [UIView new];
        view1.backgroundColor = HUAColor(0xe1e1e1);
        [_bgView addSubview:view1];
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(hua_scale(1));
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            
            if (i==0) {
                make.left.mas_equalTo(0);
            }else if (i==1){
                make.left.mas_equalTo(lastView2.mas_right).mas_equalTo(hua_scale(67));
            }else if (i==4)
            {
                make.right.mas_equalTo(0);
            }else{
                make.left.mas_equalTo(lastView2.mas_right).mas_equalTo(hua_scale(78));
            }
        }];
        lastView2 = view1;
    }
    
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    //self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_bgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hua_scale(25));
        make.left.mas_equalTo(self.scrollView.mas_left).mas_equalTo(hua_scale(10));
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-10));
        make.height.mas_equalTo(hua_scale(231));
    }];
    
    
    _loadingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loadingButton.backgroundColor = HUAColor(0xf8f8f8);
    _loadingButton.tag = 190;
    [_loadingButton setTitle:@"加载更多日期..." forState:0];
    _loadingButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [_loadingButton setTitleColor:HUAColor(0x494949) forState:0];
    [_loadingButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:_loadingButton];
    [_loadingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(thView1);
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-10));
        make.height.mas_equalTo(hua_scale(30));
        make.top.mas_equalTo(_bgView.mas_bottom).mas_equalTo(hua_scale(10));
    }];
    
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self.scrollView setupAutoContentSizeWithBottomView:_loadingButton bottomMargin:10];
    
}

//选择项目视图
- (void)initServiceTableView{
    
    // _transparentView.backgroundColor = [UIColor redColor];
    
    _tanBgview = [UIView new];
    _tanBgview.backgroundColor = HUAColor(0xf8f8f8);
    [_transparentView addSubview:_tanBgview];
    NSLog(@"%ld",self.model.serviceArray.count);
    [_tanBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.view);
        make.height.mas_equalTo(hua_scale(self.model.serviceArray.count*39+34));
        make.top.mas_equalTo(self.view.bottom);
    }];
    
    UILabel *lable = [UILabel labelText:@"选择服务项目" color:nil font:hua_scale(14)];
    [_tanBgview addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(hua_scale(14));
        make.top.mas_equalTo(hua_scale(34.0/2.0)-hua_scale(14.0/2.0));;
        make.centerX.mas_equalTo(0);
    }];
    [lable setSingleLineAutoResizeWithMaxWidth:200];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:0];
    [button setTitleColor:HUAColor(0x333333) forState:0];
    button.tag = 154;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button addTarget:self action:@selector(serviceButton:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:hua_scale(12)];
    [_tanBgview addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lable);
        make.right.mas_equalTo(hua_scale(-15));
        make.size.mas_equalTo(CGSizeMake(50, 15));
    }];
    
    [_tanBgview updateLayout];
    self.serviceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.serviceTableView.delegate = self;
    self.serviceTableView.dataSource = self;
    [_tanBgview addSubview:self.serviceTableView];
    [self.serviceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(hua_scale(self.model.serviceArray.count*39));
        make.top.mas_equalTo(hua_scale(34));
        make.left.right.mas_equalTo(0);
    }];
    
}

//点击按钮增加控件
- (void)addTbaleView{
    
    NSArray *titleArray = @[@"早班",@"中班",@"晚班"];
    
    UIView *bgView =[UIView new];
    //bgView.backgroundColor = [UIColor yellowColor];
    [self.scrollView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_equalTo(hua_scale(10));
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-10));
        make.height.mas_equalTo(hua_scale(256));
        if (_lastView != nil) {
            make.top.mas_equalTo(_lastView.mas_bottom).mas_equalTo(hua_scale(10));
        }else{
            make.top.mas_equalTo(_bgView.mas_bottom).mas_equalTo(hua_scale(10));
        }
        
        
    }];
    UIView *lastView1 = nil;
    
    for (int i=0; i<9; i++) {
        UIView *view1 = [UIView new];
        view1.backgroundColor = HUAColor(0xe1e1e1);
        view1.userInteractionEnabled = YES;
        [bgView addSubview:view1];
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(hua_scale(1));
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-10));
            if (i==0) {
                make.top.mas_equalTo(0);
            }else if (i==1){
                make.top.mas_equalTo(lastView1.mas_bottom).mas_equalTo(hua_scale(25));
            }else if (i==8){
                make.bottom.mas_equalTo(0);
                
            }else{
                make.top.mas_equalTo(lastView1.mas_bottom).mas_equalTo(hua_scale(33-1));
            }
        }];
        if (i>=0&&i<=2) {
            UILabel *label = [UILabel labelText:titleArray[i] color:nil font:hua_scale(12)];
            [bgView addSubview:label];
            [label sizeToFit];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(hua_scale(hua_scale(25.0/2.0-10.0/2.0)-2));
                make.left.mas_equalTo(hua_scale(78*i)+(hua_scale(78.0/2.0-label.width/2.0))+hua_scale(73));
            }];
            
            
            // NSLog(@"%f",label.width);
        }
        lastView1 = view1;
    }
    UIView *lastView2 = nil;
    for (int i=0; i<5; i++) {
        UIView *view1 = [UIView new];
        view1.backgroundColor = HUAColor(0xe1e1e1);
        [bgView addSubview:view1];
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(hua_scale(1));
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            
            if (i==0) {
                make.left.mas_equalTo(0);
            }else if (i==1){
                make.left.mas_equalTo(lastView2.mas_right).mas_equalTo(hua_scale(67));
            }else if (i==4)
            {
                make.right.mas_equalTo(0);
            }else{
                make.left.mas_equalTo(lastView2.mas_right).mas_equalTo(hua_scale(78));
            }
        }];
        lastView2 = view1;
    }
    
    
    _lastTbaleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _lastTbaleView.backgroundColor = [UIColor clearColor];
    _lastTbaleView.delegate = self;
    _lastTbaleView.dataSource = self;
    _lastTbaleView.scrollEnabled = NO;
    _lastTbaleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [bgView addSubview:_lastTbaleView];
    
    [_lastTbaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hua_scale(25));
        make.left.bottom.right.mas_equalTo(0);
        
    }];
    
    [self.dateArray removeAllObjects];
    [self getDate:_page];
    [_lastTbaleView reloadData];
    
    _page+=7;
    _lastView = bgView;
    
    [_loadingButton sd_resetLayout];
    _loadingButton.sd_layout
    .topSpaceToView(bgView,hua_scale(10))
    .leftEqualToView(bgView)
    .heightIs(hua_scale(30))
    .widthIs(hua_scale(300));
    [self.scrollView setupAutoContentSizeWithBottomView:_loadingButton bottomMargin:10];
}

- (void)click:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    [self addTbaleView];
    
}
#pragma mark --------------------UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    
    if (tableView == self.tableView || tableView == _lastTbaleView) {
        return self.dateArray.count;
    }else if (tableView == self.serviceTableView){
        
        return self.model.serviceArray.count;
        
    }else {
        return _appointmentTime.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //  static NSString *cellStr = @"cell";
    HUAMakeAnAppointmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[HUAMakeAnAppointmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.range_list = self.model.about_arrange[@"item"][@"range_list"][indexPath.row];
    if (tableView == self.tableView) {
        
        cell.typeDic = _dic;
        cell.dateDic = self.dateArray[indexPath.row];
    }else if (tableView == self.lastTbaleView){
        cell.dateDic = self.dateArray[indexPath.row];
        
    }else if (tableView == self.serviceTableView){
        
        UITableViewCell *serviceCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UIButton *serviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [serviceButton setTitle:self.model.serviceArray[indexPath.row] forState:0];
        [serviceButton setTitleColor:HUAColor(0x333333) forState:0];
        [serviceButton setTitleColor:HUAColor(0x4da800) forState:UIControlStateSelected];
        serviceButton.contentHorizontalAlignment = 1;
        serviceButton.tag = 1100+indexPath.row;
        [serviceButton addTarget:self action:@selector(slecteService:) forControlEvents:UIControlEventTouchUpInside];
        serviceButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
        [serviceCell.contentView addSubview:serviceButton];
        [serviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(hua_scale(15));
        }];
        //记录上次选择的项目
        if (_selecteSender.tag==1100+indexPath.row) {
            serviceButton.selected = YES;
        }
        
        
        UIImageView *gouimage = [UIImageView new];
        gouimage.hidden = YES;
        gouimage.tag = 1200+indexPath.row;
        gouimage.image = [UIImage imageNamed:@"selecttime"];
        [serviceButton addSubview:gouimage];
        [gouimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(hua_scale(-15));
            make.size.mas_equalTo(CGSizeMake(hua_scale(14), 10));
            make.centerY.mas_equalTo(0);
        }];
        //记录上次选择的项目
        if (_selecteImageView.tag==1200+indexPath.row) {
            gouimage.hidden = NO;
        }
        
        return serviceCell;
        
    }else {
        
        UITableViewCell *timeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [timeButton setTitle:_appointmentTime[indexPath.row] forState:0];
        [timeButton setTitleColor:HUAColor(0x333333) forState:0];
        [timeButton setTitleColor:HUAColor(0x4da800) forState:UIControlStateSelected];
        timeButton.tag = 800+indexPath.row;
        [timeButton addTarget:self action:@selector(slecteTime:) forControlEvents:UIControlEventTouchUpInside];
        timeButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
        [timeCell.contentView addSubview:timeButton];
        [timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        UIImageView *gouimage = [UIImageView new];
        gouimage.hidden = YES;
        gouimage.tag = 900+indexPath.row;
        gouimage.image = [UIImage imageNamed:@"selecttime"];
        [timeButton addSubview:gouimage];
        [gouimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(hua_scale(60));
            make.size.mas_equalTo(CGSizeMake(hua_scale(14), 10));
            make.centerY.mas_equalTo(0);
        }];
        
        return timeCell;
        
    }
    
    
    //选择时间
    [cell setButtonBlock:^(UIButton *sender,NSString *range_type_id) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSString *url = [HUA_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"master/master_appointment?master_id=%@&range_type_id=%@",self.master_id,range_type_id]];
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSLog(@"%@",dic);
            _appointmentTime = dic[@"info"][@"range_type"][@"time_list"];
            
            _transparentView = [[HATransparentView alloc] init];
            _transparentView.delegate = self;
            _transparentView.tapBackgroundToClose = YES;
            _transparentView.hideCloseButton = YES;
            _transparentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
            [_transparentView open];
            
            [self showTimeView];
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            HUALog(@"%@",error);
        }];
    }];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView || tableView == _lastTbaleView) {
        return hua_scale(33);
    }else if (tableView == self.serviceTableView){
        return (hua_scale(39));
        
    }else{
        return hua_scale(30);
    }
    
}

//弹框
- (void)showTimeView{
    //选择时间背景
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.backgroundColor = [UIColor whiteColor];
    bgImageView.clipsToBounds = YES;
    bgImageView.layer.borderWidth =1;
    bgImageView.layer.borderColor = [UIColor clearColor].CGColor;//设置边框颜色
    bgImageView.layer.cornerRadius =3.f;
    [_transparentView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(hua_scale(290), hua_scale(270)));
        make.centerX.mas_equalTo(0);
    }];
    
    
    UIView *headView = [UIView new];
    headView.backgroundColor = HUAColor(0xd2d2d2);
    headView.userInteractionEnabled = YES;
    [bgImageView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(0);
        make.height.mas_equalTo(hua_scale(30));
    }];
    
    UILabel *title = [UILabel labelText:@"选择时间段" color:HUAColor(0x333333) font:hua_scale(11)];
    [headView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(hua_scale(15));
    }];
    [title setSingleLineAutoResizeWithMaxWidth:200];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setTitle:@"取消" forState:0];
    //clearButton.backgroundColor = [UIColor redColor];
    clearButton.tag = 340;
    clearButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [clearButton setTitleColor:HUAColor(0x888888) forState:0];
    [clearButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
    [headView addSubview:clearButton];
    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(hua_scale(-15));
        make.size.mas_equalTo(CGSizeMake(hua_scale(30), hua_scale(15)));
    }];
    
    UIButton *anyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [anyButton setTitle:@"任意时间" forState:0];
    anyButton.clipsToBounds = YES;
    anyButton.layer.borderWidth =1;
    anyButton.layer.borderColor = HUAColor(0x4da800).CGColor;//设置边框颜色
    anyButton.layer.cornerRadius =3.f;
    anyButton.backgroundColor = [UIColor whiteColor];
    anyButton.tag = 341;
    [anyButton setTitleColor:HUAColor(0x4da800) forState:0];
    [anyButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    anyButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(14)];
    [bgImageView addSubview:anyButton];
    [anyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(hua_scale(-11));
        make.left.mas_equalTo(hua_scale(10));
        make.size.mas_equalTo(CGSizeMake(hua_scale(130), hua_scale(35)));
    }];
    
    UIButton *determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [determineButton setTitle:@"确定" forState:0];
    determineButton.clipsToBounds = YES;
    determineButton.layer.borderWidth =1;
    determineButton.layer.borderColor = HUAColor(0x4da800).CGColor;//设置边框颜色
    determineButton.layer.cornerRadius =3.f;
    determineButton.backgroundColor = HUAColor(0x4da800);
    determineButton.tag = 342;
    [determineButton setTitleColor:HUAColor(0xffffff) forState:0];
    determineButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(14)];
    [determineButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:determineButton];
    [determineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(hua_scale(-11));
        make.right.mas_equalTo(hua_scale(-10));
        make.size.mas_equalTo(CGSizeMake(hua_scale(130), hua_scale(35)));
    }];
    
    UITableView *timeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    timeTableView.scrollEnabled = NO;
    timeTableView.delegate = self;
    timeTableView.dataSource = self;
    [bgImageView addSubview:timeTableView];
    [timeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom).mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(determineButton.mas_top).mas_equalTo(hua_scale(-11));
    }];
    // self.timeTableView = timeTableView;
    
}
//取消弹窗button事件
- (void)clear:(UIButton *)sender{
    NSLog(@"sss");
    if (sender.tag == 340) {
        //取消
        [_transparentView close];
        //清除上次选择的时间
        _selecteTimeButton = nil;
    }else if (sender.tag == 342){
        //确定
        if (_selecteTimeButton!=nil) {
            UIButton *button1 = [self.view viewWithTag:155];
            if (![button1.titleLabel.text isEqualToString:@"-- 请选择 --"]) {
                [UIView animateWithDuration:0.5 animations:^{
                    [_transparentView close];
                    
                } completion:^(BOOL finished) {
                    HUATechniciansOrdersViewController *vc = [HUATechniciansOrdersViewController new];
                    //项目
                    vc.projectType = button1.titleLabel.text;
                    //名字
                    vc.technicianName = self.model.masterName;
                    //金额
                    vc.moneyNumber = @"45";
                    // vc.model = self.model;
                    NSLog(@"时间%@",_selecteTimeButton.titleLabel.text);
                    if ([[self.membersInformation[@"info"]class] isSubclassOfClass:[NSString class]]) {
                        //不是会员
                        vc.showType = NO;
                    }else{
                        //是会员
                        vc.showType = YES;
                        vc.membersName = self.membersInformation[@"info"][@"nickname"];
                        vc.membersType = self.membersInformation[@"info"][@"level"];
                        vc.membersMoney = self.membersInformation[@"info"][@"money"];
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                    //清除上次选择的时间
                    _selecteTimeButton = nil;
                    
                }];
            }else{
                
                //项目为空，提示框
                [HUAMBProgress MBProgressFromView:_transparentView wrongLabelText:@"请选择一个项目"];
            }
        }else{
            //请选择时间，提示框
            [HUAMBProgress MBProgressFromView:_transparentView wrongLabelText:@"请选择时间"];
        }
    }else{
        //任意时间
    }
}
//选中要预约的时间
UIButton *selectButtonn =nil;
UIImageView *lastImagee = nil;
- (void)slecteTime:(UIButton *)sender{
    UIImageView *imageView = [sender viewWithTag:sender.tag+100];
    
    if (selectButtonn!=sender) {
        sender.selected = YES;
        selectButtonn.selected = NO;
        
        imageView.hidden = NO;
        lastImagee.hidden = YES;
    }else{
        sender.selected = YES;
        imageView.hidden = NO;
    }
    
    lastImagee = imageView;
    selectButtonn = sender;
    _selecteTimeButton = sender;
}
//选择项目按钮
- (void)serviceButton:(UIButton *)sender{
    sender.selected = YES;
    UIButton *button = [self.view viewWithTag:155];
    if (sender.tag == 155) {
        
        _transparentView = [[HATransparentView alloc] init];
        _transparentView.delegate = self;
        _transparentView.tapBackgroundToClose = YES;
        _transparentView.hideCloseButton = YES;
        _transparentView.backgroundColor = HUAColor(0xb2b2b2);
        [_transparentView open];
        [self initServiceTableView];
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _tanBgview.top = self.view.height-_tanBgview.height+64;
        }];
        
    }else{
        //回到原位
        button.selected = NO;
        [UIView animateWithDuration:0.5 animations:^{
            
            _tanBgview.top = self.view.bottom;
        } completion:^(BOOL finished) {
            [_transparentView close];
            
        }];
        
    }
}

//服务选定
UIButton *selectServiceButtonn =nil;
UIImageView *ServiceImagee = nil;
- (void)slecteService:(UIButton *)sender{
    UIImageView *imageView = [sender viewWithTag:sender.tag+100];
    UIButton *button = [self.view viewWithTag:155];
    if (selectServiceButtonn!=sender) {
        sender.selected = YES;
        selectServiceButtonn.selected = NO;
        
        imageView.hidden = NO;
        ServiceImagee.hidden = YES;
    }else{
        sender.selected = YES;
        imageView.hidden = NO;
    }
    _selecteImageView = imageView;
    _selecteSender = sender;
    ServiceImagee = imageView;
    selectServiceButtonn = sender;
    [button setTitle:sender.titleLabel.text forState:0];
    
    //回到原位
    button.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        
        _tanBgview.top = self.view.bottom;
    } completion:^(BOOL finished) {
        [_transparentView close];
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)HATransparentViewDidClosed
{
    NSLog(@"Did close");
}

@end
