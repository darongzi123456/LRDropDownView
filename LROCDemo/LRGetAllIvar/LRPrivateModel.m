//
//  LRPrivateModel.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/10.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRPrivateModel.h"

@interface LRPrivateModel ()
{
    NSString *_privateStr;
}
@end

@implementation LRPrivateModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _privateStr = @"大栗子";
    }
    return self;
}

@end
