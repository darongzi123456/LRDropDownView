//
//  LRTableSection.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/19.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRTableSection.h"
#import "LRTableView.h"
#import "LRTableRow.h"

@implementation LRTableSection

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.headerHeight = CGFLOAT_MIN;
    self.footerHeight = CGFLOAT_MIN;
}

- (NSArray<LRTableRow *> *)allRows {
    return [self children];
}

- (void)setAllRows:(NSArray<__kindof LRTableRow *> *)rows {
    [self setChildren:rows];
}

- (void)addRow:(LRTableRow *)row {
    [self addChild:row];
}

- (void)addChild:(__kindof LRTableNode *)node {
    NSUInteger index = [self.children count];
    [self ifNodeIsTableRow:node block:^(LRTableRow *row) {
        [row rowWillAddToSection:self nodeIndex:index];
    }];
    [super addChild:node];
    [self ifNodeIsTableRow:node block:^(LRTableRow *row) {
        [row rowDidAddToSection:self nodeIndex:index];
    }];
}

- (void)insertChild:(LRTableNode *)node atIndex:(NSUInteger)index {
    [self ifNodeIsTableRow:node block:^(LRTableRow *row) {
        [row rowWillAddToSection:self nodeIndex:index];
    }];
    [super insertChild:node atIndex:index];
    [self ifNodeIsTableRow:node block:^(LRTableRow *row) {
        [row rowDidAddToSection:self nodeIndex:index];
    }];
}

- (void)removeChild:(LRTableNode *)node {
    NSUInteger nodeIndex = node.nodeIndex;
    BOOL contains = [self.children containsObject:node];
    [self ifNodeIsTableRow:node otherCondition:contains block:^(LRTableRow *row) {
        [row rowWillRemoveFromSection:self nodeIndex:nodeIndex];
    }];
    [super removeChild:node];
    [self ifNodeIsTableRow:node otherCondition:contains block:^(LRTableRow *row) {
        [row rowDidRemoveFromSection:self nodeIndex:nodeIndex];
    }];
}

- (void)removeAllChild {
    NSArray <LRTableNode *>*array = [self children];
    [array enumerateObjectsUsingBlock:^(LRTableNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self ifNodeIsTableRow:obj block:^(LRTableRow *row) {
            [row rowWillRemoveFromSection:self nodeIndex:idx];
        }];
    }];
    [super removeAllChildren];
    [array enumerateObjectsUsingBlock:^(LRTableNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self ifNodeIsTableRow:obj block:^(LRTableRow *row) {
            [row rowDidRemoveFromSection:self nodeIndex:idx];
        }];
    }];
}

- (void)addRowsFromArray:(NSArray<LRTableRow *> *)array {
    [self addRowsFromArray:array];
}

- (LRTableRow *)rowAtIndex:(NSUInteger)index {
    return [self.children objectAtIndex:index];
}

- (NSUInteger)section {
    return [self nodeIndex];
}

#pragma mark - helpers

- (void)ifNodeIsTableRow:(LRTableNode *)node block:(void(NS_NOESCAPE ^)(LRTableRow *row))block {
    [self ifNodeIsTableRow:node otherCondition:YES block:block];
}

- (void)ifNodeIsTableRow:(LRTableNode *)node otherCondition:(BOOL)condition block:(void(NS_NOESCAPE ^)(LRTableRow *row))block {
    if ([node isKindOfClass:[LRTableRow class]] && block && condition) {
        block((LRTableRow *)node);
    }
}

- (UITableViewHeaderFooterView *)viewForHeaderInTableView:(LRTableView *)tableView section:(NSInteger)section {
    return nil;
}

- (UITableViewHeaderFooterView *)viewForFooterInTableView:(LRTableView *)tableView section:(NSInteger)section {
    return nil;
}

- (CGFloat)heightForHeaderInTableView:(LRTableView *)tableView section:(NSInteger)section {
    return self.headerHeight;
}

- (CGFloat)heightForFooterInTableView:(LRTableView *)tableView section:(NSInteger)section {
    return self.footerHeight;
}

- (void)tableView:(LRTableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
}

- (void)tableView:(LRTableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
}
@end
