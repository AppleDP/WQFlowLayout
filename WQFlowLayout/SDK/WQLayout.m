//
//  WQLayout.m
//  WQFlowLayout
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 SUWQ. All rights reserved.
//

#import "WQLayout.h"
#import "UIView+FrameChange.h"

@interface WQLayout ()
// collectionView 的相对于 contentSize 的最左边中心点（x或y）
@property (nonatomic, assign) CGFloat cCenter;
// attribute 的相对于 contentSize 的最左边中心点（x或y）
@property (nonatomic, assign) CGFloat aCenter;
// collectionView 的长或宽
@property (nonatomic, assign) CGFloat cSize;
// item 的长或宽
@property (nonatomic, assign) CGFloat iSize;
@end

@implementation WQLayout
#pragma mark Public Method
+ (WQLayout *)createWQLayout{
    return [[[self class] alloc] init];
}

#pragma mark System Method
- (void)prepareLayout{
    [super prepareLayout];
    // 设置内边距,使第一个item居中
    CGFloat inset = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? (self.collectionView.frame.size.width - self.itemSize.width) * 0.5 : (self.collectionView.frame.size.height - self.itemSize.height) * 0.5;
    self.sectionInset = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? UIEdgeInsetsMake(0, inset, 0, inset) : UIEdgeInsetsMake(inset, 0, inset, 0);
    
    // collectionView 的相对于 contentSize 的最左边中心点（x或y）
    self.cCenter = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? self.collectionView.contentOffset.x + self.collectionView.width/2.0 : self.collectionView.contentOffset.y + self.collectionView.height/2.0;
    
    // collectionView 的长或宽
    self.cSize = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? self.collectionView.width : self.collectionView.height;
    
    self.iSize = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? self.itemSize.width : self.itemSize.height;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    if (self.type == WQScaleLayout) {
        return [self scaleWithAttributes:attributes];
    }else{
        return [self rotationWithAttributes:attributes];
    }
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity{
    NSLog(@"===== velocity: %@ =====",NSStringFromCGPoint(velocity));
    CGRect rect;
    rect.origin.x = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? proposedContentOffset.x : 0;
    rect.origin.y = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? 0 : proposedContentOffset.y;
    rect.size = self.collectionView.bounds.size;
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    // 得到离 rect 中心点最近的值
    CGFloat min = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        self.aCenter = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? attribute.center.x : attribute.center.y;
        min = MIN(fabs(min), fabs(self.aCenter - self.cCenter)) == fabs(min) ? min : self.aCenter - self.cCenter;
    }

    // 调节移动停止后的 Offset
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        proposedContentOffset.x = proposedContentOffset.x + min;
    }else {
        proposedContentOffset.y = proposedContentOffset.y + min;
    }
    return proposedContentOffset;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);;
}

#pragma mark Scale Flow Layout
- (NSArray<UICollectionViewLayoutAttributes *> *)scaleWithAttributes:(NSArray<UICollectionViewLayoutAttributes *> *)attributes{
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        self.aCenter = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? attribute.center.x : attribute.center.y;
        CGFloat scale = 1 - fabs(self.aCenter - self.cCenter)/self.cSize;
        attribute.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    }
    return attributes;
}


#pragma mark Rotation Flow Layout
- (NSArray<UICollectionViewLayoutAttributes *> *)rotationWithAttributes:(NSArray<UICollectionViewLayoutAttributes *> *)attributes{
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        self.aCenter = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? attribute.center.x : attribute.center.y;
        CGFloat rotation = (self.cCenter - self.aCenter)/self.cSize;
        attribute.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/2 * rotation);
    }
    return attributes;
}
@end












