//
//  UIView+CacluLayout.h
//  AIFHousingLoanCalculator
//
//  Created by lawrence on 12/25/14.
//  Copyright (c) 2014 Anjuke Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CalcLayout)

- (id)initWithMainFrame;
+ (CGRect)mainFrame;

+ (CGRect)fullScreenBound;
+ (CGRect)navigationControllerBound;
+ (CGRect)tabBarNavigationBound;

- (CGFloat)left;
- (CGFloat)right;
- (CGFloat)top;
- (CGFloat)bottom;
- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)centerX;
- (CGFloat)centerY;

- (void)setLeft:(CGFloat)left;
- (void)setRight:(CGFloat)right;
- (void)setBottom:(CGFloat)bottom;
- (void)setSize:(CGSize)size;
- (void)setTop:(CGFloat)top;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setOrigin:(CGPoint)point;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;

- (void)setRoundedCorner:(CGFloat)cornerRadius;

- (void)ajkLargeRoundedCorner;
- (void)ajkMiddleRoundedCorner;
- (void)ajkSmallRoundedCorner;

@end
