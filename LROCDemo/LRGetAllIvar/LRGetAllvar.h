//
//  LRGetAllvar.h
//  LROCDemo
//
//  Created by dalizi on 2019/1/10.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRGetAllvar : NSObject
{
    /* 不生成setter和getter方法*/
    NSNumber *number;
}

@property (nonatomic,copy) NSString *interface;
- (void)getAllIvar;
- (void)getAllMethod;
- (void)invitePrivateProperty;

@end
