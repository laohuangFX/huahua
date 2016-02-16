//
//  HUAChooseAddressViewController.m
//  Flower
//
//  Created by apple on 16/2/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAChooseAddressViewController.h"
#import "HUAAddReceivingViewController.h"
#import "HUAChooseAddressTableViewCell.h"

@interface HUAChooseAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *ReceivingArrar;
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation HUAChooseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收货地址";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:HUAColor(0x494949) forState:0];
    [button setTitle:@"新增" forState:0];
    [button addTarget:self action:@selector(address) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, hua_scale(30), hua_scale(30));
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self getData];
    
}
- (void)getData{
    
    NSString *strURL = @"user/shopping_addr";
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    NSString *url = [HUA_URL stringByAppendingPathComponent:strURL];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        // NSLog(@"%@",responseObject);
        self.ReceivingArrar = [[HUADataTool addressJson:responseObject] mutableCopy];
        
        [self setTableView];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
}

- (void)setTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];


}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return self.ReceivingArrar.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HUAAddressModel *model = self.ReceivingArrar[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",model.name,model.phone];
    cell.detailTextLabel.text =model.address;
    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hua_scale(15));
        make.left.mas_equalTo(hua_scale(15));
    }];
    [cell.textLabel setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];
    
    [cell.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell.textLabel.mas_bottom).mas_equalTo(hua_scale(10.5));
        make.left.mas_equalTo(hua_scale(15));
    }];
    [cell.detailTextLabel setSingleLineAutoResizeWithMaxWidth:hua_scale(200)];

    
    cell.textLabel.font = [UIFont systemFontOfSize:hua_scale(13)];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:hua_scale(11)];
    cell.detailTextLabel.textColor = HUAColor(0x888888);

    //选择地址
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1000+indexPath.row;
    [button setBackgroundImage:[UIImage imageNamed:@"do_not_select"] forState:0];
    [button setBackgroundImage:[UIImage imageNamed:@"chooseButton_yes"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(selectAddress:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(hua_scale(-20));
        make.size.mas_equalTo(CGSizeMake(hua_scale(18), hua_scale(18)));
    }];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return hua_scale(60);
}

//选择地址
UIButton *button = nil;
- (void)selectAddress:(UIButton *)sender{
    
    if (button!=sender) {
        sender.selected = YES;
        button.selected = NO;
    }else{
        sender.selected = YES;
    }
    self.modelBlock(self.ReceivingArrar[sender.tag-1000]);
    
    button = sender;
}

//新增地址
- (void)address{

    HUAAddReceivingViewController *vc = [HUAAddReceivingViewController new];
    [self.navigationController pushViewController:vc animated:YES];

    //调用回调block
    vc.inFoBlock = ^(NSArray *InFotext){
        [self getData];
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
