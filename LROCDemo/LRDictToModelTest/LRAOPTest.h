//
//  LRAOPTest.h
//  LROCDemo
//
//  Created by dalizi on 2019/1/10.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRAOPTest : NSObject

@property (nonatomic,copy)   NSString *name;
@property (nonatomic,copy)   NSString *age;
@property (nonatomic,strong) NSArray  *list;
+ (instancetype)modelWithDict:(NSDictionary *)dic;

@end
