# 瀑布流，可定义头部尾部，每组间距

![](https://github.com/mumuda/ZDWateFlow/blob/master/ZDWateFlow.gif)  


##使用方法
1. 将`ZDWateLayout.h` 和 `ZDWateLayout.m` 导入到你的项目
2. 在创建collectionView的时候使用<br>`ZDWateLayout *layout = [[ZDWateLayout alloc] init];`<br>代替<br>`UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];`
3. 实现一下方法<br>

```objective-c

/********必须实现************/

// 获取cell的高度
@property (nonatomic,copy) CGFloat(^heightCell)(ZDWateLayout *layout,NSIndexPath *indexPath);

/********选择实现************/

// 设置每组列数，默认为2
@property (nonatomic,copy) NSInteger(^numberOfColumns)(ZDWateLayout *layout,NSInteger index);

// 设置头视图的大小
@property (nonatomic,copy) CGSize(^headerViewSize)(ZDWateLayout *layout,NSInteger index);

// 设置尾视图的大小
@property (nonatomic,copy) CGSize(^footerViewSize)(ZDWateLayout *layout,NSInteger index);

//设置每组每行间距
@property (nonatomic,copy) CGFloat(^rowSpace)(ZDWateLayout *layout,NSInteger index);

//设置每组每列间距
@property (nonatomic,copy) CGFloat(^colSpace)(ZDWateLayout *layout,NSInteger index);

```


[回到顶部](#readme)