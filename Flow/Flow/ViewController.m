//
//  ViewController.m
//  Flow
//
//  Created by ldj on 16/5/31.
//  Copyright © 2016年 ldj. All rights reserved.
//

#import "ViewController.h"
#import "ZDWateLayout.h"
@interface ViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else
    {
        return 20;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        view.backgroundColor = [UIColor blueColor];
    }
    return view;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        
        ZDWateLayout *layout = [[ZDWateLayout alloc] init];
        [layout setHeightCell:^CGFloat(ZDWateLayout *layout, NSIndexPath *indexPath) {
            if (indexPath.section == 0)
            {
                return 375/2 -5;
            }else{
                if (indexPath.row == 0) {
                    return 100;
                }else
                {
                    return 200;
                }
            }
        }];
        
        [layout setHeaderViewSize:^CGSize(ZDWateLayout *layout, NSInteger index) {
            if (index == 0)
            {
                return CGSizeMake(375, 250);
            }else{
                return CGSizeMake(375, 100);
            }
        }];
        
        
        [layout setRowSpace:^CGFloat(ZDWateLayout *layout, NSInteger index) {
            if (index == 0)
            {
                return 20;
            }else{
                return 5;
            }
        }];
        
        [layout setColSpace:^CGFloat(ZDWateLayout *layout, NSInteger index) {
            if (index == 0)
            {
                return 20;
            }else{
                return 5;
            }
        }];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    return _collectionView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
