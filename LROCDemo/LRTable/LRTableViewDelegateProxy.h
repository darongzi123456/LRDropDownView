//
//  LRTableViewDelegateProxy.h
//  LROCDemo
//
//  Created by dalizi on 2019/1/18.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LRTableViewDelegateProxy : NSProxy<UITableViewDelegate>

@property (nonatomic,weak,nullable) id target;

@end
