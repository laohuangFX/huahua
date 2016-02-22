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
//活动商品数组
@property (nonatomic, strong) NSMutableArray *goodsArray;
//分页数
@property (nonatomic, assign) NSInteger page;
//总页数
@property (nonatomic, strong) NSNumber *totalPage;
/**总数量*/
@property (nonatomic, assign) NSString *totalCount;

@end

@implementation HUAActivityController

static NSString * const reuseIdentifier = @"goods";

- (NSMutableArray *)goodsArray {
    if (!_goodsArray) {
        _goodsArray = [[NSMutableArray alloc]init];;
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
    self.page = 1;
    //设置导航栏
    [self setNavigationBar];
    //请求数据
    [self getData];
    //下拉刷新数据
    [self setupDownRefresh];
}
#pragma mark -- 下拉刷新数据
- (void)setupDownRefresh {
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}

- (void)loadNewData {
    self.page = 1;
    [self.goodsArray removeAllObjects];
    NSString *url = [HUA_URL stringByAppendingPathComponent:Active_list];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"per_page"] = @(self.page);
    [HUAHttpTool GET:url params:parameter success:^(id responseObject) {
        NSString *newCount = responseObject[@"info"][@"total"];
        if (newCount == self.totalCount) {
            [HUAMBProgress MBProgressOnlywithLabelText:@"没有更多新的活动了"];
        }
        NSArray *array = [HUADataTool activity:responseObject];
        [self.goodsArray addObjectsFromArray:array];
        HUALog(@"123%@",self.goodsArray);
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        self.page--;
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
        HUALog(@"%@",error);
        [self.collectionView.mj_header endRefreshing];
    }];

}

#pragma mark -- 上拉自动加载数据

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //到达最后一页数据
    if (indexPath.row == self.goodsArray.count-1) {
        // 自动上啦刷新
        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }else {
        if (indexPath.row == self.goodsArray.count-1) {
        // 自动上啦刷新
            [self loadMoreData];
        }
    }
}



- (void)loadMoreData {
    self.page++;
    if (self.page > [self.totalPage integerValue]) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    NSString *url = [HUA_URL stringByAppendingPathComponent:Active_list];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"per_page"] = @(self.page);
    [HUAHttpTool GET:url params:parameter success:^(id responseObject) {
        NSArray *array = [HUADataTool activity:responseObject];
        [self.goodsArray addObjectsFromArray:array];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        self.page--;
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
        HUALog(@"%@",error);
    }];


}


#pragma mark -- 数据
- (void)getData {
   
    NSString *url = [HUA_URL stringByAppendingPathComponent:Active_list];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"per_page"] = @(self.page);
    [HUAHttpTool GET:url params:parameter success:^(id responseObject) {
        HUALog(@"%@",responseObject);
        self.totalPage = responseObject[@"info"][@"pages"];
        self.totalCount = responseObject[@"info"][@"total"];
         NSArray *array = [HUADataTool activity:responseObject];
        [self.goodsArray addObjectsFromArray:array];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [HUAMBProgress MBProgressFromWindowWithLabelText:@"请检查网络设置"];
        HUALog(@"%@",error);
    }];
}


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
