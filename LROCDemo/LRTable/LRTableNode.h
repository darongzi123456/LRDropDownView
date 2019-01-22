//
//  LRTableNode.h
//  LROCDemo
//
//  Created by dalizi on 2019/1/18.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface LRTableNode : NSObject


@property (nonatomic,weak,readonly,nullable) __kindof LRTableNode *parent;
@property (nonatomic,strong,nullable) NSArray <__kindof LRTableNode *> *children;

- (void)addChild:(__kindof LRTableNode *)node;
- (void)addChildrenFromArray:(NSArray<LRTableNode *> *)array;
- (void)insertChild:(LRTableNode *)node atIndex:(NSUInteger)index;
- (void)insertChildFromArray:(NSArray<LRTableNode *> *)array atIndex:(NSUInteger)index;
- (void)insertChild:(LRTableNode *)node beforeNode:(LRTableNode *)siblingNode;
- (void)insertChild:(LRTableNode *)node afterNode:(LRTableNode *)siblingNode;
- (void)insertChildFromArray:(NSArray<LRTableNode *> *)array beforeNode:(LRTableNode *)siblindNode;
- (void)insertChildFromArray:(NSArray<LRTableNode *> *)array afterNode:(LRTableNode *)siblingNode;
- (void)removeChild:(LRTableNode *)node;

- (void)removeFromParent;
- (void)removeAllChildren;
- (NSUInteger)nodeIndex;

- (nullable __kindof LRTableNode *)firstChild;
- (nullable __kindof LRTableNode *)lastChild;

- (NSArray *)siblings;
- (nullable __kindof LRTableNode *)nextSiblings;
- (nullable __kindof LRTableNode *)previousSiblings;

- (BOOL)isFirstChild;
- (BOOL)isLastChild;

- (NSUInteger)count;

- (__kindof LRTableNode *)objectAtIndexedSubscript:(NSUInteger)index;
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained _Nullable [_Nonnull])buffer
                                    count:(NSUInteger)length;

@end
NS_ASSUME_NONNULL_END
