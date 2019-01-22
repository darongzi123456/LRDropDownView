//
//  LRDropDownIndexPath.h
//  LROCDemo
//
//  Created by dalizi on 2019/1/16.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRDropDownIndexPath : NSObject

@property (nonatomic,assign) NSInteger column;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,assign) NSInteger childRow;

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row;
+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row;
+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row childRow:(NSInteger)childRow;

@end
