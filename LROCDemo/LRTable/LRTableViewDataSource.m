//
//  LRTableViewDataSource.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/18.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRTableViewDataSource.h"
#import "LRTableSection.h"
#import "LRTableRow.h"

@implementation LRTableViewDataSource

- (void)addSection:(LRTableSection *)section {
    [self addChild:section];
}

- (void)addSectiomFromArray:(NSArray<LRTableSection *> *)array {
    [self addChildrenFromArray:array];
}

- (NSArray<LRTableSection *> *)allSections {
    return [self children];
}

- (void)setSections:(NSArray *)sections {
    [self setChildren:sections];
}

- (NSArray *)rowsInSection:(NSInteger)section {
    NSArray *rows = [[self sectionAtIndex:section] allRows];
    return rows;
}

- (LRTableRow *)rowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rows = [self rowsInSection:indexPath.section];
    return [rows objectAtIndex:indexPath.row];
}

- (LRTableSection *)sectionAtIndex:(NSUInteger)index {
    return [[self allSections] objectAtIndex:index];
}

- (NSArray<LRTableRow *> *)allRows {
    NSMutableArray *array = [NSMutableArray array];
    [self.allSections enumerateObjectsUsingBlock:^(LRTableSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObjectsFromArray:[obj allRows]];
    }];
    return array;
}

/**
 * @see http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights
 */
- (CGFloat)autoAdjustedCellHeightAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    LRTableRow *row = [self rowAtIndexPath:indexPath];
    if ([row cellHeight] > 0) {
        return [row cellHeight];
    } else {
        UITableViewCell *cell = [row cellForTableViewAutoAdjust];
        [row updateCell:cell indexPath:indexPath];
        
        UIView *layoutGuideView = cell;
        [layoutGuideView setNeedsUpdateConstraints];
        [layoutGuideView updateConstraintsIfNeeded];
        layoutGuideView.bounds = CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), CGRectGetHeight(layoutGuideView.bounds));
        [layoutGuideView setNeedsLayout];
        [layoutGuideView layoutIfNeeded];
        
        CGFloat height = [[(UITableViewCell *)layoutGuideView contentView] systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1.0f;
        row.cellHeight = height;
        return height;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self allSections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self rowsInSection:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LRTableRow *row = [self rowAtIndexPath:indexPath];
    UITableViewCell *cell = [row cellForTableView:(id)tableView indexPath:indexPath];
    if (cell) {
        [row updateCell:cell indexPath:indexPath];
    }
    return cell;
}
@end
