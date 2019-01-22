//
//  LRTableViewCell.h
//  LROCDemo
//
//  Created by dalizi on 2019/1/18.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * 配合LRTableRow使用
 * 子类需要命名为XXXRowCell，可以让LRTableRow自动创建对应的cell
 */

@interface LRTableViewCell : UITableViewCell

- (void)cellDidCrate NS_REQUIRES_SUPER;

@end
