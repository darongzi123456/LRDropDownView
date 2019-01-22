//
//  LRTableRow.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/18.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRTableRow.h"
#import "LRTableView.h"
#import "LRTableViewCell.h"
#import "LRTableSection.h"

@implementation LRTableRow
@dynamic estimatedHeight;

- (UITableViewCell *)cellForTableViewAutoAdjust {
    static NSMutableDictionary *templateCellDict = nil;
    if (!templateCellDict) {
        templateCellDict = [NSMutableDictionary dictionary];
    }
    NSString *identifier  = [self reuseIdentifier];
    UITableViewCell *cell = templateCellDict[identifier];
    if (!cell) {
        cell = [self createNewTableViewCellForRow];
        templateCellDict[identifier] = cell;
    }
    return cell;
}

- (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (UITableViewCell *)createNewTableViewCellForRow {
    Class cellClass = NSClassFromString([NSStringFromClass([self class]) stringByAppendingString:@"Cell"]);
    if (cellClass) {
        return [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.reuseIdentifier];
    } else {
        [NSException raise:NSInvalidArgumentException format:@"The %s must be implemented by subclass  or consider use LRTableViewCell",__FUNCTION__];
    }
    return nil;
}

- (UITableViewCell *)cellForTableView:(LRTableView *)tableView indexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self reuseIdentifier]];
    self.tableView = tableView;
    if (!cell) {
        cell = [self createNewTableViewCellForRow];
    }
    return cell;
}

- (void)updateCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {}

- (BOOL)autoAdjustCellHeight {
    return NO;
}

- (void)invalidAutoCellHeight {
    self.cellHeight = 0;
}

- (NSIndexPath *)indexPath {
    NSUInteger section = [self.parent nodeIndex];
    NSUInteger row     = [self nodeIndex];
    if (section != NSNotFound && row != NSNotFound) {
        return [NSIndexPath indexPathForRow:row inSection:section];
    } else {
        return nil;
    }
}

- (void)tableView:(LRTableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {}

- (void)tableView:(LRTableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {}

- (void)rowDidAddToSection:(LRTableSection *)section nodeIndex:(NSInteger)index {}

- (void)rowWillAddToSection:(LRTableSection *)section nodeIndex:(NSInteger)index {}

- (void)rowWillRemoveFromSection:(LRTableSection *)section nodeIndex:(NSInteger)index {}

- (void)rowDidRemoveFromSection:(LRTableSection *)section nodeIndex:(NSInteger)index {}

@end
