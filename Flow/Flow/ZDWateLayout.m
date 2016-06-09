//
//  ZDWateLayout.m
//  Test
//
//  Created by ldj on 16/5/19.
//  Copyright © 2016年 ldj. All rights reserved.
//

#import "ZDWateLayout.h"

@interface ZDWateLayout()

/**  列的高度数组*/
@property (nonatomic,strong) NSMutableArray *heightArray;

/**  item的属性*/
@property (nonatomic,strong) NSMutableArray *attributesArray;

/**  内容视图的高度*/
@property (nonatomic,assign) CGFloat contentViewHeight;

@end

@implementation ZDWateLayout

// 需要了解的是，在初始化一个UICollectionViewLayout实例后，会有一系列准备方法被自动调用，以保证layout实例的正确
// 首先,-(void)prepareLayout将被调用，默认下该方法什么没做，但是在自己的子类实现中，一般在该方法中设定一些必要的layout的结构和初始需要的参数等。
- (void)prepareLayout
{
    [super prepareLayout];
    [self calculateData];
}

#pragma mark - Private Methods
#pragma mark -- 计算item的属性
- (void)calculateData
{
    
    /** 删除所有元素*/
    [self.attributesArray removeAllObjects];
    
    /** 计算内容视图的初始高度*/
    self.contentViewHeight = self.edgeInsets.top;
    
    /** 获取section的个数*/
    for (NSInteger i = 0; i < [self.collectionView numberOfSections]; i++)
    {
        /** 初始化行高*/
        [self initHeightArrayData:i];

        if ([self headerSizeIndex:i].height > 0)
        {
            [self.attributesArray addObject: [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]]];
        }
        
        /** 获取每个section里面item的个数*/
        for (NSInteger j = 0; j < [self.collectionView numberOfItemsInSection:i] ; j++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            [self.attributesArray addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
        self.contentViewHeight = [self maxColnmuHeight];
        if ([self footerSizeIndex:i].height > 0)
        {
            [self.attributesArray addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]]];
        }
    }
    
}

#pragma mark -- 初始化每组行高
- (void)initHeightArrayData:(NSInteger)index
{
    if (index == 0)
    {
        [self.heightArray removeAllObjects];
        for (NSInteger i = 0; i < [self columnsByIndex:i]; i++)
        {
            [self.heightArray addObject:@(self.edgeInsets.top)];
        }
    }
    
    if ([self headerSizeIndex:index].height != 0 || [self footerSizeIndex:index].height != 0)
    {
        NSNumber *number = @([self maxColnmuHeight]);
        [self.heightArray removeAllObjects];
        for (int i = 0; i < [self columnsByIndex:index]; i++)
        {
            [self.heightArray addObject:number];
        }
    }
}

#pragma mark -- 获取最大列高
- (CGFloat)maxColnmuHeight
{
    CGFloat maxColnumHeight = [[self.heightArray firstObject] doubleValue];
    for (NSInteger i = 0; i < self.heightArray.count; i++)
    {
        if (maxColnumHeight < [[self.heightArray objectAtIndex:i] doubleValue])
        {
            maxColnumHeight = [[self.heightArray objectAtIndex:i] doubleValue];
        }
    }
    return maxColnumHeight;
}

#pragma mark -- 获取最短列数
- (NSInteger)mixColnmuIndex
{
    NSInteger minColnumIndex = 0;
    CGFloat mixColnumHeight = [[self.heightArray firstObject] doubleValue];
    for (NSInteger i = 0; i < self.heightArray.count; i++)
    {
        if (mixColnumHeight > [[self.heightArray objectAtIndex:i] doubleValue])
        {
            mixColnumHeight = [[self.heightArray objectAtIndex:i] doubleValue];
            minColnumIndex = i;
        }
    }
    return minColnumIndex;
}

#pragma mark -- 变化所有的行高
/** 变化所有的行高 */
- (void)changeAllHeightArray:(CGFloat)height{
    NSInteger count = self.heightArray.count;
    [self.heightArray removeAllObjects];
    for (NSInteger i = 0; i < count; i ++) {
        [self.heightArray addObject:@(height)];
    }
}
// 其次,-(CGSize) collectionViewContentSize将被调用，以确定collection应该占据的尺寸。注意这里的尺寸不是指可视部分的尺寸，而应该是所有内容所占的尺寸。collectionView的本质是一个scrollView，因此需要这个尺寸来配置滚动行为。
- (CGSize)collectionViewContentSize{
    return CGSizeMake(self.collectionView.frame.size.width, self.contentViewHeight + self.edgeInsets.bottom);
}

// 接下来-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect被调用，这个没什么值得多说的。初始的layout的外观将由该方法返回的UICollectionViewLayoutAttributes来决定
/**
 *  返回rect中的所有的元素的布局属性
 *  返回的是包含UICollectionViewLayoutAttributes的NSArray
 *   UICollectionViewLayoutAttributes可以是cell，追加视图或装饰视图的信息，通过不同的UICollectionViewLayoutAttributes初始化方法可以得到不同类型的
 *   UICollectionViewLayoutAttributes：
 *   layoutAttributesForCellWithIndexPath:
 *   layoutAttributesForSupplementaryViewOfKind:withIndexPath:
 *   layoutAttributesForDecorationViewOfKind:withIndexPath:
 */

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributesArray;
}

// return: YES : 表示一旦滑动就实时调用上面的layoutAttributesForElementsInRect方法
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

// 返回对应于indexPath的位置的cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /** 获取item的高*/
    CGFloat itemHeight = self.heightCell(self,indexPath);
    CGFloat rowSpace = [self rowSpace:indexPath.section];
    CGFloat colSpace = [self colSpace:indexPath.section];
    /** 获取item的宽*/
    CGFloat itemWidth = (self.collectionView.bounds.size.width - self.edgeInsets.left - self.edgeInsets.right - colSpace * ([self columnsByIndex:indexPath.section] - 1))/[self columnsByIndex:indexPath.section];
    
    /** 获取行高最小的列*/
    NSInteger minColumensIndex = [self mixColnmuIndex];
    CGFloat itemOfX = self.edgeInsets.left + minColumensIndex * (colSpace + itemWidth);
    CGFloat itemOfY = 0;
    if (itemOfY != self.edgeInsets.top + [self headerSizeIndex:indexPath.section].height)
    {
        itemOfY = [[self.heightArray objectAtIndex:minColumensIndex] doubleValue] + rowSpace;
    }else
    {
        itemOfY = [[self.heightArray objectAtIndex:minColumensIndex] doubleValue] + self.edgeInsets.top;
    }
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    layoutAttributes.frame = CGRectMake(itemOfX, itemOfY, itemWidth, itemHeight);
    
    /** 更新最大行高*/
    self.heightArray[minColumensIndex] = @(CGRectGetMaxY(layoutAttributes.frame));
    return layoutAttributes;
}

// 返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    CGFloat viewOfY = self.contentViewHeight;
    CGFloat rowSpace = [self rowSpace:indexPath.section];
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader])
    {
        size = [self headerSizeIndex:indexPath.section];
    }else
    {
        size = [self footerSizeIndex:indexPath.section];
        viewOfY += rowSpace;
    }
    
    self.contentViewHeight += size.height;
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    layoutAttributes.frame = CGRectMake(0, viewOfY, size.width, size.height);
    
    if ([self headerSizeIndex:indexPath.section].height != 0 || [self footerSizeIndex:indexPath.section].height != 0)
    {
        [self changeAllHeightArray:self.contentViewHeight];
    }
    
    return layoutAttributes;
}

// 返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}

#pragma mark - Getter
- (NSMutableArray *)heightArray
{
    if (_heightArray == nil)
    {
        _heightArray = [[NSMutableArray alloc] init];
    }
    return _heightArray;
}

- (NSMutableArray *)attributesArray
{
    if (_attributesArray == nil)
    {
        _attributesArray = [[NSMutableArray alloc] init];
    }
    return _attributesArray;
}


- (NSInteger)columnsByIndex:(NSInteger)index
{
    if (self.numberOfColumns)
    {
        return self.numberOfColumns(self,index);
    }else{
        return 2;
    }
}

/** 获取section的头视图 */
- (CGSize)headerSizeIndex:(NSInteger)index
{
    if (self.headerViewSize)
    {
        return self.headerViewSize(self,index);
    }
    return CGSizeMake(0, 0);
}

/** 获取section的尾视图 */
- (CGSize)footerSizeIndex:(NSInteger)index {
    if (self.footerViewSize)
    {
        return self.footerViewSize(self,index);
    }
    return CGSizeMake(0, 0);
}

- (CGFloat)rowSpace:(NSInteger)index{
    if (self.rowSpace) {
        return self.rowSpace(self,index);
    }
    return 5;
}

- (CGFloat)colSpace:(NSInteger)index{
    if (self.colSpace) {
        return self.colSpace(self,index);
    }
    return 5;
}

@end
