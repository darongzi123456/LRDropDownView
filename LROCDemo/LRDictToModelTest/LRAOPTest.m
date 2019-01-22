//
//  LRAOPTest.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/10.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRAOPTest.h"
#import <objc/runtime.h>

const char *kPropertyListKey = "LRPropertyListKey";

@implementation LRAOPTest

- (instancetype)copyWithZone:(NSZone *)zone {
    LRAOPTest *model = [[LRAOPTest allocWithZone:zone] init];
    model.name = self.name;
    model.age  = self.age;
    return model;
}

+ (NSArray *)lr_objcProperty {
    // 获取当前对象关联对象
    NSArray *ptyList = objc_getAssociatedObject(self, kPropertyListKey);
    if (ptyList) {
        return ptyList;
    }
    /*
     ** 调用运行时方法，取得类的属性列表
     ** 获取成员变量： class_copyIvarList(Class  _Nullable __unsafe_unretained cls, unsigned int * _Nullable outCount);
     ** 获取方法：    class_copyMethodList(Class  _Nullable __unsafe_unretained cls, unsigned int * _Nullable outCount);
     ** 获取属性：    class_copyPropertyList(Class  _Nullable __unsafe_unretained cls, unsigned int * _Nullable outCount);
     ** 获取协议：    class_copyProtocolList(Class  _Nullable __unsafe_unretained cls, unsigned int * _Nullable outCount);
     */
    unsigned int outCount = 0;
    /*
     ** 参数1：要获取的类
     ** 参数2：类属性的个数指针
     ** 参数3：所有属性的数组，C语言中数组的名字就是指向第一个元素的地址
     ** tips：retain create copy 的需要release
     */
    objc_property_t *propertyList = class_copyPropertyList([self class], &outCount);
    NSMutableArray  *array        = [NSMutableArray array];
    
    for (unsigned int i = 0; i < outCount; i++) {
        objc_property_t property   = propertyList[i];
        const char *propertyName   = property_getName(property);
        NSLog(@"propertyName:%s",propertyName);
        NSString   *propertyNameOC = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        NSLog(@"propertyNameOC:%@",propertyNameOC);
        [array addObject:propertyNameOC];
    }
    /*
     ** 给当前对象添加关联对象
     ** 参数1：对象self
     ** 参数2：动态添加属性的key
     ** 参数3：动态添加属性值
     ** 参数4：对象的引用关系
     */
    objc_setAssociatedObject(self, kPropertyListKey, array.copy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    /*
     ** class_copyPropertyList 释放
     */
    free(propertyList);
    
    return array.copy;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    id objcModel               = [[self alloc] init];
    NSArray *propertyList = [self lr_objcProperty];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"key:%@--value:%@",key,obj);
        if ([propertyList containsObject:key]) {
            [objcModel setValue:obj forKey:key];
        }
    }];
    return objcModel;
}

@end
