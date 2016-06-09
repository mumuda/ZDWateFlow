//
//  ZDWateLayout.h
//  Test
//
//  Created by ldj on 16/5/19.
//  Copyright © 2016年 ldj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDWateLayout : UICollectionViewLayout


/**  设置上下左右的间距*/
@property (nonatomic,assign) UIEdgeInsets edgeInsets;



/**
 *  必须实现
 */
// 获取cell的高度
@property (nonatomic,copy) CGFloat(^heightCell)(ZDWateLayout *layout,NSIndexPath *indexPath);

/**
 *  选择实现
 */
// 设置每组列数，默认为2
@property (nonatomic,copy) NSInteger(^numberOfColumns)(ZDWateLayout *layout,NSInteger index);

// 设置头视图的大小
@property (nonatomic,copy) CGSize(^headerViewSize)(ZDWateLayout *layout,NSInteger index);

// 设置尾视图的大小
@property (nonatomic,copy) CGSize(^footerViewSize)(ZDWateLayout *layout,NSInteger index);

/** 设置每组每行间距*/
@property (nonatomic,copy) CGFloat(^rowSpace)(ZDWateLayout *layout,NSInteger index);

/**  设置每组每列间距*/
@property (nonatomic,copy) CGFloat(^colSpace)(ZDWateLayout *layout,NSInteger index);


@end
