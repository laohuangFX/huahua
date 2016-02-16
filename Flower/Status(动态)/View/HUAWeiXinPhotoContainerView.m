//
//  HUAWeiXinPhotoContainerView.m
//  Flower
//
//  Created by apple on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAWeiXinPhotoContainerView.h"
@interface HUAWeiXinPhotoContainerView () <SDPhotoBrowserDelegate>

@end

@implementation HUAWeiXinPhotoContainerView
- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray
{
    _picPathStringsArray = picPathStringsArray;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (_picPathStringsArray.count == 0) {
        self.height = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
    CGFloat itemH = 0;
    if (_picPathStringsArray.count == 1) {
        UIImageView *image = [UIImageView new];
        [image sd_setImageWithURL:[NSURL URLWithString:_picPathStringsArray.firstObject] placeholderImage:nil];

        image.frame = CGRectMake(0, 0, 10, 10);
        if (image.size.width) {
            itemH = image.size.height / image.size.width * itemW;
        }
    } else {
        itemH = itemW;
    }
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    //图片之间的间距
    CGFloat margin = hua_scale(5);
    
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [UIImageView new];
        //imageView.backgroundColor = [UIColor redColor];
        imageView.image = [UIImage imageNamed:obj];
        for (int i = 0; i<_picPathStringsArray.count; i++) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:_picPathStringsArray[i]] placeholderImage:nil];
        }
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
        [self addSubview:imageView];
        
        imageView.userInteractionEnabled = YES;
        imageView.tag = idx;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width = w;
    self.height = h;
    
    self.fixedHeight = @(h);
    self.fixedWith = @(w);
}

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    //结束编辑
    if (self.endEdit!=nil) {
           self.endEdit();
    }
 
    
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.picPathStringsArray.count;
    browser.delegate = self;
    [browser show];
}
//设置图片的宽
- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        return hua_scale(171);
    } else {
        return hua_scale(68);
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count < 3) {
        return array.count;
    } else if (array.count <= 4) {
        return 3;
    } else {
        return 3;
    }
}
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = self.picPathStringsArray[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}

//自定义动态详情页评论标题的头部视图
+ (UIView *)initCommentsView{
   
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0)];
    //view.backgroundColor = [UIColor redColor];
    
    UIView *xView = [[UIView alloc] init];
    xView.backgroundColor = [UIColor greenColor];
    [view addSubview:xView];
    
    [xView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(2*bili, 12*bili));
        make.left.mas_equalTo(5*bili);
        make.top.mas_equalTo(view);
    }];
    
    UILabel *lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:12];
    lable.textColor = HUAColor(0x808080);
    lable.text = @"评论";
    [view addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(xView.mas_right).mas_equalTo(5*bili);
        make.top.bottom.mas_equalTo(xView);
        make.width.mas_equalTo(30*bili);
    }];
    
    UIView *xxView = [UIView new];
    xxView.backgroundColor = HUAColor(0xededed);
    [view addSubview:xxView];
    [xxView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(lable);
        make.left.mas_equalTo(lable.mas_right).mas_equalTo(0);
        make.right.mas_equalTo(view);
        make.height.mas_equalTo(1);
        
    }];
    return view;
}


@end
