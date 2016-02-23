//
//  HUAMakeAnAppointmentViewController.m
//  Flower
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAServiceDateViewController.h"
#import "HUAMakeAnAppointmentTableViewCell.h"
#import "HUADate.h"
#import "HUATechniciansOrdersViewController.h"



//////////////////////////////服务技师选择日期///////////////////////////////
@interface HUAServiceDateViewController ()<UITableViewDataSource,UITableViewDelegate,HATransparentViewDelegate>{
    UILabel *_project;//项目
    UILabel *_name;//技师名字

    UIView *_bgView;
    //记录上一次视图的位置;
    UIView *_lastView;
    NSDictionary *_dic;
    NSArray *_appointmentTime;//时间
    UIButton *_selecteTimeButton;//选中的时间
    UIImageView *_selecteTimeImage;
    
    NSArray *_earlyTime;//预约时间
    NSArray *_dateArray;//预约的日期
}
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIButton *loadingButton;
@property (nonatomic, strong)UITableView *lastTbaleView;
//会员信息
@property (nonatomic, strong)NSDictionary *membersInformation;

//遮盖视图
@property (strong, nonatomic) HATransparentView *transparentView;
@end

@implementation HUAServiceDateViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择日期";
    [HUAMBProgress MBProgressFromWindowWithLabelText:@"正在加载!"];

    _lastTbaleView = nil;
    
    
       //获取数据
    [self getData];
    
    //获取会员消息
    [self membersData];
    

    //获取日期
    //[self getDate:0];
    
    [self initScrollView];
    
    
}
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

- (void)getData{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [formatter stringFromDate:date];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    NSString *url = [HUA_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"service/select_date?master_id=%@&time_str=%@",self.model.master_id,timeStr]];
    NSLog(@"%@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _dateArray = responseObject[@"info"][@"day"];
        _earlyTime = responseObject[@"info"][@"item"][@"range_list"];
        NSLog(@"%ld",_earlyTime.count);
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (void)initScrollView{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    //项目类型
    UILabel *projectLabel = [UILabel labelText:@"项目 :" color:HUAColor(0x666666) font:hua_scale(11)];
    [self.scrollView addSubview:projectLabel];
    [projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hua_scale(20));
        make.left.mas_equalTo(hua_scale(10));
    }];
    [projectLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    //项目
    _project = [UILabel labelText:self.category color:HUAColor(0x333333) font:hua_scale(11)];
    [_scrollView addSubview:_project];
    [_project mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(projectLabel.mas_right).mas_equalTo(hua_scale(5));
        make.bottom.mas_equalTo(projectLabel);
    }];
    [_project setSingleLineAutoResizeWithMaxWidth:200];
    
    //技师类型
    UILabel *technicianLabel = [UILabel new];
    technicianLabel.text = @"技师 :";
    technicianLabel.textColor = HUAColor(0x999999);
    technicianLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
    [self.scrollView addSubview:technicianLabel];
    [technicianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(projectLabel.mas_bottom).mas_equalTo(hua_scale(10));
        make.left.mas_equalTo(hua_scale(10));
    }];
    [technicianLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    //姓名
    _name = [UILabel labelText:self.model.name color:HUAColor(0x4da800) font:hua_scale(11)];
    [_scrollView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(technicianLabel.mas_right).mas_equalTo(hua_scale(5));
        make.bottom.mas_equalTo(technicianLabel);
    }];
    [_name setSingleLineAutoResizeWithMaxWidth:200];
    
    
    //线一
    UIView *thView1 = [UIView new];
    thView1.backgroundColor = HUAColor(0xcdcdcd);
    [self.scrollView addSubview:thView1];
    [thView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_name.mas_bottom).mas_equalTo(hua_scale(20));
        make.height.mas_equalTo(hua_scale(0.5));
        make.left.mas_equalTo(technicianLabel);
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(hua_scale(-10));
    }];
    
    UILabel *dateLabel = [UILabel new];
    dateLabel.text =@"选择日期";
    dateLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    [self.scrollView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thView1.mas_bottom).mas_equalTo(hua_scale(15));
        make.left.mas_equalTo(thView1);
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
    //_bgView.backgroundColor = [UIColor redColor];
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
    //redView.backgroundColor = [UIColor redColor];
    [_bgView addSubview:redView];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(hua_scale(26));
        make.height.mas_equalTo(hua_scale(65));
    }];
    
    UIView *lastView1 = nil;
    NSArray *titleArray = @[@"早班",@"中班",@"晚班"];
    
    for (int i=0; i<9; i++) {
        
        
        UIView *view1 = [UIView new];
        view1.backgroundColor = HUAColor(0xe1e1e1);
        [_bgView addSubview:view1];
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(hua_scale(0.5));
            make.left.mas_equalTo(thView1);
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
        lastView1 = view1;
        if (i>=0&&i<=2) {
            UILabel *label = [UILabel labelText:titleArray[i] color:nil font:hua_scale(12)];
            [_bgView addSubview:label];
            [label sizeToFit];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(hua_scale(25));
                make.width.mas_equalTo(hua_scale(156/2));
                make.top.mas_equalTo(1);
                make.left.mas_equalTo(hua_scale(78*i)+(hua_scale(78.0/2.0-label.width/2.0))+hua_scale(73-2));
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
            make.width.mas_equalTo(hua_scale(0.5));
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
    _loadingButton.backgroundColor = HUAColor(0xeeeeee);
    _loadingButton.tag = 190;
    [_loadingButton setTitle:@"加载更多日期..." forState:0];
    _loadingButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
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
        [bgView addSubview:view1];
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(hua_scale(0.5));
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
                make.height.mas_equalTo(hua_scale(25));
                make.width.mas_equalTo(hua_scale(156/2));
                make.top.mas_equalTo(1);
                make.left.mas_equalTo(hua_scale(78*i)+(hua_scale(78.0/2.0-label.width/2.0))+hua_scale(73-2));
            }];
        }
        lastView1 = view1;
    }
    UIView *lastView2 = nil;
    for (int i=0; i<5; i++) {
        UIView *view1 = [UIView new];
        view1.backgroundColor = HUAColor(0xe1e1e1);
        [bgView addSubview:view1];
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(hua_scale(0.5));
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
    
    [self getData];
    [_lastTbaleView reloadData];

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
        return _dateArray.count;
    }else{
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
    cell.dateDic = _dateArray[indexPath.row];
    //预约的时间
    cell.jsonType = @"1";
    cell.range_list = _earlyTime;
    
    if (tableView == self.tableView) {

        cell.typeDic = _dic;
        cell.dateDic = _dateArray[indexPath.row];
        
        
    }else if(tableView == _lastTbaleView){
        
        cell.dateDic = _dateArray[indexPath.row];
        
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        if (indexPath.row == _appointmentTime.count) {
            UIView *thView = [UIView new];
            thView.backgroundColor = HUAColor(0xe1e1e1);
            [cell.contentView addSubview:thView];
            [thView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(hua_scale(0.5));
                make.left.mas_equalTo(hua_scale(0));
                make.right.mas_equalTo(hua_scale(0));
            }];
        }else{
            UIView *thView = [UIView new];
            thView.backgroundColor = HUAColor(0xe1e1e1);
            [cell.contentView addSubview:thView];
            [thView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(hua_scale(0.5));
                make.left.mas_equalTo(hua_scale(15));
                make.right.mas_equalTo(hua_scale(-15));
            }];

        }
        
        UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        timeButton.backgroundColor = [UIColor clearColor];
        [timeButton setTitle:_appointmentTime[indexPath.row] forState:0];
        [timeButton setTitleColor:HUAColor(0x333333) forState:0];
        [timeButton setTitleColor:HUAColor(0x4da800) forState:UIControlStateSelected];
        timeButton.tag = 800+indexPath.row;
        //[timeButton setImage:[UIImage imageNamed:@"selecttime"] forState:UIControlStateSelected];
        //[timeButton setImageEdgeInsets:UIEdgeInsetsMake(0,hua_scale(200), 0, 0)];
        [timeButton addTarget:self action:@selector(slecteTime:) forControlEvents:UIControlEventTouchUpInside];
        timeButton.titleLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
        [cell.contentView addSubview:timeButton];
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
            make.size.mas_equalTo(CGSizeMake(hua_scale(14), hua_scale(14)));
            make.centerY.mas_equalTo(0);
        }];
        
        return cell;
    }
    //选择时间
    [cell setButtonBlock:^(UIButton *sender,NSString *range_type_id) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSString *url = [HUA_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"master/master_appointment?master_id=%@&range_type_id=%@",self.model.master_id,range_type_id]];
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
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
    }else{
        return hua_scale(35);
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
    headView.backgroundColor = HUAColor(0xf8f8f8);
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
    timeTableView.separatorStyle = NO;
    [bgImageView addSubview:timeTableView];
    [timeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom).mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(determineButton.mas_top).mas_equalTo(hua_scale(-11));
    }];
    
    
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
            
            [UIView animateWithDuration:0.5 animations:^{
                [_transparentView close];
                
            } completion:^(BOOL finished) {
                HUATechniciansOrdersViewController *vc = [HUATechniciansOrdersViewController new];
                //项目
                vc.projectType = self.category;
                //名字
                vc.technicianName = self.model.name;
                //金额
                vc.moneyNumber = self.model.price;
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
                
                NSLog(@"时间%@",_selecteTimeButton.titleLabel.text);
                [self.navigationController pushViewController:vc animated:YES];
                //清除上次选择的时间
                _selecteTimeButton = nil;
            }];
            
            
        }else{
            //请选择时间
            [HUAMBProgress MBProgressFromView:_transparentView wrongLabelText:@"请选择时间!"];
        }
    }else{
        //清除上一次随机的时间
        _selecteTimeImage.hidden = YES;
        _selecteTimeButton.selected = NO;
        
        //任意时间
        UIButton *timeBut = [_transparentView viewWithTag:800+(arc4random() % _appointmentTime.count)];
        UIImageView *timeImag = [_transparentView viewWithTag:900+timeBut.tag-800];
        timeBut.selected = YES;
        timeImag.hidden = NO;
        _selecteTimeImage = timeImag;
        _selecteTimeButton = timeBut;
        NSLog(@"%@",_selecteTimeButton.titleLabel.text);
    }
}
//选中要预约的时间
UIButton *selebutton =nil;
UIImageView *lastImage = nil;
- (void)slecteTime:(UIButton *)sender{
    //清除上一次随机的时间
    _selecteTimeImage.hidden = YES;
    _selecteTimeButton.selected = NO;

    
    UIImageView *imageView = [sender viewWithTag:sender.tag+100];

    if (selebutton!=sender) {
        sender.selected = YES;
        selebutton.selected = NO;
        
        imageView.hidden = NO;
        lastImage.hidden = YES;
    }else{
        sender.selected = YES;
        imageView.hidden = NO;
    }
    
    lastImage = imageView;
    selebutton = sender;
    _selecteTimeImage = imageView;
    _selecteTimeButton = sender;
    NSLog(@"%@",_selecteTimeButton.titleLabel.text);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)HATransparentViewDidClosed
{
    NSLog(@"Did close");
}

@end
