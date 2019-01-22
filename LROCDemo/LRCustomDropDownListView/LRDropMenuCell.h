//
//  LRDropMenuCell.h
//  LROCDemo
//
//  Created by dalizi on 2019/1/21.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRDropMenuCell : UITableViewCell

@property (nonatomic, strong) UIColor   *textColor;         // 文字title颜色
@property (nonatomic, strong) UIColor   *detailTextColor;   // detailText文字颜色

@property (nonatomic, assign) NSInteger fontSize;           // 文字title字体大小
@property (nonatomic, strong) UIFont    *detailTextFont;    // detailText字体大小

@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *detailTitle;

@property (nonatomic, strong) UIView    *customAccessoryView;
@property (nonatomic, assign) BOOL      titleShowCenter;
+ (NSString *)reuseIdentifier;

@end
