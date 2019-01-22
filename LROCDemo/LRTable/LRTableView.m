//
//  LRTableView.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/18.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRTableView.h"
#import "LRTableViewDelegateProxy.h"

@interface LRTableView ()

@property (nonatomic,strong) LRTableViewDelegateProxy *delegateProxy;

@end

@implementation LRTableView

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    if (delegate == nil) {
        [super setDelegate:nil];
        self.delegateProxy.target = nil;
        self.delegateProxy        = nil;
        return;
    }
    if (self.delegateProxy == nil) {
        self.delegateProxy = [LRTableViewDelegateProxy alloc];
    }
    self.delegateProxy.target = delegate;
    [super setDelegate:self.delegateProxy];
}

- (void)dealloc {
    [self setDelegate:nil];
}

@end
