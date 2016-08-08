//
//  WQLayout.h
//  WQFlowLayout
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 SUWQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WQScaleLayout,
    WQRotationLayout
}WQLayoutType;

@interface WQLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) WQLayoutType type;

+ (WQLayout *)createWQLayout;
@end
