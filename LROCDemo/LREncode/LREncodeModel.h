//
//  LREncodeModel.h
//  LROCDemo
//
//  Created by dalizi on 2019/1/11.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LREncodeModel : NSObject <NSCoding>

@property (nonatomic,copy)   NSString  *storeName;
@property (nonatomic,assign) NSInteger storeAge;

@end
