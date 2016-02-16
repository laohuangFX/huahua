//
//  HUAEditAddressViewController.m
//  Flower
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAEditAddressViewController.h"

@interface HUAEditAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)UITableView *tablewView;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIView *outView;
@property (nonatomic, strong)UIView *keyboard;
//地址label
@property (nonatomic, strong)UILabel *addressLabel;

//省市区
//省
@property (nonatomic, strong)NSString *province;
//市
@property (nonatomic, strong)NSString *city;
//区
@property (nonatomic, strong)NSString *region;

@end

@implementation HUAEditAddressViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"编辑收货地址";
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:HUAColor(0xff4447) forState:0];
    [button setTitle:@"删除" forState:0];
    //button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 30);
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self setTableView];
    [self setPickerView];
    
}
- (void)setTableView{
    
    
    self.tablewView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.tablewView.delegate = self;
    self.tablewView.dataSource = self;
    self.tablewView.scrollEnabled = NO; //设置tableview 不能滚动
    self.tablewView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tablewView];
    [self.tablewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(hua_scale(202));
    }];
    //[self.tablewView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Action:)]];
    
    //设置保存button
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    saveButton.tag = 101;
    saveButton.backgroundColor = HUAColor(0x4da800);
    [saveButton setTitle:@"保存" forState:0];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveButton setTitleColor:HUAColor(0xffffff) forState:0];
    [saveButton addTarget:self action:@selector(ActionChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(hua_scale(290), hua_scale(40)));
        make.top.mas_equalTo(self.tablewView.mas_bottom).mas_equalTo(15);
    }];
    
}
- (void)setPickerView{
    
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
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    province = [[NSArray alloc] initWithArray: provinceTmp];
   
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    
    NSString *selectedCity = [city objectAtIndex: 0];
    district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    
    picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    [picker selectRow: 0 inComponent: 0 animated: YES];
    [_keyboard addSubview: picker];
    
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(hua_scale(180));
        
    }];
    
    selectedProvince = [province objectAtIndex: 0];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *titleArray = @[@"收货人姓名",@"手机号码",@"省、市、区",@"详细地址"];
    
    static NSString *identifier  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    self.textField = [[UITextField alloc] init];
    //self.textField .clearsOnBeginEditing = YES;
    self.textField.tag = 200+indexPath.row;
    self.textField.placeholder = titleArray[indexPath.row];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.font = [UIFont fontWithName:@"Arial" size:13];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    // self.textField.background = [UIColor redColor];
    [cell.contentView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(hua_scale(15));
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
    }];
    
    
    if (indexPath.row==0) {

    self.textField.text = self.model.name;
    }else if (indexPath.row==1){
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;    
    self.textField.text = self.model.phone ;
    }else if (indexPath.row == 3){
    
        self.textField.text = self.model.address;
    }
    
    if (indexPath.row == 2) {
        self.textField.hidden = YES;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.model.province,self.model.city,self.model.region];;
        
        _addressLabel = cell.textLabel;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"select"];
        imageView.tag = 191;
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(11, 6));
            make.right.mas_equalTo(hua_scale(-25));
            make.centerY.mas_equalTo(0);
        }];
    }
  
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    //初始化
    _province = self.model.province;
    _city= self.model.city ;
    _region = self.model.region;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==3) {
        return 70;
    }
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        //移动动画
        UIImageView *imageView = [self.view viewWithTag:191];
        imageView.image = [UIImage imageNamed:@"select_green"];
        [self.view endEditing:YES];
        [self clickk];
    }
}
//移动动画
- (void)clickk{
    [UIView animateWithDuration:0.5 animations:^{
        
        _outView.hidden = NO;
        _outView.alpha = 0.3;
        
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _keyboard.frame = CGRectMake(0, self.view.height-hua_scale(200), self.view.width, hua_scale(200));
        
    }];
}


//取消按钮点击事件
- (void)click:(UIButton *)button{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除" message:@"确定删除收货地址" preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"删除"];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:13]
                  range:NSMakeRange(0, 2)];
    [hogan addAttribute:NSForegroundColorAttributeName value:HUAColor(0x6e6e6e) range:NSMakeRange(0, 2)];
    alert.view.tintColor = [UIColor blackColor];
    [alert setValue:hogan forKey:@"attributedTitle"];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //回调删除数据
        _remoerBlock(self.model.addr_id);
       
        [self.navigationController popViewControllerAnimated:YES];
        
        [alert removeFromParentViewController];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [alert removeFromParentViewController];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    //当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
    [self.view endEditing:YES];
    
    return YES;
}

- (void)ActionChange:(UIButton *)button{
    //保存按钮
    if (button.tag == 101) {
        
        UITextField *fiel = [self.view viewWithTag:200];
        UITextField *fiel2 = [self.view viewWithTag:201];
        UITextField *fiel3 = [self.view viewWithTag:203];
        
//        NSArray *array = @[@{@"name":fiel.text,@"page":fiel2.text,@"dizhi":fiel3.text}];
   

        
      NSDictionary *parameters = @{@"addr_id":self.model.addr_id,@"consignee":fiel.text,@"consignee_phone":fiel2.text,@"province":_province,@"city":_city,@"region":_region,@"address":fiel3.text};
        
        _infoBlock(parameters);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    if (button.tag == 107) {
        [UIView animateWithDuration:0.3 animations:^{
            
            _keyboard.frame = CGRectMake(0, self.view.bottom, self.view.width, 200);
            _outView.alpha = 0;
            _outView.hidden = YES;
         
            UIImageView *imageView = [self.view viewWithTag:191];
            imageView.image = [UIImage imageNamed:@"select"];
            
        }];
    }else if (button.tag == 108){
       
        UIImageView *imageView = [self.view viewWithTag:191];
        imageView.image = [UIImage imageNamed:@"select"];
        
        //点击确认改变地址cell
        NSInteger provinceIndex = [picker selectedRowInComponent: PROVINCE_COMPONENT];
        NSInteger cityIndex = [picker selectedRowInComponent: CITY_COMPONENT];
        NSInteger districtIndex = [picker selectedRowInComponent: DISTRICT_COMPONENT];
        
        NSString *provinceStr = [province objectAtIndex: provinceIndex];
        NSString *cityStr = [city objectAtIndex: cityIndex];
        NSString *districtStr = [district objectAtIndex:districtIndex];
        
        if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
            cityStr = @"";
            districtStr = @"";
        }
        else if ([cityStr isEqualToString: districtStr]) {
            districtStr = @"";
        }
        
        NSString *showMsg = [NSString stringWithFormat: @"%@ %@ %@.", provinceStr, cityStr, districtStr];
        _addressLabel.text = showMsg;
        _province = provinceStr;
        _city = cityStr;
        _region = districtStr;
        
        //回到原处
        [UIView animateWithDuration:0.3 animations:^{
            
            _keyboard.frame = CGRectMake(0, self.view.bottom, self.view.width, 200);
            _outView.alpha = 0;
            _outView.hidden = YES;
            
        }];
        
    }
}

#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province count];
    }
    else if (component == CITY_COMPONENT) {
        return [city count];
    }
    else {
        return [district count];
    }
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        return [city objectAtIndex: row];
    }
    else {
        return [district objectAtIndex: row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        selectedProvince = [province objectAtIndex: row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        

        city = [[NSArray alloc] initWithArray: array];

        
 
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [city objectAtIndex: 0]]];
        [picker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [picker reloadComponent: CITY_COMPONENT];
        [picker reloadComponent: DISTRICT_COMPONENT];
        
    }
    else if (component == CITY_COMPONENT) {
        NSString *provinceIndex = [NSString stringWithFormat: @"%ld", [province indexOfObject: selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
  
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [picker reloadComponent: DISTRICT_COMPONENT];
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return 80;
    }
    else if (component == CITY_COMPONENT) {
        return 100;
    }
    else {
        return 115;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)] ;
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView =[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)] ;
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [district objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}
#pragma mark----------------textFieldDelegate--------
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == [self.view viewWithTag:200]) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 8) {
            return NO;
        }
    }else if (textField == [self.view viewWithTag:201]){
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
        
    }
    
    return YES;
    
}
#pragma mark----------------textFieldDelegate--------

//点击View的其他区域隐藏软键盘。
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

//开始编辑UITextField时调用的代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
@end
