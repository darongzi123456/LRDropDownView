//
//  LRTableNode.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/18.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRTableNode.h"

@interface LRTableNode ()
{
    NSMutableArray <LRTableNode *>*_children;
}
@property (nonatomic,weak,readwrite,nullable) __kindof LRTableNode *parent;
@end

@implementation LRTableNode

- (void)addChild:(__kindof LRTableNode *)node {
    if ([node isKindOfClass:[LRTableNode class]]) {
        node.parent = self;
        @synchronized(self) {
            if (!_children) {
                _children = [NSMutableArray array];
            }
            [_children addObject:node];
        }
    }
}

- (void)addChildrenFromArray:(NSArray<LRTableNode *> *)array {
    if ([array count]) {
        [array enumerateObjectsUsingBlock:^(LRTableNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addChild:obj];
        }];
    }
}

- (void)insertChild:(LRTableNode *)node atIndex:(NSUInteger)index {
    if ([node isKindOfClass:[LRTableNode class]]) {
        node.parent = self;
        @synchronized(self) {
            if (!_children) {
                _children = [NSMutableArray array];
            }
            [_children insertObject:node atIndex:index];
        }
    }
}

- (void)insertChild:(LRTableNode *)node beforeNode:(LRTableNode *)siblingNode {
    NSUInteger index = [[self children] indexOfObject:siblingNode];
    if (index != NSNotFound) {
        [self insertChild:node atIndex:index];
    }
}

- (void)insertChild:(LRTableNode *)node afterNode:(LRTableNode *)siblingNode {
    NSUInteger index = [[self children] indexOfObject:siblingNode];
    if (index != NSNotFound) {
        [self insertChild:node atIndex:index];
    }
}

- (void)insertChildFromArray:(NSArray<LRTableNode *> *)array atIndex:(NSUInteger)index {
    [array enumerateObjectsUsingBlock:^(LRTableNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self insertChild:obj atIndex:index + idx];
    }];
}

- (void)insertChildFromArray:(NSArray<LRTableNode *> *)array beforeNode:(LRTableNode *)siblindNode {
    NSUInteger index = [[self children] indexOfObject:siblindNode];
    if (index != NSNotFound) {
        [self insertChildFromArray:array atIndex:index];
    }
}

- (void)insertChildFromArray:(NSArray<LRTableNode *> *)array afterNode:(LRTableNode *)siblingNode {
    NSUInteger index = [[self children] indexOfObject:siblingNode];
    if (index != NSNotFound) {
        [self insertChildFromArray:array atIndex:index];
    }
}

- (void)removeChild:(LRTableNode *)node {
    @synchronized(self) {
        if ([_children containsObject:node]) {
            [_children removeObject:node];
            node.parent = nil;
        }
    }
}

- (void)removeFromParent {
    [self.parent removeChild:self];
}

- (void)removeAllChildren {
    @synchronized(self) {
        [_children enumerateObjectsUsingBlock:^(LRTableNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.parent = nil;
        }];
        _children = nil;
    }
}

- (NSUInteger)nodeIndex {
    if (self.parent) {
        return [self.parent.children indexOfObject:self];
    }
    return NSNotFound;
}

- (LRTableNode *)firstChild {
    return [self.children firstObject];
}

- (LRTableNode *)lastChild {
    return [self.children lastObject];
}

- (LRTableNode *)nextSiblings {
    NSUInteger index = [self nodeIndex];
    if (index == NSNotFound) {
        return nil;
    }
    if ([self.parent count] > index + 1) {
        return self.parent[index + 1];
    }
    return nil;
}

- (LRTableNode *)previousSiblings {
    NSInteger index = [self nodeIndex];
    if (index == NSNotFound) {
        return nil;
    }
    if (index - 1 >= 0) {
        return self.parent[index - 1];
    }
    return nil;
}

- (NSArray *)siblings {
    if (self.parent == nil || self.nodeIndex == NSNotFound) {
        return nil;
    }
    NSMutableArray *array = [[self.parent children] mutableCopy];
    [array removeObject:self];
    return array.copy;
}

- (BOOL)isFirstChild {
    return [self.parent firstChild] == self;
}

- (BOOL)isLastChild {
    return [self.parent lastChild] == self;
}

- (NSUInteger)count {
    return [self.children count];
}

- (LRTableNode *)objectAtIndexedSubscript:(NSUInteger)index {
    return self.children[index];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id  _Nullable __unsafe_unretained [])buffer
                                    count:(NSUInteger)length {
    return [self.children countByEnumeratingWithState:state
                                              objects:buffer
                                                count:length];
}

- (void)setChildren:(NSArray<__kindof LRTableNode *> *)children {
    [self removeAllChildren];
    [self addChildrenFromArray:children];
}

- (NSArray<LRTableNode *> *)children {
    return [_children copy];
}

- (void)dealloc {
    [self removeAllChildren];
}

@end
