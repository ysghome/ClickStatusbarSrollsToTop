//
//  SGScrollManager.h
//  SGClickStatusbarSrollsToTop
//
//  Created by ysghome on 4/28/16.
//  Copyright © 2016 ysghome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SGSCROLLMANAGER [SGScrollManager sharedScrollManager]

/**
 *  滚动的方向 手指的方向 （和滚动视图的方向相反）
 */
typedef NS_ENUM(NSInteger , SG_ScrollDirection) {
    /**
     *  向上滚动
     */
    SG_ScrollDirectionTop,
    /**
     *  向下滚动
     */
    SG_ScrollDirectionBottom,
    /**
     *  向左滚动
     */
    SG_ScrollDirectionLeading,
    /**
     *  向右滚动
     */
    SG_ScrollDirectionTrailing,
};

/**
 *  拖拽滚动的时候
 *
 *  @param sg_scrollDirection 滚动方向
 */
typedef void(^SG_ScrollingBlock)(SG_ScrollDirection sg_scrollDirection);

/**
 *  滚动的时候
 *
 *  @param sg_scrollDirection 滚动方向
 */
typedef void(^SG_DidScrollBlock)(SG_ScrollDirection sg_scrollDirection);

@interface SGScrollManager : NSObject

+ (instancetype)sharedScrollManager;

/**
 *  拖拽滚动的时候
 */
- (void)handldSG_ScrollingDelegate:(UIScrollView *)sg_scrollView withBlock:(SG_ScrollingBlock)sg_scrollingBlock;

/**
 *  滚动的时候
 */
- (void)handldSG_DidScrollDelegate:(UIScrollView *)sg_scrollView withBlock:(SG_DidScrollBlock)sg_didScrollBlock;

@end
