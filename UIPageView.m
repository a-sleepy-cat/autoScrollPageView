//
//  UIPageView.m
//  alphaegg
//
//  Created by MAC20151009A on 2018/1/9.
//  Copyright © 2018年 cn.orangelab. All rights reserved.
//

#import "UIPageView.h"
#import "UIPageViewCell.h"

#define IDENTIFIER_OF_CELL (@"IDENTIFIER_OF_CELL")
#define TIME_OF_PER_PAGE (5)

@interface UIPageView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *arrayViewsToShow;
@property (strong, nonatomic) NSTimer *timerOfUpdatePageView;
@end
@implementation UIPageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)initPageView
{
    // 数据初始化
    self.arrayViewsToShow = [self getViewsToShow];
    [self layoutIfNeeded];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (self.collectionView == nil)
    {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([UIPageViewCell class]) bundle:nil] forCellWithReuseIdentifier:IDENTIFIER_OF_CELL];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.pagingEnabled = YES;
        self.collectionView.bounces = NO;
        [self addSubview:self.collectionView];
        // 添加约束
        self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        // 顶部约束
        NSLayoutConstraint *topCos = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [self addConstraint:topCos];
        
        // 左边约束
        NSLayoutConstraint *leftCos = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [self addConstraint:leftCos];
        
        // 底部约束
        NSLayoutConstraint *bottomCos = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [self addConstraint:bottomCos];
        
        // 右边约束
        NSLayoutConstraint *rightCos = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        [self addConstraint:rightCos];
    }
    [self.collectionView reloadData];
    if (self.arrayViewsToShow.count > 1)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    
    if (self.isAutoScroll && self.arrayViewsToShow.count > 3)
    {
        [self startTimerOfUpdatePageView];
        self.collectionView.scrollEnabled = YES;
    }
    else
    {
        [self stopTimerOfUpdatePageView];
        self.collectionView.scrollEnabled = NO;
    }
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

#pragma mark - Private
// 定时轮播
- (void)startTimerOfUpdatePageView
{
    [self stopTimerOfUpdatePageView];
    self.timerOfUpdatePageView = [NSTimer scheduledTimerWithTimeInterval:TIME_OF_PER_PAGE target:self selector:@selector(handleUpdatePageView) userInfo:nil repeats:YES];
}

- (void)handleUpdatePageView
{
    NSInteger curPage = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    NSInteger newPage = curPage + 1;
    if (self.arrayViewsToShow.count > newPage)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:newPage inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

- (void)stopTimerOfUpdatePageView
{
    if (self.timerOfUpdatePageView)
    {
        [self.timerOfUpdatePageView invalidate];
        self.timerOfUpdatePageView = nil;
    }
}

- (NSArray *)getViewsToShow
{
    NSMutableArray *arrayViews = [[NSMutableArray alloc] init];
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfPage:)])
    {
        NSInteger count = [self.delegate numberOfPage:self];
        if ([self.delegate respondsToSelector:@selector(pageView:viewAtIndex:)])
        {
            for (NSInteger i = 0; i < count; i ++)
            {
                UIView *view = [self.delegate pageView:self viewAtIndex:i];
                [arrayViews addObject:view];
            }
            UIView *lastView = [self.delegate pageView:self viewAtIndex:count - 1];
            UIView *firstView = [self.delegate pageView:self viewAtIndex:0];
            if (lastView != nil)
            {
                [arrayViews insertObject:lastView atIndex:0];
            }
            if (firstView != nil)
            {
                [arrayViews addObject:firstView];
            }
        }
    }
    return arrayViews;
}

#pragma mark -ICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayViewsToShow.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIPageViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_OF_CELL forIndexPath:indexPath];
    UIView *view = [self.arrayViewsToShow objectAtIndex:indexPath.row];
    [cell configCellWithView:view];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageView:didSelectRowAtIndex:)])
    {
        NSInteger index = 0;
        if (indexPath.row == 0)
        {
            index = self.arrayViewsToShow.count - 1;
        }
        else if (indexPath.row == self.arrayViewsToShow.count - 1)
        {
            index = 0;
        }
        else
        {
            index = indexPath.row - 1;
        }
        [self.delegate pageView:self didSelectRowAtIndex:index];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = self.collectionView.frame.size;
    NSLog(@"self:%@",self);
    NSLog(@"self.collectionView:%@",self.collectionView);
    return size;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView)
    {
        if (scrollView.contentOffset.x == (self.arrayViewsToShow.count - 1)*(self.frame.size.width))
        {
            
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
        else if (scrollView.contentOffset.x == 0)
        {
            
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(self.arrayViewsToShow.count - 2) inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 当前正在展示的位置
            NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
            NSInteger newPage = 0;
            if (currentIndexPath.row == self.arrayViewsToShow.count - 1)
            {
                newPage = 0;
            }
            else if (currentIndexPath.row == 0)
            {
                newPage = self.arrayViewsToShow.count - 1;
            }
            else
            {
                newPage = currentIndexPath.row - 1;
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewDidPageChanged:newPage:)])
            {
                [self.delegate pageViewDidPageChanged:self newPage:newPage];
            }
        });
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView)
    {
        // 停止自动轮播的定时器
        if (self.isAutoScroll)
        {
            [self stopTimerOfUpdatePageView];
        }
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.collectionView)
    {
        // 开启自动轮播的定时器
        if (self.isAutoScroll && self.arrayViewsToShow.count > 3)
        {
            [self startTimerOfUpdatePageView];
        }
    }
}



@end
