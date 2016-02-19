//
//  HUAStatusModel.m
//  Flower
//
//  Created by apple on 16/1/10.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUAStatusModel.h"



@implementation HUAStatusModel


- (void)encodeWithCoder:(NSCoder *)aCoder {
 
    [aCoder encodeObject:self.name forKey:@"nameKey"];
    [aCoder encodeObject:self.essay_id forKey:@"essay_idKey"];
    [aCoder encodeObject:self.content forKey:@"contentKey"];
    [aCoder encodeObject:self.time forKey:@"timeKey"];
    [aCoder encodeObject:self.praise forKey:@"praise"];
    [aCoder encodeObject:self.icon forKey:@"iconKey"];
    [aCoder encodeObject:self.comment forKey:@"commentKey"];
    [aCoder encodeObject:self.is_praise forKey:@"is_praiseKey"];
    [aCoder encodeObject:self.imageArray forKey:@"imageKey"];

}
//对类中的属性进行解码操作的触发方法
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        //解码操作
       
        self.name = [aDecoder decodeObjectForKey:@"nameKey"];
        self.essay_id = [aDecoder decodeObjectForKey:@"essay_idKey"];
         self.content = [aDecoder decodeObjectForKey:@"contentKey"];
         self.time = [aDecoder decodeObjectForKey:@"timeKey"];
         self.praise = [aDecoder decodeObjectForKey:@"praise"];
         self.icon = [aDecoder decodeObjectForKey:@"iconKey"];
         self.comment = [aDecoder decodeObjectForKey:@"commentKey"];
         self.is_praise = [aDecoder decodeObjectForKey:@"is_praiseKey"];
         self.imageArray = [aDecoder decodeObjectForKey:@"imageKey"];

        }
    return  self;
}

@end
