//
//  LRApiNull.h
//  LROCDemo
//
//  Created by dalizi on 2018/12/24.
//  Copyright © 2018年 dalizi. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 方法1：自己对接口返回的数据在接收到的时候，进行一层过滤，替换NULL
 * 方法2：用JSONModel，可以设置参数的类型为optional，这样就不会用的时候NULL造成crash
 * 方法3：AFNetworking，可以设置不返回API中value为NULL的数据
         manager.responseSerializer = [AFJSONResponseSerializer serializer];
         ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
 * 方法4：最笨的，使用字段的时候自己判空处理
 */

@interface LRApiNull : NSObject

@end
