//
//  UIPageViewCell.m
//  alphaegg
//
//  Created by MAC20151009A on 2018/1/9.
//  Copyright © 2018年 cn.orangelab. All rights reserved.
//

#import "UIPageViewCell.h"

@interface UIPageViewCell()
@property (strong, nonatomic) UIView *viewContent;
@end

@implementation UIPageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)configCellWithView:(UIView *)view
{
    if (self.viewContent != nil)
    {
        [self.viewContent removeFromSuperview];
    }
    self.viewContent = view;
    [self addSubview:self.viewContent];
    self.viewContent.translatesAutoresizingMaskIntoConstraints = NO;
    // 2.1顶部约束
    NSLayoutConstraint *topCos = [NSLayoutConstraint constraintWithItem:self.viewContent attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self addConstraint:topCos];
    
    // 2.1左边约束
    NSLayoutConstraint *leftCos = [NSLayoutConstraint constraintWithItem:self.viewContent attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self addConstraint:leftCos];
    
    // 2.1底部约束
    NSLayoutConstraint *bottomCos = [NSLayoutConstraint constraintWithItem:self.viewContent attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:bottomCos];
    
    // 2.1右边约束
    NSLayoutConstraint *rightCos = [NSLayoutConstraint constraintWithItem:self.viewContent attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraint:rightCos];
}



@end
