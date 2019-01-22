//
//  LRMessageForward.m
//  LROCDemo
//
//  Created by dalizi on 2018/12/24.
//  Copyright © 2018年 dalizi. All rights reserved.
//

#import "LRMessageForward.h"
#import <objc/runtime.h>
#import "LRMessageForwardDevelop.h"

@implementation LRMessageForward

/*
 * void objc_msgSend(id self, SEL cmd,...)
 * 动态方法解析：征询接收者类是否需要动态添加方法，来处理这个找到的方法
 * 备用接收者：转发给其他的对象处理这个方法
 * 完整的消息转发机制：如果未声明其他处理对象，或者其他对象处理失败，那么系统就会把消息所有相关的封装成一个NSInvotation对象，我们可以拿到这个NSInvotation对象，addTarget指明方法的处理者
 * 
 */

- (instancetype)init:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (void)eat {
    NSLog(@"eat fish");
}

- (void)sleep {
    NSLog(@"sleep...");
}

/*************************** messageforward firstStep: 动态方法解析 **************************/
/*** 当发现不能干这个活，那么你可以现学 ***/

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selName = NSStringFromSelector(sel);
    if ([selName hasPrefix:@"develop"]) {
        class_addMethod(self, sel, (IMP)shouldDoSomething, "v@:");
        return YES;
    }
    return [super resolveClassMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    Class metaClass = object_getClass([LRMessageForwardDevelop class]);
    if ([self isKindOfClass:[metaClass class]]) {
        class_addMethod(self, sel, (IMP)shouldDoSomething, "v@:");
    }
    return YES;
}

void shouldDoSomething (id self, SEL _cmd) {
    NSLog(@"class:%@,sel:%s",self,sel_getName(_cmd));
    NSLog(@"maybe i should do something like a developer");
}

/*************************** messageforward secondStep: 备选接收者 **************************/
/*** 如果你是个懒人，不愿意现学，那怎么办呢，那学会甩锅 ***/

- (id)forwardingTargetForSelector:(SEL)aSelector {
    LRMessageForwardDevelop *develop = [[LRMessageForwardDevelop alloc] init:_name];
    if ([develop respondsToSelector:aSelector]) {
        return develop;
    }
    return [self forwardingTargetForSelector:aSelector];
}

/*************************** messageforward thirdStep: 完整的消息转发 **************************/
/*** 如果既不动态生成方法实现，也不转发给能处理的备选接收者，最后还有一个解决方案。那你写一个方法的详细报告，对组织说明这个活的详细细节是什么，上交这份报告（NSInvocation）给组织，组织给你处理 ***/
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([LRMessageForwardDevelop instancesRespondToSelector:anInvocation.selector]) {
        LRMessageForwardDevelop *develop = [[LRMessageForwardDevelop alloc] init:_name];
        [anInvocation invokeWithTarget:develop];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signture = [super methodSignatureForSelector:aSelector];
    if (!signture) {
        // 不实现签名会崩溃
        // 判断实现类的实例是否有这个方法 有则签名这个方法 保证能正确转发
        if ([LRMessageForwardDevelop instanceMethodSignatureForSelector:aSelector]) {
            signture = [LRMessageForwardDevelop instanceMethodSignatureForSelector:aSelector];
        }
        
    }
    return signture;
}

@end
