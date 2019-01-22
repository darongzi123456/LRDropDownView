//
//  LRMessageForwardDevelop.m
//  LROCDemo
//
//  Created by dalizi on 2018/12/24.
//  Copyright © 2018年 dalizi. All rights reserved.
//

#import "LRMessageForwardDevelop.h"

@implementation LRMessageForwardDevelop

- (instancetype)init:(NSString *)name {
    self = [super init:name];
    if (self) {
        
    }
    return self;
}

- (void)developCoding {
    NSLog(@"class:%@,sel:%s",self,sel_getName(_cmd));
    NSLog(@"i hate ...");
}

- (void)developDebug {
    NSLog(@"class:%@,sel:%s",self,sel_getName(_cmd));
    NSLog(@"i hate bug");
}

@end
