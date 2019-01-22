//
//  LRForwardingTargetObject.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/16.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRForwardingTargetObject.h"
#import <objc/runtime.h>

static const char *lr_types = "v@:";

@implementation LRForwardingTargetObject

void dynamicMethodIMP(id self,SEL _cmd) {
    NSLog(@"桩类 转发方法");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    BOOL hasSelector = [super resolveInstanceMethod:sel];
    if (!hasSelector) {
        hasSelector = class_addMethod(self, sel, (IMP)dynamicMethodIMP, lr_types);
    }
    return hasSelector;
}

@end
