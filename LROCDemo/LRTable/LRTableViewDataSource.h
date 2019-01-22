//
//  LRTableViewDataSource.h
//  LROCDemo
//
//  Created by dalizi on 2019/1/18.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRTableNode.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LRTableSection;
@class LRTableRow;

@interface LRTableViewDataSource : LRTableNode <UITableViewDataSource>

- (__kindof LRTableRow *)rowAtIndexPath:(NSIndexPath *)indexPath;
- (__kindof LRTableSection *)sectionAtIndex:(NSUInteger)index;
- (CGFloat)autoAdjustedCellHeightAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (void)addSection:(LRTableSection *)section;
- (void)addSectiomFromArray:(NSArray<LRTableSection *> *)array;
- (NSArray<LRTableSection *> *)allSections;
- (NSArray<LRTableRow *> *)allRows;

@end

NS_ASSUME_NONNULL_END
