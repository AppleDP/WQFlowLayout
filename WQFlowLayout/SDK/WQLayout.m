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
    NSMutableArray<UICollectionViewLayoutAttributes *> *att = [[NSMutableArray alloc] initWithCapacity:attributes.count];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        self.aCenter = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? attribute.center.x : attribute.center.y;
        if (self.type == WQScaleLayout) {
            [att addObject:[self scaleWithAttribute:attribute]];
        }else if(self.type == WQRotationLayout1) {
            [att addObject:[self rotation1WithAttribute:attribute]];
        }else if(self.type == WQRotationLayout2) {
            [att addObject:[self rotation2WithAttribute:attribute]];
        }else {
            [att addObject:[self rotation3WithAttribute:attribute]];
        }
    }
    return att;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity{
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
- (UICollectionViewLayoutAttributes *)scaleWithAttribute:(UICollectionViewLayoutAttributes *)attribute{
    CGFloat scale = 1 - fabs(self.aCenter - self.cCenter)/self.cSize;
    attribute.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    return attribute;
}


#pragma mark Rotation Flow Layout --- 1
- (UICollectionViewLayoutAttributes*)rotation1WithAttribute:(UICollectionViewLayoutAttributes *)attribute{
    CGFloat rotation = (self.cCenter - self.aCenter)/self.cSize;
    rotation = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? -rotation : rotation;
    attribute.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/4 * rotation);
    return attribute;
}

#pragma mark Rotation Flow Laout --- 2
- (UICollectionViewLayoutAttributes *)rotation2WithAttribute:(UICollectionViewLayoutAttributes *)attribute{
    CGFloat rotation = (self.cCenter - self.aCenter)/self.cSize;
    CATransform3D tran3D = CATransform3DIdentity;
    tran3D.m34 = -0.002;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        attribute.transform3D = CATransform3DRotate(tran3D, M_PI * 3/4 * rotation, 0.5, 1, 0);
    }else {
        attribute.transform3D = CATransform3DRotate(tran3D, M_PI * 3/4 * rotation, 1, 0.5, 0);
    }
    return attribute;
}

#pragma mark Rotation Flow Laout --- 3
- (UICollectionViewLayoutAttributes *)rotation3WithAttribute:(UICollectionViewLayoutAttributes *)attribute{
    CGFloat rotation = (self.cCenter - self.aCenter)/self.cSize;
    CATransform3D tran3D = CATransform3DIdentity;
    tran3D.m34 = -0.002;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        attribute.transform3D = CATransform3DRotate(tran3D, M_PI/2 * rotation, 0, 1, 0);
    }else {
        attribute.transform3D= CATransform3DRotate(tran3D, M_PI/2 * rotation, 1, 0, 0);
    }
    return attribute;
}
@end












