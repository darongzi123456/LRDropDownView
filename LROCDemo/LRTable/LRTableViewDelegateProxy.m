//
//  LRTableViewDelegateProxy.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/18.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRTableViewDelegateProxy.h"
#import "LRTableRow.h"
#import "LRTableSection.h"
#import "LRTableViewDataSource.h"
#import "LRTableView.h"

@interface LRTableViewDelegateProxy ()

@property (nonatomic,assign) id originalTarget;

@end

@implementation LRTableViewDelegateProxy

- (void)setTarget:(id)target {
    _target             = target;
    self.originalTarget = target;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if (self.target) {
        [invocation invokeWithTarget:self.target];
    } else {
        [invocation invokeWithTarget:self.originalTarget];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *methodSignature = nil;
    if (self.target) {
        methodSignature = [self.target methodSignatureForSelector:sel];
    } else {
        methodSignature = [self.originalTarget methodSignatureForSelector:sel];
    }
    return methodSignature;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL ret = NO;
    SEL selectors[] = {
        @selector(tableView:heightForRowAtIndexPath:),
        @selector(tableView:didSelectRowAtIndexPath:),
        @selector(tableView:viewForHeaderInSection:),
        @selector(tableView:viewForFooterInSection:),
        @selector(tableView:willDisplayHeaderView:forSection:),
        @selector(tableView:willDisplayFooterView:forSection:),
        @selector(tableView:heightForHeaderInSection:),
        @selector(tableView:heightForFooterInSection:),
        @selector(tableView:didEndDisplayingCell:forRowAtIndexPath:),
        @selector(tableView:willDisplayCell:forRowAtIndexPath:),
        @selector(tableView:estimatedHeightForRowAtIndexPath:),
        NULL
    };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self.target respondsToSelector:@selector(supporeEstimatedHeight)]) {
        selectors[10] = NULL;
    }
#pragma clang diagnostic pop
    for (SEL *p = selectors; *p != NULL; ++p) {
        if (aSelector == *p) {
            ret = YES;
            break;
        }
    }
    if (!ret) {
        ret = [self.target respondsToSelector:aSelector];
    }
    return ret;
}

- (void)tableView:(LRTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView.dataSource isKindOfClass:[LRTableViewDataSource class]]) {
        LRTableViewDataSource *dataSource = (id)tableView.dataSource;
        LRTableRow *row = [dataSource rowAtIndexPath:indexPath];
        if (row.selectedBlock) {
            row.selectedBlock(tableView, indexPath);
        }
    }
    if ([self.target respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.target tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(LRTableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL rowHandle = NO;
    if ([tableView.dataSource isKindOfClass:[LRTableViewDataSource class]]) {
        LRTableViewDataSource *dataSource = (id)tableView.dataSource;
        LRTableRow *row = [dataSource rowAtIndexPath:indexPath];
        if (row && [row respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
            [row tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
            rowHandle = YES;
        }
    }
    if (rowHandle && self.target && [self.target respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.target tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(LRTableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL rowHandle = NO;
    if ([tableView.dataSource isKindOfClass:[LRTableViewDataSource class]]) {
        LRTableViewDataSource *dataSource = (id)tableView.dataSource;
        LRTableRow *row = [dataSource rowAtIndexPath:indexPath];
        if (row && [row respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)]) {
            [row tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
            rowHandle = YES;
        }
    }
    if (rowHandle && self.target && [self.target respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)]) {
        [self.target tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(LRTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.0;
    if (self.target && [self.target respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        height = [self.target tableView:tableView heightForRowAtIndexPath:indexPath];
    } else if ([tableView.dataSource isKindOfClass:[LRTableViewDataSource class]]){
        LRTableViewDataSource *dataSource = (id)tableView.dataSource;
        LRTableRow *row = [dataSource rowAtIndexPath:indexPath];
        if (row.autoAdjustCellHeight) {
            height = [dataSource autoAdjustedCellHeightAtIndexPath:indexPath tableView:tableView];
        } else {
            height = [[dataSource rowAtIndexPath:indexPath] cellHeight];
        }
    }
    if (height < 0) {
        height = 0; //
    }
    return height;
}

- (UIView *)tableView:(LRTableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.target && [self.target respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [self.target tableView:tableView viewForHeaderInSection:section];
    }
    if ([tableView.dataSource isKindOfClass:[LRTableViewDataSource class]]) {
        LRTableViewDataSource *dataSource = (id)tableView.dataSource;
        LRTableSection *tableSection = [dataSource sectionAtIndex:section];
        return [tableSection viewForHeaderInTableView:tableView section:section];
    }
    return nil;
}

- (UIView *)tableView:(LRTableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.target && [self.target respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [self.target tableView:tableView viewForFooterInSection:section];
    }
    if ([tableView.dataSource isKindOfClass:[LRTableViewDataSource class]]) {
        LRTableViewDataSource *dataSource = (id)tableView.dataSource;
        LRTableSection *tableSection = [dataSource sectionAtIndex:section];
        return [tableSection viewForFooterInTableView:tableView section:section];
    }
    return nil;
}

- (CGFloat)tableView:(LRTableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0;
    if (self.target && [self.target respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        height = [self.target tableView:tableView heightForHeaderInSection:section];
    } else if ([tableView.dataSource isKindOfClass:[LRTableViewDataSource class]]) {
        LRTableViewDataSource *dataSource = (id)tableView.dataSource;
        LRTableSection *tableSection = [dataSource sectionAtIndex:section];
        height = [tableSection heightForHeaderInTableView:tableView section:section];
    }
    return height;
}

- (CGFloat)tableView:(LRTableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0.0;
    if (self.target && [self.target respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        height = [self.target tableView:tableView heightForFooterInSection:section];
    } else if ([tableView.dataSource isKindOfClass:[LRTableViewDataSource class]]) {
        LRTableViewDataSource *dataSource = (id)tableView.dataSource;
        LRTableSection *tableSection = [dataSource sectionAtIndex:section];
        height = [tableSection heightForFooterInTableView:tableView section:section];
    }
    return height;
}

- (CGFloat)tableView:(LRTableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    if (self.target && [self.target respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)]) {
        height = [self.target tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    } else if ([tableView.dataSource isKindOfClass:[LRTableViewDataSource class]]) {
        LRTableViewDataSource *dataSource = (id)tableView.dataSource;
        LRTableRow *row = [dataSource rowAtIndexPath:indexPath];
        if ([row respondsToSelector:@selector(estimatedHeight)]) {
            height = [row estimatedHeight];
        }
        if ((height <= 0.0f)) {
            height = row.cellHeight;
        }
    }
    return height;
}

- (void)tableView:(LRTableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (self.target && [self.target respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
        [self.target tableView:tableView willDisplayHeaderView:tableView forSection:section];
    } else if ([tableView.dataSource isKindOfClass:[LRTableViewDataSource class]]) {
        LRTableViewDataSource *dataSource = (id)tableView.dataSource;
        LRTableSection *tableSection = [dataSource sectionAtIndex:section];
        [tableSection tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

- (void)tableView:(LRTableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if (self.target && [self.target respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]) {
        [self.target tableView:tableView willDisplayFooterView:view forSection:section];
    } else if ([tableView.dataSource isKindOfClass:[LRTableViewDataSource class]]) {
        LRTableViewDataSource *dataSource = (id)tableView.dataSource;
        LRTableSection *tableSection = [dataSource sectionAtIndex:section];
        [tableSection tableView:tableView willDisplayFooterView:view forSection:section];
    }
}
@end
