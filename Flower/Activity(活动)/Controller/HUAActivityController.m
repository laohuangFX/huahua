//
//  HUAActivityController.m
//  Flower
//
//  Created by 程召华 on 16/1/6.
//  Copyright © 2016年 readchen.com. All rights reserved.
//
#define Active_list @"active/active_list"
#import "HUAActivityController.h"
#import "HUAActivityGoodsCell.h"
#import "HUADetailController.h"
@interface HUAActivityController ()<UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *goodsArray;
@end

@implementation HUAActivityController

static NSString * const reuseIdentifier = @"goods";

- (NSArray *)goodsArray {
    if (!_goodsArray) {
        _goodsArray = [[NSArray alloc]init];;
    }
    return _goodsArray;
}

- (id)init {
    //设置一个collectionView的flow layout
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(305, 305);
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    return [self initWithCollectionViewLayout:layout];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];

    NSString *url = [HUA_URL stringByAppendingPathComponent:Active_list];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //HUALog(@"%@",responseObject);
        self.goodsArray = [HUADataTool activity:responseObject];
        
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
}


#pragma mark -- 数据







#pragma mark -- 导航栏按钮
- (void)setNavigationBar {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HUAActivityGoodsCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    UIImageView *logoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoIcon];

}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    HUAActivityGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.goods = self.goodsArray[indexPath.row];
    return cell;
}


#pragma mark--- dataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     HUADetailController*ac = [[HUADetailController alloc]init];
    HUAActivityGoods *goods = self.goodsArray[indexPath.row];
    ac.active_id = goods.active_id;
    ac.shop_id = goods.shop_id;
    HUALog(@"%@",ac.shop_id);
    [ac setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:ac animated:YES];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return hua_scale(10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, hua_scale(5), 0, hua_scale(5));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.row + 1) % 3 == 0 ) {
        return CGSizeMake(screenWidth-hua_scale(10), hua_scale(119));
    } else {
        return CGSizeMake((screenWidth - hua_scale(15))/2, hua_scale(119));
    }
}


@end
