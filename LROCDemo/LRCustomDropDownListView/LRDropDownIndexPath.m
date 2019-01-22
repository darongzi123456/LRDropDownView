//
//  LRDropDownIndexPath.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/16.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRDropDownIndexPath.h"

@implementation LRDropDownIndexPath

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row {
    self = [super init];
    if (self) {
        _column   = column;
        _row      = row;
        _childRow = -1;
    }
    return self;
}

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row childRow:(NSInteger)childRow {
    self = [self initWithColumn:column row:row];
    if (self) {
        _childRow = childRow;
    }
    return self;
}

+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row {
    LRDropDownIndexPath *indexPath = [[self alloc] initWithColumn:column row:row];
    return indexPath;
}

+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row childRow:(NSInteger)childRow {
    LRDropDownIndexPath *indexPath = [[self alloc] initWithColumn:column row:row childRow:childRow];
    return indexPath;
}

@end
