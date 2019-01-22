//
//  LRDropDownMenu.h
//  LROCDemo
//
//  Created by dalizi on 2019/1/16.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRDropDownMenu,LRDropDownIndexPath;

@protocol LRDropDownMenuDelegate <NSObject>

- (void)downMenu:(LRDropDownMenu *)downMenu didSelectRowAtIndexPath:(LRDropDownIndexPath *)indexPath;

@end

@protocol LRDropDownMenuDataSource <NSObject>

- (NSInteger)downMenu:(LRDropDownMenu *)downMenu numberOfRowsInColumn:(NSInteger)column;

- (NSInteger)downMenu:(LRDropDownMenu *)downMenu numberOfChildRowsInRow:(NSInteger)row column:(NSInteger)column;

- (NSString *)downMenu:(LRDropDownMenu *)downMenu titleForRowAtIndexPath:(LRDropDownIndexPath *)indexPath;

- (NSString *)downMenu:(LRDropDownMenu *)downMenu titleForChildRowsInRowAtIndexPath:(LRDropDownIndexPath *)indexPath;

- (NSString *)downMenu:(LRDropDownMenu *)downMenu detailTextForChildRowsInRowAtIndexPath:(LRDropDownIndexPath *)indexPath;

- (NSInteger)downMenu:(LRDropDownMenu *)downMenu reddotCountForRowAtIndexPath:(LRDropDownIndexPath *)indexPath;

@optional;
- (UIView *)downMenu:(LRDropDownMenu *)downMenu accessoryViewForRowAtIndexPath:(LRDropDownIndexPath *)indexPath;

- (NSInteger)numberOfColumnsInDownMenu:(LRDropDownMenu *)downMenu;


@end

@interface LRDropDownMenu : UIView

@property (nonatomic,weak)   id <LRDropDownMenuDelegate>   delegate;
@property (nonatomic,weak)   id <LRDropDownMenuDataSource> dataSource;

@property (nonatomic,strong) UIColor        *titleColor;
@property (nonatomic,strong) UIColor        *titleSelectColor;
@property (nonatomic,strong) UIColor        *detailTitleColor;
@property (nonatomic,strong) UIColor        *separatorColor;

@property (nonatomic,strong) UIFont         *detailTitleFont;
@property (nonatomic,assign) double         fontSize;

@property (nonatomic,assign) CGFloat        separatorOffset;
@property (nonatomic,assign) CGFloat        dropDownListViewWidth;

/* 切换条件是是否更改menuTitle */
@property (nonatomic,assign) BOOL           resetMenuTitle;

@property (nonatomic,strong) NSMutableArray     *currentSelectRowArr;
/* 自定义指示器图片,设置dataSource之前调用 */
@property (nonatomic,strong) NSArray<NSString *>*indicatorImageNames;
/* 自定义指示器图片是否可以transform,设置dataSource之前调用 */
@property (nonatomic,strong) NSArray<NSNumber *>*indicatorAnimates;

@property (nonatomic,copy)   void(^collapseDropDownMenuBlock)(LRDropDownIndexPath *indexPath);

- (instancetype)initWithOrigin:(CGPoint)origin
                         width:(CGFloat)width
                        height:(CGFloat)height;

- (void)selectIndexPath:(LRDropDownIndexPath *)indexPath;

@end
