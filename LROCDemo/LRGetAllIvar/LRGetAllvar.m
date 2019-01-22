//
//  LRGetAllvar.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/10.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRGetAllvar.h"
#import <objc/runtime.h>
#import "LRPrivateModel.h"

@interface LRGetAllvar ()
{
    /* 不生成setter和getter方法*/
    NSString *_age;
    BOOL     guest;
}

@property (nonatomic,copy) NSString *name;
- (void)privateTest;

@end

@implementation LRGetAllvar

- (void)getAllIvar {
    unsigned int count = 0;
    /*
     ** Ivar：定义对象的实例变量，包括类型和名字
     ** 获取所有的属性，包括私有属性
     ** 获取成员变量： class_copyIvarList(Class  _Nullable __unsafe_unretained cls, unsigned int * _Nullable outCount);
     ** 获取方法：    class_copyMethodList(Class  _Nullable __unsafe_unretained cls, unsigned int * _Nullable outCount);
     ** 获取属性：    class_copyPropertyList(Class  _Nullable __unsafe_unretained cls, unsigned int * _Nullable outCount);
     ** 获取协议：    class_copyProtocolList(Class  _Nullable __unsafe_unretained cls, unsigned int * _Nullable outCount);
     */
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (unsigned int i = 0; i< count; i++) {
        Ivar ivar      = ivars[i];
        NSString *name = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        NSString *type = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
        NSLog(@"属性---%@---类型:%@",name,type);
    }
}

- (void)getAllMethod {
    /*
     ** Ivar：定义对象的实例变量，包括类型和名字
     ** 获取所有的方法，包括私有方法
     ** 获取成员变量： class_copyIvarList(Class  _Nullable __unsafe_unretained cls, unsigned int * _Nullable outCount);
     ** 获取方法：    class_copyMethodList(Class  _Nullable __unsafe_unretained cls, unsigned int * _Nullable outCount);
     ** 获取属性：    class_copyPropertyList(Class  _Nullable __unsafe_unretained cls, unsigned int * _Nullable outCount);
     ** 获取协议：    class_copyProtocolList(Class  _Nullable __unsafe_unretained cls, unsigned int * _Nullable outCount);
     */
    unsigned int count = 0;
    Method *funcs = class_copyMethodList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        SEL address = method_getName(funcs[i]);
        NSString *methodNameOC = [NSString stringWithCString:sel_getName(address) encoding:NSUTF8StringEncoding];
        NSLog(@"方法名:%@",methodNameOC);
    }
}

- (void)invitePrivateProperty {
    LRPrivateModel *model = [[LRPrivateModel alloc] init];
    Ivar ivar = class_getInstanceVariable([LRPrivateModel class], "_privateStr");
    NSString *_age_value = object_getIvar(model, ivar);
    NSLog(@"_privateStr_value:%@",_age_value);
}

- (void)privateTest {
    NSLog(@"privateTest");
}

@end
