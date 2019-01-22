//
//  LRTableSection.h
//  LROCDemo
//
//  Created by dalizi on 2019/1/19.z
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRTableNode.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LRTableView;
@class LRTableRow;

@interface LRTableSection : LRTableNode

@property (nonatomic,assign) CGFloat headerHeight;
@property (nonatomic,assign) CGFloat footerHeight;

- (CGFloat)heightForHeaderInTableView:(LRTableView *)tableView section:(NSInteger)section;
- (CGFloat)heightForFooterInTableView:(LRTableView *)tableView section:(NSInteger)section;

- (nullable NSArray<__kindof LRTableRow *> *)allRows;
- (void)setAllRows:(nullable NSArray<__kindof LRTableRow *> *)rows;
- (nullable __kindof LRTableRow *)rowAtIndex:(NSUInteger)index;

- (void)addRow:(nullable LRTableRow *)row;
- (void)addRowsFromArray:(nullable NSArray<LRTableRow *> *)array;

- (NSUInteger)section;

- (nullable UITableViewHeaderFooterView *)viewForHeaderInTableView:(LRTableView *)tableView section:(NSInteger)section;
- (nullable UITableViewHeaderFooterView *)viewForFooterInTableView:(LRTableView *)tableView section:(NSInteger)section;
- (void)tableView:(LRTableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section;
- (void)tableView:(LRTableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
