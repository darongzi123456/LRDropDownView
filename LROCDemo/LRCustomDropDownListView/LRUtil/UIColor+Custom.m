//
//  UIColor+Custom.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/17.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

+ (UIColor *)colorWithHexString: (NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)lrBlackColor {
    return [UIColor colorWithHexString:@"#333333"];
}

+ (UIColor *)lrMediumGrayColor {
    return [UIColor colorWithHexString:@"#999999"];
}

+ (UIColor *)lrLineColor {
    return [UIColor colorWithHexString:@"#F0F0F0"];
}

+ (UIColor *)lrBackGroundColor {
    return [UIColor colorWithHexString:@"#F6F6F6"];
}

+ (UIColor *)lrOrangeColor {
    return [UIColor colorWithHexString:@"#FF8700"];
}

@end
