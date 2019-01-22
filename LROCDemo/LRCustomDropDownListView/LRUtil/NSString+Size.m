//
//  NSString+Size.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/17.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

+ (CGSize)calculateSize:(NSString *)string
                   font:(UIFont *)font
                   maxW:(CGFloat)maxW {
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize        size = [string boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    return CGSizeMake(ceilf(size.width) + 2, size.height + 1);
}

@end
