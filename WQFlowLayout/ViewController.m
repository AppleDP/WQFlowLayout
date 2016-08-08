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
    WQLayout *layout = [WQLayout createWQLayout];
    layout.type = WQScaleLayout;
    layout.itemSize = CGSizeMake(100, 100);
    layout.minimumLineSpacing = 50;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, sWidth, 200)
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









