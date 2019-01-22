//
//  LRTableRow.h
//  LROCDemo
//
//  Created by dalizi on 2019/1/18.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRTableNode.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LRTableView;
@class LRTableViewCell;
@class LRTableSection;

typedef void(^LRTableRowSelectedBlock)(LRTableView *tableView,NSIndexPath *indexPath);

@interface LRTableRow : LRTableNode

@property (nonatomic,weak,nullable) LRTableView             *tableView;
@property (nonatomic,copy,nullable) LRTableRowSelectedBlock selectedBlock;
@property (nonatomic,assign) CGFloat cellHeight;
/*
 * 是否自适应cell高度
 * 子类不要同时重载cellHeight方法
 */
- (BOOL)autoAdjustCellHeight;
/*
 * 配合autoAdjustCellHeight方法
 * 当已自动计算过的cell的contraint发生变化后调用该方法
 * 已经显示的cell不会自动调整高度，需要再调用此方法后手动reload对应的row
 */
- (void)invalidAutoCellHeight;
/*
 * 默认为NSStringFromClass([self class])
 */
- (NSString *)reuseIdentifier;
/*
 * 创建一个新的cell对象
 * @warning 必须重载！
 */
- (__kindof UITableViewCell *)createNewTableViewCellForRow;
/*
 * 提供用于自动计算Row高度的cell，不要直接使用
 */
- (UITableViewCell *)cellForTableViewAutoAdjust NS_REQUIRES_SUPER;
/*
 * 返回cell，可以重载但是不要直接调用
 */
- (__kindof UITableViewCell *)cellForTableView:(LRTableView *)tableView indexPath:(NSIndexPath *)indexPath NS_REQUIRES_SUPER;
- (void)updateCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath NS_REQUIRES_SUPER;
- (nullable NSIndexPath *)indexPath;
/*
 * 用来重载，基类本身没有实现该方法，不要直接调用它
 */
@property (nonatomic,readonly) CGFloat estimatedHeight;
/*
 * 可以在row中处理cell的willDisplayCell
 */
- (void)tableView:(LRTableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
/*
 * 可以再row中处理cell的endDisplayCell
 */
- (void)tableView:(LRTableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
/*
 * row被加到section前后会调用以下方法，默认实现为空
 */
- (void)rowWillAddToSection:(LRTableSection *)section nodeIndex:(NSInteger)index;
- (void)rowDidAddToSection:(LRTableSection *)section nodeIndex:(NSInteger)index;
/*
 * row被从section移除前后会调用以下方法，默认实现为空
 */
- (void)rowWillRemoveFromSection:(LRTableSection *)section nodeIndex:(NSInteger)index;
- (void)rowDidRemoveFromSection:(LRTableSection *)section nodeIndex:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END
