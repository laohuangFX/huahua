//
//  HUATechnicianViewController.m
//  Flower
//
//  Created by apple on 16/1/16.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUATechnicianViewController.h"
#import "HUATechnicianTableViewCell.h"
#import "HUAServiceDateViewController.h"

@interface HUATechnicianViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_modelArray;
    
}
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic, strong)NSArray *array;

//记录当前选择的cell的button
@property (nonatomic, strong)UIButton *seleteBuuton;

@end

@implementation HUATechnicianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择技师";
    //解析传进来的数据
    [self jsonData];
    
    [self initTbaleView];
    [self initFootView];
}

- (void)jsonData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    NSString *url = [HUA_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"service/select_master?service_id=%@",self.service_id]];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        self.array = [HUADataTool TechnicianJson:responseObject];
        NSLog(@"%ld",self.array.count);
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
    
}

- (void)initTbaleView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(hua_scale(-50));
    }];
    
}

- (void)initFootView{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = HUAColor(0xf7f7f7);
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    
    UIButton *arbitrarilyBuuton = [UIButton buttonWithType:UIButtonTypeCustom];
    [arbitrarilyBuuton setTitle:@"任意技师" forState:0];
    arbitrarilyBuuton.backgroundColor = [UIColor whiteColor];
    [arbitrarilyBuuton setTitleColor:HUAColor(0x333333) forState:0];
    arbitrarilyBuuton.titleLabel.font =  [UIFont systemFontOfSize:hua_scale(12)];
    [arbitrarilyBuuton addTarget:self action:@selector(arbitrarilyButton:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:arbitrarilyBuuton];
    [arbitrarilyBuuton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(hua_scale(10));
        make.size.mas_equalTo(CGSizeMake(hua_scale(145), hua_scale(34)));
        
    }];
    
    UIButton *confirmationBuuton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmationBuuton setTitle:@"确认" forState:0];
    [confirmationBuuton setTitleColor:[UIColor whiteColor] forState:0];
    confirmationBuuton.backgroundColor = HUAColor(0x4da800);
    confirmationBuuton.titleLabel.font =  [UIFont systemFontOfSize:hua_scale(12)];
    [confirmationBuuton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:confirmationBuuton];
    [confirmationBuuton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(arbitrarilyBuuton.mas_right).mas_equalTo(hua_scale(10));;
        make.size.mas_equalTo(CGSizeMake(hua_scale(145), hua_scale(34)));
    }];
}
//随机按钮
HUATechnicianTableViewCell *laCell = nil;
- (void)arbitrarilyButton:(UIButton *)sender{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    NSString *url = [HUA_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"service/rand_master?service_id=%@",self.service_id]];
    //NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        _seleteBuuton.selected = NO;
        
        NSInteger index = 0;
        for (int i=0; i<self.array.count; i++) {
            HUATechnicianModel *model = self.array[i];
            if ([model.master_id isEqualToString:responseObject[@"info"][@"master_id"]]) {
                index = i;
                
                break;
            }
        }
        
        HUATechnicianTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        _seleteBuuton = cell.seletebutton;
        if (laCell!=cell) {
            
            cell.seletebutton.selected = YES;
            laCell.seletebutton.selected = NO;
            
        }else{
            
            cell.seletebutton.selected = YES;
        }
        
        laCell = cell;
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
    
}
//确认按钮
- (void)confirmClick:(UIButton *)sender{
    
    if (_seleteBuuton.selected == YES) {
        NSLog(@"%ld",_seleteBuuton.tag);
        //跳转到选择日期
        HUAServiceDateViewController *vc = [HUAServiceDateViewController new];
        vc.category = self.category;
        vc.model = self.array[_seleteBuuton.tag-200];
        vc.shop_id = self.shop_id;
        
        [self.navigationController pushViewController:vc animated:YES];
        NSLog(@"跳转成功");
    }else{
        [HUAMBProgress MBProgressFromView:self.view wrongLabelText:@"请选择一个技师"];
    }
}


#pragma mark -------- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return self.array.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellStr = @"cell";
    
    HUATechnicianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell  =[[HUATechnicianTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.seletebutton.tag = 200+indexPath.row;
    //记录选中的buuton；
    [cell setButtonBlock:^(UIButton *button){
        if (laCell.seletebutton==button) {
            button.selected = YES;
        }else{
            laCell.seletebutton.selected = NO;
            _seleteBuuton.selected = NO;
        }
        
        _seleteBuuton = button;
        NSLog(@"%ld",_seleteBuuton.tag);
        laCell = nil;
    }];
    cell.model = self.array[indexPath.row];
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return hua_scale(80);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HUATechnicianTableViewCell *Cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (_seleteBuuton!=Cell.seletebutton) {
        Cell.seletebutton.selected = YES;
        _seleteBuuton.selected = NO;
    }else{
        Cell.seletebutton.selected = YES;
    }
    
    _seleteBuuton = Cell.seletebutton;
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
