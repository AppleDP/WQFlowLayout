//
//  ViewController.m
//  WQFlowLayout
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 SUWQ. All rights reserved.
//

#import "ViewController.h"
#import "WQLayout.h"

#define sWidth [UIScreen mainScreen].bounds.size.width
#define sHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<UIColor *> *colors;
@end

@implementation ViewController
static NSString * const Cell = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 1.初始化 WQLayout
    WQLayout *layout = [WQLayout createWQLayout];
    
    // 2.动画选择
//    layout.type = WQScaleLayout;
//    layout.type = WQRotationLayout1;
//    layout.type = WQRotationLayout2;
    layout.type = WQRotationLayout3;
    
//    // 3.1 动画方向(垂直)
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.itemSize = CGSizeMake(sWidth/2, sWidth/2 * 4/3);
//    layout.minimumLineSpacing = layout.itemSize.height/4;
//    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, sWidth, sHeight - 64)
//                                             collectionViewLayout:layout];
    
    // 3.2 动画方向(水平)
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(sWidth/2, sWidth/2 * 4/3);
    layout.minimumLineSpacing = 0;//layout.itemSize.height/3;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, sWidth, sHeight/2)
                                             collectionViewLayout:layout];
    self.collectionView.center = self.view.center;
    
    
    
    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:Cell];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

#pragma mark UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Cell
                                                                           forIndexPath:indexPath];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dog.jpg"]];
    return cell;
}
@end









