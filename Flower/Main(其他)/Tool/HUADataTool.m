//
//  HUADataTool.m
//  Flower
//
//  Created by 程召华 on 16/1/8.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUADataTool.h"
#import "HUAActivityGoods.h"
#import "HUADetailInfo.h"
#import "HUAStatusModel.h"
#import "HUAShopInfo.h"
#import "HUAShopIntroduce.h"
#import "HUAServiceInfo.h"
#import "HUAServiceMasterInfo.h"
#import "HUAProduct.h"
#import "HUAChooseMaster.h"
#import "HUAMasterList.h"
#import "HUAMasterDetailInfo.h"
#import "HUAMyCollection.h"
#import "HUAMyMemberCard.h"
#import "HUAProductCard.h"
#import "HUAMyOrderModel.h"
#import "HUAConsumption.h"
#import "HUATechnicianModel.h"
#import "HUAAddressModel.h"
#import "HUACategoryList.h"
#import "HUATechnicianModel.h"

@implementation HUADataTool
+ (NSArray *)getCategoryList:(NSDictionary *)dic {
    NSArray *array = dic[@"info"][@"category_list"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUACategoryList *category = [HUACategoryList categoryListWithDictionary:dic];
        [mutableArray addObject:category];
    }
    return [mutableArray copy];
}



+ (NSArray *)getConsumption:(NSDictionary *)dic {
     NSArray *array = dic[@"info"][@"list"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUAConsumption *consumption = [HUAConsumption consumptionInfoFromDictionary:dic];
        [mutableArray addObject:consumption];
    }
    return [mutableArray copy];
}




+ (NSArray *)getProductCard:(NSDictionary *)dic{
    NSArray *array = dic[@"info"][@"list"];
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    NSArray *serviceArray = nil;
    for (NSDictionary *dic in array ) {
        HUAProductCard *productCard = [HUAProductCard new];
        productCard.shopname = dic[@"shopname"];
        productCard.address = dic[@"address"];
        productCard.active_price = dic[@"active_price"];
        productCard.card_name = dic[@"card_name"];
        productCard.phone = dic[@"phone"];
        productCard.card_id = dic[@"card_id"];
        productCard.cover = dic[@"cover"];
        productCard.remain_times = dic[@"remain_times"];
        productCard.shop_id = dic[@"shop_id"];
        serviceArray = dic[@"service_scope"];
        NSMutableArray *serviceMutable = [NSMutableArray array];
        for (NSDictionary *serviceDic in serviceArray) {
            //HUAProductCard *service = [HUAProductCard serviceScope:serviceDic];
            NSString *name = serviceDic[@"name"];
            [serviceMutable addObject:name];
        }
        productCard.service_scope = serviceMutable;
        
        [mutableArray addObject:productCard];
        
    }
    
    return [mutableArray copy];
    
}



//+ (NSArray *)productCardArray:(NSDictionary *)dic {
//    NSArray *array = dic[@"info"][@"list"];
//    NSMutableArray *productMutable = [NSMutableArray array];
//    for (NSDictionary *dic in array) {
//        HUAProductCard *productCard = [HUAProductCard productCardWithDictionary:dic];
//        [productMutable addObject:productCard];
//    }
//    return [productMutable copy];
//}



+ (NSArray *)achievementArray:(NSDictionary *)dic {
    NSArray *array = dic[@"info"][@"achievement"];
    NSMutableArray *achievementArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUAMasterDetailInfo *detailInfo = [HUAMasterDetailInfo new];
        detailInfo.url = dic[@"url"];
        [achievementArray addObject:detailInfo.url];
    }
    return  [achievementArray copy];
}



+ (NSArray *)myMemberCardArray:(NSDictionary *)dic {
    NSArray *array = dic[@"info"][@"list"];
    NSMutableArray *memberCardMutable = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUAMyMemberCard *myMemberCard = [HUAMyMemberCard myMemberCardWithDictionary:dic];
        [memberCardMutable addObject:myMemberCard];
    }
    return [memberCardMutable copy];
}


+ (NSArray *)collectionArray:(NSDictionary *)dic {
    NSArray *array = dic[@"info"][@"list"];
    NSMutableArray *collectionMutable = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUAMyCollection *myCollection = [HUAMyCollection collectionInfoWithDictionary:dic];
        [collectionMutable addObject:myCollection];
    }
    return [collectionMutable copy];
}



+ (NSArray *)mienArray:(NSDictionary *)dic {
    NSArray *array = dic[@"info"][@"fengcai"];
    NSMutableArray *achievementArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUAMasterDetailInfo *detailInfo = [HUAMasterDetailInfo getMienArrayFromDictionary:dic];
        //detailInfo.url = dic[@"url"];
        [achievementArray addObject:detailInfo];
    }
    return  [achievementArray copy];
}







+ (NSArray *)getMasterList:(NSDictionary *)dic {
    NSArray *array = dic[@"info"][@"list"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUAMasterList *masterList = [HUAMasterList getMasterListWithDictionary:dic];
        [mutableArray addObject:masterList];
    }
    return  [mutableArray copy];
}




+ (NSArray *)getChooseMaster:(NSDictionary *)dic {
    NSArray *array = dic[@"info"][@"list"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUAChooseMaster *master = [HUAChooseMaster getMasterWithDictionary:dic];
        [mutableArray addObject:master];
    }
    return  [mutableArray copy];
}




+ (NSArray *)getProductArray:(NSDictionary *)dic {
    NSArray *array = dic[@"info"][@"list"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUAProduct *product = [HUAProduct getProductDataWithDictionary:dic];
        [mutableArray addObject:product];
    }
    return  [mutableArray copy];
}




+ (NSArray *)getMasterArray:(NSDictionary *)dic {
    NSArray *array = dic[@"master"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUAServiceMasterInfo *masterInfo = [HUAServiceMasterInfo getMasterInfo:dic];
        [mutableArray addObject:masterInfo];
    }
    return  [mutableArray copy];
}





+ (NSArray *)activeCover:(NSDictionary *)dic {
    NSArray *array = dic[@"info"][@"active"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSMutableArray *coverArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUAShopIntroduce *coverIntroduce = [HUAShopIntroduce new];
        coverIntroduce.active_cover = dic[@"cover"];
        [coverArray addObject:coverIntroduce.active_cover];
        coverIntroduce.coverArray = coverArray;
        [mutableArray addObject:coverIntroduce];
    }
    return  [mutableArray copy];
}


+ (NSArray *)activeID:(NSDictionary *)dic {
    NSArray *array = dic[@"info"][@"active"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSMutableArray *IDArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUAShopIntroduce *IDIntroduce = [HUAShopIntroduce new];
        IDIntroduce.active_id = dic[@"active_id"];
        [IDArray addObject:IDIntroduce.active_id];
        IDIntroduce.idArray = IDArray;
        [mutableArray addObject:IDIntroduce];
    }
    return  [mutableArray copy];
}

+ (NSArray *)homeBanner:(NSDictionary *)dic {
    NSArray *array = dic[@"info"][@"banner_list"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSMutableArray *bannerArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUAShopInfo *shopInfo = [HUAShopInfo new];
        shopInfo.banner_pic = dic[@"banner_pic"];
        [bannerArray addObject:shopInfo.banner_pic];
        shopInfo.bannerArr = bannerArray;
        [mutableArray addObject:shopInfo];
    }
    return  [mutableArray copy];
}





+ (NSArray *)homeShop:(NSDictionary *)dic {
    NSArray *array = dic[@"info"][@"list"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUAShopInfo *shopInfo = [HUAShopInfo parseHomeDataWithDictionary:dic];
        [mutableArray addObject:shopInfo];
    }
    return  [mutableArray copy];
}


+ (NSArray *)shopProduct:(NSDictionary *)dic {
    NSArray *array = dic[@"info"][@"list"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUAShopProduct *shopProduct = [HUAShopProduct parseWithDictionary:dic];
        [mutableArray addObject:shopProduct];
    }
    return  [mutableArray copy];
}


+ (NSArray *)activity:(NSDictionary *)dic {
    NSArray *array = dic[@"info"][@"list"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUAActivityGoods *goods = [HUAActivityGoods parseActivity:dic];
        
        [mutableArray addObject:goods];
    }
    return  [mutableArray copy];
}

+ (NSArray *)activityDetail:(NSDictionary *)dic {
    NSArray *array = dic[@"info"][@"detail"][@"txt_pic"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HUADetailInfo *detail = [HUADetailInfo getDetailTextAndImageWithDictionary:dic];
        [mutableArray addObject:detail];
    }
    return [mutableArray copy];
}

//动态
+ (NSMutableArray *)status:(NSDictionary *)dic{
    NSArray *_array = nil;
    if (!_array) {
        _array = [[self alloc] getStatusModel:(dic)];
    }
    return [_array mutableCopy];
}

- (NSMutableArray *)getStatusModel:(NSDictionary *)dic{
    NSArray *array = dic[@"info"][@"list"];
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    NSArray *imageArray = nil;
    for (NSDictionary *dic in array ) {
        HUAStatusModel *statusModel = [HUAStatusModel new];
        statusModel.essay_id = dic[@"essay_id"];
        statusModel.content =  dic[@"content"];
        statusModel.name = dic[@"shopname"];
        statusModel.time = dic[@"create_time"];
        statusModel.icon = dic[@"cover"];
        statusModel.praise = dic[@"praise_count"];
        statusModel.comment = dic[@"comment_count"];
        statusModel.is_praise = dic[@"is_praise"];
        imageArray = dic[@"img_list"];
        NSMutableArray *mutableImage = [NSMutableArray array];
        for (NSDictionary *imageDic in imageArray) {
            NSString * str  = imageDic[@"content"];
            [mutableImage addObject:str];
        }
        statusModel.imageArray = mutableImage;
        
        [mutableArray addObject:statusModel];
        
    }
    
    return [mutableArray mutableCopy];
    
}
//动态详情

+ (NSMutableArray *)DynamicDetails:(NSDictionary *)dic{
    
    NSArray *_array = nil;
    if (!_array) {
        _array = [[self alloc] getDynamicDetailsModel:(dic)];
    }
    return [_array mutableCopy];
    
}

- (NSMutableArray *)getDynamicDetailsModel:(NSDictionary *)dic{
   
    NSArray *array = dic[@"info"][@"comment_info"];

    NSMutableArray *mutableArray = [NSMutableArray array];
    
    for (NSDictionary *dynamicDic in array) {
        HUAmodel *model = [HUAmodel new];
        model.commentArray = [dynamicDic[@"reply"] mutableCopy];
        model.name = dynamicDic[@"comment_info"][@"nickname"];
        model.icon = dynamicDic[@"comment_info"][@"headicon"];
        model.content = dynamicDic[@"comment_info"][@"content"];
        model.user_id = dynamicDic[@"comment_info"][@"user_id"];
        model.comment_id = dynamicDic[@"comment_info"][@"comment_id"];
        model.time = dynamicDic[@"comment_info"][@"create_time"];
        [mutableArray addObject:model];
    }
    
    return [mutableArray copy];
}

//我的订单
static NSArray *_array = nil;
+ (NSArray *)MyOrder:(NSDictionary *)dic{

    if (_array==nil) {
        _array = [[self alloc] getMyOrder:dic];
    }
    return [_array copy];
}

- (NSArray *)getMyOrder:(NSDictionary *)dic{

    NSArray *array = dic[@"info"][@"list"];
    NSLog(@"%@",array);
    NSMutableArray *mutableArray = [NSMutableArray array];


    for (NSDictionary *myOrderDic in array) {
        HUAMyOrderModel *myOrder = [HUAMyOrderModel new];
        myOrder.bill_id = myOrderDic[@"bill_id"];
        myOrder.money = myOrderDic[@"money"];
        myOrder.bill_num =myOrderDic[@"bill_num"];
        myOrder.time  = myOrderDic[@"create_time"];
        myOrder.shopName = myOrderDic[@"shopname"];
        myOrder.is_use = myOrderDic[@"is_use"];
        myOrder.is_receipt = myOrderDic[@"is_receipt"];
        myOrder.product_id = myOrderDic[@"product"][@"product_id"];
        myOrder.service_id = myOrderDic[@"product"][@"service_id"];
        myOrder.type = myOrderDic[@"type"];
        myOrder.shop_id = myOrderDic[@"shop_id"];
        NSLog(@"%@",myOrder.type);
        if ([myOrderDic[@"type"] isEqualToString:@"1"]) {
            myOrder.titleNmae = myOrderDic[@"product"][@"name"];
            myOrder.icon = myOrderDic[@"product"][@"cover"];
        }else if([myOrderDic[@"type"] isEqualToString:@"2"]){
            myOrder.service_id =myOrderDic[@"service"][@"service_id"];
            myOrder.titleNmae = myOrderDic[@"service"][@"name"];
            myOrder.icon = myOrderDic[@"service"][@"cover"];
        }else{
            myOrder.active_id = myOrderDic[@"active"][@"active_id"];
            myOrder.titleNmae = myOrderDic[@"active"][@"name"];
            myOrder.icon = myOrderDic[@"active"][@"cover"];
            myOrder.remainNum = myOrderDic[@"active"][@"remain_times"];
        }
        
        [mutableArray addObject:myOrder];
    }
    
    return [mutableArray copy];
}

//技师列表
+ (NSArray *)TechnicianJson:(NSDictionary *)dic{
    NSArray *_array = nil;
    if (_array==nil) {
        _array = [[self alloc ] getTechnicianData:dic];
    }
    return [_array copy];
}

- (NSArray *)getTechnicianData:(NSDictionary *)dic{
    NSArray *array = dic[@"info"][@"list"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *tecDic in array) {
        HUATechnicianModel *model = [HUATechnicianModel new];
        model.name = tecDic[@"name"];
        model.level_name = tecDic[@"level"];
        model.icon = tecDic[@"url"];
        model.price= [NSString stringWithFormat:@"%ld.00",[tecDic[@"price"] integerValue]+[tecDic[@"fee"] integerValue]];
        model.master_id = tecDic[@"master_id"];
       
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}
//收货地址
+ (NSArray *)addressJson:(NSDictionary *)dic{
    NSArray *_array = nil;
    
    if (_array == nil) {
        _array = [[self alloc] getAddressJson:dic];
    }
    return [_array copy];
}
//收货地址
- (NSArray *)getAddressJson:(NSDictionary *)dic{

    NSArray *array = dic[@"info"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *addDic in array) {
        HUAAddressModel *model = [HUAAddressModel new];
        model.name = addDic[@"consignee"];
        model.phone = addDic[@"consignee_phone"];
        model.province = addDic[@"province"];
        model.city = addDic[@"city"];
        model.region = addDic[@"region"];
        model.address = addDic[@"address"];
        model.addr_id = addDic[@"addr_id"];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}
@end
