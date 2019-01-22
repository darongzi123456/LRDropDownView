//
//  LREncodeModel.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/11.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LREncodeModel.h"
#import <objc/runtime.h>

@implementation LREncodeModel

//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject :self.storeName   forKey:@"storeName"];
//    [aCoder encodeInteger:self.storeAge    forKey:@"storeAge"];
//}

//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super init];
//    if (self) {
//        self.storeName = [aDecoder decodeObjectForKey:@"storeName"];
//        self.storeAge  = [aDecoder decodeIntForKey:@"storeAge"];
//    }
//    return self;
//}

//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    unsigned int iVarCount = 0;
//    Ivar         *iVarList = class_copyIvarList([self class], &iVarCount);
//    for (unsigned int i = 0; i < iVarCount; i++) {
//        Ivar ivar            = *(iVarList + i);
//        const char *ivarName = ivar_getName(ivar);
//        NSString   *key      = [NSString stringWithUTF8String:ivarName];
//        id          varValue = [aDecoder decodeObjectForKey:key];
//        if (varValue) {
//            [self setValue:varValue forKey:key];
//        }
//    }
//    free(iVarList);
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    unsigned int iVarCount = 0;
//    Ivar         *iVarList = class_copyIvarList([self class], &iVarCount);
//    for (unsigned int i = 0; i < iVarCount; i++) {
//        Ivar        ivar      = *(iVarList + i);
//        const char  *ivarName = ivar_getName(ivar);
//        NSString    *key      = [NSString stringWithUTF8String:ivarName];
//        id          varValue  = [self valueForKey:key];
//        if (varValue) {
//            [aCoder encodeObject:varValue forKey:key];
//        }
//    }
//    free(iVarList);
//}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"self:%s",__func__);
    Class cls = [self class];
    while (cls != [NSObject class]) {
        // 是否是当前类
        BOOL isSelfClass = (cls == [self class]);
        // 当前类的变量个数
        unsigned int iVarCount      = 0;
        // 非当前类的变量个数
        unsigned int propVarCount   = 0;
        // 最终的变量个数
        unsigned int lastVarCount   = 0;
        /*
         ** 变量列表包含属性和私有列表
         ** Ivar：定义对象的实例变量，包括类型和名字
         ** class_copyIvarList ：获取成员变量
         */
        Ivar *ivarList = NULL;
        if (isSelfClass) {
            ivarList = class_copyIvarList(cls, &iVarCount);
        }
        /*
         ** 获取类的所有属性列表
         ** objc_property_t：
         ** class_copyPropertyList：
         */
        objc_property_t *propList = NULL;
        if (!isSelfClass) {
            propList = class_copyPropertyList(cls, &propVarCount);
        }
        if (isSelfClass) {
            lastVarCount = iVarCount;
        } else {
            lastVarCount = propVarCount;
        }
        /*
         ** 数组名可以认为是一个指针，它指向数组的第0 个元素
         ** *(ivarList+i)等价于ivarList[i]
         */
        for (unsigned int i = 0; i < lastVarCount; i++) {
            if (isSelfClass) {
                Ivar ivar           = *(ivarList + i);
                const char *varName = ivar_getName(ivar);
                NSString *key       = [NSString stringWithUTF8String:varName];
                NSLog(@"var---key : %@",key);
                id varValue         = [aDecoder decodeObjectForKey:key];
                NSLog(@"var---value : %@",varValue);
                NSArray *filters    = @[@"superclass",@"description",@"debugDescription",@"hash"];
                if (varValue && ![filters containsObject:key]) {
                    [self setValue:varValue forKey:key];
                }
            } else {
                objc_property_t prop = *(propList + i);
                const char *propName = property_getName(prop);
                NSString *key       = [NSString stringWithUTF8String:propName];
                NSLog(@"prop---key : %@",key);
                id propValue         = [aDecoder decodeObjectForKey:key];
                NSLog(@"prop---value : %@",propValue);
                NSArray * filters    = @[@"superclass",@"description",@"debugDescription",@"hash"];
                if (propValue && ![filters containsObject:key]) {
                    [self setValue:propValue forKey:key];
                }
            }
        }
        free(ivarList);
        free(propList);
        cls = class_getSuperclass(cls);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSLog(@"self:%s",__func__);
    Class cls = [self class];
    while (cls != [NSObject class]) {
        BOOL isSelfClass = (cls == [self class]);
        unsigned int iVarCount    = 0;
        unsigned int propVarCount = 0;
        unsigned int lastVarCount = 0;
        Ivar *ivarList            = NULL;
        if (isSelfClass) {
            ivarList = class_copyIvarList(cls, &iVarCount);
        }
        objc_property_t *propList = NULL;
        if (!isSelfClass) {
            propList = class_copyPropertyList(cls, &propVarCount);
        }
        if (isSelfClass) {
            lastVarCount = iVarCount;
        } else {
            lastVarCount = propVarCount;
        }
        for (unsigned int i = 0; i < lastVarCount; i++) {
            NSArray *filters    = @[@"superclass",@"description",@"debugDescription",@"hash"];
            if (isSelfClass) {
                Ivar       ivar     = *(ivarList + i);
                const char *varName = ivar_getName(ivar);
                NSString *key       = [NSString stringWithUTF8String:varName];
                NSLog(@"var---key : %@",key);
                id         varValue = [self valueForKey:key];
                if (varValue && ![filters containsObject:key]) {
                    [aCoder encodeObject:varValue forKey:key];
                }
            } else {
                objc_property_t prop = *(propList + i);
                const char *propName = property_getName(prop);
                NSString        *key = [NSString stringWithUTF8String:propName];
                NSLog(@"var---key : %@",key);
                id propValue         = [self valueForKey:key];
                if (propValue && ![filters containsObject:key]) {
                    [aCoder encodeObject:propValue forKey:key];
                }
            }
        }
        free(ivarList);
        free(propList);
        cls = class_getSuperclass(cls);
    }
}

@end
