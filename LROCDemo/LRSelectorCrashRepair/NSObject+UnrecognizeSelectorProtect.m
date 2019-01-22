//
//  NSObject+UnrecognizeSelectorProtect.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/16.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "NSObject+UnrecognizeSelectorProtect.h"
#import "LRForwardingTargetObject.h"
#import <objc/runtime.h>

static BOOL UnrecognizeSelectorProtectEnable = NO;

/*
 * 方法调用的本质是发消息
 * 系统调用objc_msgSend给对象发消息
 * step1:在消息接收者所属的类中搜寻其方法列表
         如果找到与selector相匹配的方法，就实现selector完成该消息传递
         如果第一步没有在消息接收者所属的类方法列表中搜寻到与selector相匹配的方法
         就去父类中继续查找，如果最终一直无法找到匹配的方法，那么进行第二步消息转发
 * step2:简称学会甩锅，把消息抛给其他对象去执行，如果能找到消息备用者，就完成消息转发
         如果找不到消息备用者，就进行第三步
 * step3:既不能动态生成实现，也找不到备用者的话，就把消息上报给NSInvocation，由Invocation处理
 * 如果三种补救措施都没有预防到，就会产生NSInvalidArgumentException异常
 */

@implementation NSObject (UnrecognizeSelectorProtect)

+ (void)setUnrecognizeSelectorProtectEnable:(BOOL)enable {
    if (enable) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self lr_swizzleMethod:@selector(forwardingTargetForSelector:) withSel:@selector(lr_forwardingTargetForSelector:) error:nil];
        });
    }
    UnrecognizeSelectorProtectEnable = enable;
}

+ (BOOL)lr_swizzleMethod:(SEL)oldSEL withSel:(SEL)newSEL error:(NSError *)error {
    Method oldMethod = class_getInstanceMethod(self, oldSEL);
    if (!oldMethod) {
        return NO;
    }
    Method newMethod = class_getInstanceMethod(self, newSEL);
    if (!newMethod) {
        return NO;
    }
    class_addMethod(self,
                    oldSEL,
                    class_getMethodImplementation(self, oldSEL),
                    method_getTypeEncoding(oldMethod));
    class_addMethod(self,
                    newSEL,
                    class_getMethodImplementation(self, newSEL),
                    method_getTypeEncoding(newMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, oldSEL),
                                   class_getInstanceMethod(self, newSEL));
    return YES;
}

- (id)lr_forwardingTargetForSelector:(SEL)selector {
    if (!UnrecognizeSelectorProtectEnable) {
        return [self lr_forwardingTargetForSelector:selector];
    }
    if ([NSStringFromClass([self class]) containsString:@"_"]) {
        return [self lr_forwardingTargetForSelector:selector];
    }
    if ([self respondsToSelector:selector]) {
        return [self lr_forwardingTargetForSelector:selector];
    }
    NSLog(@"未实现的方法名：%@",NSStringFromSelector(selector));
    NSLog(@"未实现的类名：%@",NSStringFromClass([self class]));
    return [self lr_forwardingTargetObject];
}

- (LRForwardingTargetObject *)lr_forwardingTargetObject {
    static LRForwardingTargetObject *lrFordwardingTargetObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lrFordwardingTargetObject = [[LRForwardingTargetObject alloc] init];
    });
    return lrFordwardingTargetObject;
}

@end
