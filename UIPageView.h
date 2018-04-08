//
//  UIPageView.h
//  alphaegg
//
//  Created by MAC20151009A on 2018/1/9.
//  Copyright © 2018年 cn.orangelab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIPageViewDelegate;

@interface UIPageView : UIView
@property (assign, nonatomic) BOOL isAutoScroll;// 是否是自动轮播
@property (weak, nonatomic) id <UIPageViewDelegate>delegate;
- (void)initPageView;
- (void)reloadData;
@end

@protocol UIPageViewDelegate<NSObject>
// 一共有多少个view在轮播
- (NSInteger)numberOfPage:(UIPageView *)pageView;
// 返回每个轮播的view
- (UIView *)pageView:(UIPageView *)pageView viewAtIndex:(NSInteger)index;
@optional
// 点击单个页面回调
- (void)pageView:(UIPageView *)pageView didSelectRowAtIndex:(NSInteger)index;
// 当前展示的页面发生变化时回调
- (void)pageViewDidPageChanged:(UIPageView *)pageView newPage:(NSInteger)newPage;
@end
