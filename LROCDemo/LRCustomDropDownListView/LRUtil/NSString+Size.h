//
//  NSString+Size.h
//  LROCDemo
//
//  Created by dalizi on 2019/1/17.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Size)

+ (CGSize)calculateSize:(NSString *)string
                   font:(UIFont *)font
                   maxW:(CGFloat)maxW;

@end
