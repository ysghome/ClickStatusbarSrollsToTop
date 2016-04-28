//
//  SGScrollManager.m
//  SGClickStatusbarSrollsToTop
//
//  Created by ysghome on 4/28/16.
//  Copyright © 2016 ysghome. All rights reserved.
//

#import "SGScrollManager.h"

@interface SGScrollManager () <UIScrollViewDelegate>

@property (nonatomic, weak) id<UIScrollViewDelegate> sg_delegate;

/**
 *  滚动视图开始滚动的位置
 */
@property (nonatomic, assign) CGPoint sg_contentOffset;

/**
 *  上一次滚动视图的位置
 */
@property (nonatomic, assign) CGPoint sg_oldContentOffset;

/**
 *  这一次滚动后的位置
 */
@property (nonatomic, assign) CGPoint sg_newContentOffset;

@property (nonatomic, copy) SG_ScrollingBlock sg_scrollingBlock;

@property (nonatomic, copy) SG_DidScrollBlock sg_didScrollBlock;

@end

@implementation SGScrollManager

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
+ (instancetype)sharedScrollManager {
    static SGScrollManager *_sharedScrollManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedScrollManager = [[self alloc] init];
    });
    
    return _sharedScrollManager;
}

- (void)handldSG_ScrollingDelegate:(UIScrollView *)sg_scrollView withBlock:(SG_ScrollingBlock)sg_scrollingBlock {
    sg_scrollView.delegate = self;
    self.sg_scrollingBlock = sg_scrollingBlock;
}

- (void)handldSG_DidScrollDelegate:(UIScrollView *)sg_scrollView withBlock:(SG_DidScrollBlock)sg_didScrollBlock {
    sg_scrollView.delegate = self;
    self.sg_didScrollBlock = sg_didScrollBlock;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.sg_contentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.sg_newContentOffset = scrollView.contentOffset;
    
    if (self.sg_newContentOffset.y > self.sg_oldContentOffset.y  && self.sg_oldContentOffset.y > self.sg_contentOffset.y) {// 向上滚动
        [self handldSG_DidScrollAction:SG_ScrollDirectionTop];
    } else if (self.sg_newContentOffset.y < self.sg_oldContentOffset.y && self.sg_oldContentOffset.y < self.sg_contentOffset.y) { // 向下滚动
        [self handldSG_DidScrollAction:SG_ScrollDirectionBottom];
    }  else if (self.sg_newContentOffset.x > self.sg_oldContentOffset.x && self.sg_oldContentOffset.x > self.sg_contentOffset.x) { // 向左滚动
        [self handldSG_DidScrollAction:SG_ScrollDirectionLeading];
    }  else if (self.sg_newContentOffset.x < self.sg_oldContentOffset.x && self.sg_oldContentOffset.x < self.sg_contentOffset.x) { // 向右滚动
        [self handldSG_DidScrollAction:SG_ScrollDirectionTrailing];
    } else {
        //                    NSLog(@"dragging");
    }
    if (scrollView.dragging) {  // 拖拽
        if ((scrollView.contentOffset.y - self.sg_contentOffset.y) > 5.0f) {  // 向上拖拽
            [self handldSG_ScrollingAction:SG_ScrollDirectionTop];
        } else if ((self.sg_contentOffset.y - scrollView.contentOffset.y) > 5.0f) {   // 向下拖拽
            [self handldSG_ScrollingAction:SG_ScrollDirectionBottom];
        } else if ((scrollView.contentOffset.x - self.sg_contentOffset.x) > 5.0f) {  // 向左拖拽
            [self handldSG_ScrollingAction:SG_ScrollDirectionLeading];
        } else if ((self.sg_contentOffset.x - scrollView.contentOffset.x) > 5.0f) {   // 向右拖拽
            [self handldSG_ScrollingAction:SG_ScrollDirectionTrailing];
        } else {}
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.sg_oldContentOffset = scrollView.contentOffset;
}

/**
 *  滚动
 */
- (void)handldSG_DidScrollAction:(SG_ScrollDirection)sg_scrollDirection {
    if (self.sg_didScrollBlock) {
        self.sg_didScrollBlock(sg_scrollDirection);
    }
}
/**
 *  拖拽
 */
- (void)handldSG_ScrollingAction:(SG_ScrollDirection)sg_scrollDirection {
    if (self.sg_scrollingBlock) {
        self.sg_scrollingBlock(sg_scrollDirection);
    }
}

@end
