//
//  LRDropDownListCellView.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/16.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRDropDownListCellView.h"

@implementation LRDropDownListCellView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context,219.0/255,224.0/255,228.0/255,1);
    
    CGContextMoveToPoint(context,0,0);
    CGContextAddLineToPoint(context,rect.size.width,0);
    
    CGContextMoveToPoint(context,0,rect.size.height);
    CGContextAddLineToPoint(context,rect.size.width,rect.size.height);
    
    CGContextStrokePath(context);
}

@end
