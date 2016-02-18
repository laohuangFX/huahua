//
//  HUAProductController.m
//  Flower
//
//  Created by 程召华 on 16/1/4.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

//条件选择View的button的格式




#define chooseButtonCount 3
#import "HUAProductController.h"
#import "HUAChooseView.h"
#import "HUAProductCell.h"
#import "HUAProduct.h"
#import "HUAProductDetailController.h"
#import "EmojiBool.h"

@interface HUAProductController ()<UICollectionViewDelegateFlowLayout,JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITextFieldDelegate>{
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;

    //参数
    //左边
    NSString *_leftText;
    //左边的子类
    NSString *_leftSubText;
    //中间
    NSString *_midstText;
    //右边
    NSString *_rightText;
    
    //存放产品id
    NSMutableDictionary *_dataDic;
    //存放
    NSMutableDictionary *_towDataDic;

}
@property (nonatomic, strong) NSArray *productArray;
@property (nonatomic, strong) UITextField *searchBar;
@end

@implementation HUAProductController

static NSString * const reuseIdentifier = @"cell";


- (NSArray *)productArray {
    if (!_productArray) {
        _productArray = [NSArray array];
    }
    return _productArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.userInteractionEnabled = YES;
    self.collectionView.backgroundColor = HUAColor(0xE4E4E4);
    _dataDic = [NSMutableDictionary dictionary];
    _towDataDic = [NSMutableDictionary dictionary];
    //获取下拉菜单数据
    [self getDownData];
    //注册HUAProductCell类型的cell;并且从xib来加载
    [self.collectionView registerClass:[HUAProductCell class] forCellWithReuseIdentifier:reuseIdentifier];
    //设置collectionView的Y值，给三个button留空间
    self.collectionView.y = chooseViewHeight;
    self.collectionView.height = screenHeight-chooseViewHeight;
    //隐藏滑动条
    self.collectionView.showsVerticalScrollIndicator = NO;
   
    [self setNavigationItem];
  
    [self getDataWithparameters:nil];
    
    
}
//获取下拉菜单数据
- (void)getDownData{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSString *url = [HUA_URL stringByAppendingPathComponent:@"product/product_cat"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //parameters[@"shop_id"] = self.shop_id;
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation,NSDictionary* responseObject) {
        HUALog(@"%@",responseObject);
        [self category:responseObject];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
    
    
}
- (void)getDataWithparameters:(NSDictionary *)parameters{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    NSString *url = [HUA_URL stringByAppendingPathComponent:Product_list];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HUALog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"info"] isKindOfClass:[NSString class]]) {
            [HUAMBProgress MBProgressOnlywithLabelText:[responseObject objectForKey:@"info"]];
            return ;
        }
        self.productArray = [HUADataTool getProductArray:responseObject];
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
    
}


#pragma --设置三个选择按钮
//设置三个选择按钮
- (void)category:(NSDictionary *)titelDic{
    
    NSMutableArray *food= [NSMutableArray array];
    NSMutableArray *travel = [NSMutableArray array];
    
    //    NSArray *food = @[@"不限", @"海飞丝", @"飘柔", @"清扬", @"沙宣",@"霸王"];
    //    NSArray *travel = @[@"不限", @"蜂花护发素", @"潘婷护发素", @"沙宣护发素", @"飘柔护发素", @"欧莱雅护发素", @"百雀羚护发素", @"迪彩护发素", @"资生堂护发素", @"露华浓护发素"];
    NSArray *noLimit = @[@"不限"];
    
    _data1 = [NSMutableArray array];
    
    for (int i=0; i<[titelDic[@"info"] count]+1; i++) {
        if (i==0) {
            [_data1 addObject:@{@"title":@"不限",@"data":noLimit}];
        }else{
            NSMutableArray *array = [NSMutableArray array];
            
            for (int y = 0; y< [titelDic[@"info"][i-1][@"sub"] count]+1; y++) {
                if (y==0){
                    [array addObject:@"不限"];
                }else{
                    [array addObject:titelDic[@"info"][i-1][@"sub"][y-1][@"name"]];
                    //存放二级
                    [_towDataDic setValue:titelDic[@"info"][i-1][@"sub"][y-1][@"category_id"] forKey:titelDic[@"info"][i-1][@"sub"][y-1][@"name"]];
                }
            }
            [food addObject:titelDic[@"info"][i-1][@"name"]];
            [_data1 insertObject:@{@"title":food[i-1],@"data":array} atIndex:i];
            
        }
    }
    //存放一级
    for (NSDictionary *dic in titelDic[@"info"]) {
        [_dataDic setValue:dic[@"category_id"] forKey:dic[@"name"]];
    }
    
    NSLog(@"%@",_dataDic);
    
    
    //_data1 = [NSMutableArray arrayWithObjects:@{@"title":@"不限", @"data":noLimit},@{@"title":@"沐浴露",@"data":food}, @{@"title":@"护发素", @"data":travel}, @{@"title":@"洗面奶",@"data":food},@{@"title":@"啫喱水",@"data":travel},@{@"title":@"BB霜",@"data":food},@{@"title":@"眼霜",@"data":travel},@{@"title":@"指甲油",@"data":food},@{@"title":@"卸甲油",@"data":travel},nil];
    NSLog(@"%@",_data1);
    _data2 = [NSMutableArray arrayWithObjects:@"不限", @"价格降序", @"价格升序",nil];
    _data3 = [NSMutableArray arrayWithObjects:@"不限",@"点赞降序",@"点赞升序",nil];
    
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:hua_scale(30)];
    
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    //图标颜色
    menu.indicatorColor = HUAColor(0x4da800);
    
    menu.dataSource = self;
    menu.delegate = self;
    
    [menu setGetDataBlock:^(NSString *leftText, NSString *leftSubText, NSString *midstText, NSString *lastText) {
        

        if (leftText.length != 0) {
            _leftText = leftText;
            return ;
        }else if (leftSubText.length !=0){
            _leftSubText = leftSubText;
        }else if (midstText.length !=0){
            _midstText = midstText;
        }else if (lastText.length !=0){
            _rightText = lastText;
        }
        
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSString *url =[HUA_URL stringByAppendingPathComponent:@"product/product_list"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if (![_leftText isEqualToString:@"不限"] && _leftText != nil) {
            parameters[@"parent_id"] =_dataDic[_leftText];
        }
        if (![_leftSubText isEqualToString:@"不限"] && _leftSubText != nil) {
            parameters[@"category_id"] =_towDataDic[_leftSubText];
        }
        if (![_midstText isEqualToString:@"不限"] && _midstText != nil) {
            parameters[@"order_price"] =[_midstText isEqualToString:@"价格降序"]? @"desc":@"asc";
        }
        if (![_rightText isEqualToString:@"不限"] && _rightText != nil) {
            parameters[@"order_praise"] =[_midstText isEqualToString:@"点赞降序"]? @"desc":@"asc";
        }
        
        
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            HUALog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"info"] isKindOfClass:[NSString class]]) {
                [HUAMBProgress MBProgressOnlywithLabelText:[responseObject objectForKey:@"info"]];
                return ;
            }

            self.productArray = nil;
            self.productArray = [HUADataTool getProductArray:responseObject];
            [self.collectionView reloadData];
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            HUALog(@"%@",error);
        }];
        
        
    }];
    [self.view addSubview:menu];
    
    
}

#pragma --设置导航栏的BarButtonItem
//设置导航栏的BarButtonItem
- (void)setNavigationItem{
    //设置导航栏左边的BarButtonItem
    
    UIImageView *logoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoIcon];
    //设置导航栏右边的BarButtonItem
    UIBarButtonItem *searchBar = [UIBarButtonItem itemWithTarget:self action:@selector(search) image:@"search" highImage:@"search" text:nil];
//    UIBarButtonItem *leftSpace = [UIBarButtonItem leftSpace:hua_scale(-25)];
//    UIBarButtonItem *rightSpace = [UIBarButtonItem rightSpace:hua_scale(10)];
    self.navigationItem.rightBarButtonItems = @[searchBar];
    self.navigationItem.titleView = nil;
    self.title = @"产品";
}



- (void)setSearchNav{
    self.navigationItem.leftBarButtonItems = @[];
    
    self.searchBar.width = hua_scale(300.0);
    self.searchBar.height = hua_scale(22.5);
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar becomeFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismissBlackView)];
}
- (void)dismissBlackView{
    
    UIView *blackView = [self.view viewWithTag:1001];
    if (blackView == nil) {
        return;
    }
    [self setNavigationItem];
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    [UIView animateWithDuration:0.5 animations:^{
        blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [blackView removeFromSuperview];
    }];
}
- (void)search {
    [self setSearchNav];
    HUALog(@"...");
}


#pragma mark - textFiled delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"beginEditing");
    UIView *blackView  = [[UIView alloc]initWithFrame:self.view.bounds];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    blackView.tag = 1001;
    blackView.alpha = 0;
    [self.view addSubview:blackView];
    UITapGestureRecognizer *blackTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissBlackView)];
    [blackView addGestureRecognizer:blackTap];
    [self setSearchNav];
    [UIView animateWithDuration:0.3 animations:^{
        blackView.alpha = 1;
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return ![EmojiBool stringContainsEmoji:string];
}


//搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length == 0) {
        [self dismissBlackView];
    }else{
        //数据请求
        NSDictionary *parameters = [NSDictionary dictionaryWithObject:textField.text forKey:@"search"];
        [self getDataWithparameters:parameters];
        [self dismissBlackView];
    }
    return YES;
}
- (UITextField *)searchBar{
    if (!_searchBar) {
        _searchBar = [UITextField textFieldWithFrame:CGRectZero image:@"search" placeholder:@"搜索"];
        _searchBar.layer.masksToBounds = YES;
        _searchBar.layer.cornerRadius = hua_scale(5);
        _searchBar.backgroundColor = HUAColor(0xeeeeee);
        _searchBar.width = hua_scale(185);
        _searchBar.height = hua_scale(22.5);
        _searchBar.delegate = self;
        _searchBar.returnKeyType = UIReturnKeySearch;
    }
    return _searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.productArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HUAProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  
    cell.backgroundColor = [UIColor whiteColor];
    cell.product = self.productArray[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

        
    return CGSizeMake((screenWidth-1)/2, hua_scale(215));
    
}
//点击collectionView触发方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HUAShopProduct *product = self.productArray[indexPath.row];
    
    HUAProductDetailController *productVC = [HUAProductDetailController new];
    productVC.product_id = product.product_id;
    productVC.shop_id = product.shop_id;
    [self.navigationController pushViewController:productVC animated:YES];
    
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];

}






//菜单个数
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 3;
}

/**
 * 是否需要显示为UICollectionView 默认为否
 */
-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    //    if (column==2) {
    //
    //        return NO;
    //    }
    
    return NO;
}
/**
 * 表视图显示时，是否需要两个表显示
 */
-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    if (column==0) {
        return YES;
    }
    return NO;
}

/**
 * 表视图显示时，左边表显示比例
 */
-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==0) {
        return 0.5;
    }
    
    return 1;
}

//返回当前菜单左边表选中行
-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        
        return _currentData1Index;
        
    }
    if (column==1) {
        
        return _currentData2Index;
    }
    
    return _currentData3Index;
}
//返回菜单栏cell的个数
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        if (leftOrRight==0) {
            
            return _data1.count;
        } else{
            
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
    } else if (column==1){
        
        return _data2.count;
        
    } else if (column==2){
        
        return _data3.count;
    }
    
    return 0;
}
//初始默认菜单title
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return @"类别";//[[_data1[0] objectForKey:@"data"] objectAtIndex:0];
            break;
        case 1: return @"价格"; //_data2[0];
            break;
        case 2: return @"点赞数";//_data3[0];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_data1 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else{
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    } else if (indexPath.column==1) {
        
        return _data2[indexPath.row];
        
    } else {
        
        return _data3[indexPath.row];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        if(indexPath.leftOrRight==0){
            
            _currentData1Index = indexPath.row;
            
            return;
        }
        
    } else if(indexPath.column == 1){
        
        _currentData2Index = indexPath.row;
        
    } else{
        
        _currentData3Index = indexPath.row;
    }
}



@end
