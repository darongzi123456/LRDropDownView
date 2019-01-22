//
//  LRMessageForward.h
//  LROCDemo
//
//  Created by dalizi on 2018/12/24.
//  Copyright © 2018年 dalizi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRMessageForward : NSObject

@property (nonatomic,copy) NSString *name;
- (instancetype)init:(NSString *)name;
- (void)eat;
- (void)sleep;

@end
