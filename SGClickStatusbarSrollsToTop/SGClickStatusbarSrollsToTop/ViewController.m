//
//  ViewController.m
//  SGClickStatusbarSrollsToTop
//
//  Created by ysghome on 4/8/16.
//  Copyright © 2016 ysghome. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *pageTableView1;

@property (weak, nonatomic) IBOutlet UITableView *pageTableView2;

@property (weak, nonatomic) IBOutlet UITableView *pageTableView3;

@property (weak, nonatomic) IBOutlet UIScrollView *contentView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //设置默认
    [self closeAllScrollsToTopAndOpen:self.pageTableView1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePageAction:(UISegmentedControl *)sender {
    NSUInteger pageIndex = self.contentView.contentOffset.x/self.contentView.frame.size.width;
    if (pageIndex != sender.selectedSegmentIndex) {
        self.contentView.contentOffset = CGPointMake(sender.selectedSegmentIndex * self.contentView.frame.size.width, 0);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.contentView) {
        NSUInteger pageIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
        self.segmentedControl.selectedSegmentIndex = pageIndex;
        UIScrollView *openScrollview;
        if (pageIndex == 0) {
            openScrollview = self.pageTableView1;
        } else if (pageIndex == 1) {
            openScrollview = self.pageTableView2;
        } else if (pageIndex == 2) {
            openScrollview = self.pageTableView3;
        }
        [self closeAllScrollsToTopAndOpen:openScrollview];
    }
}

/**
 *  关闭掉所有的滚动视图的 scrollsToTop 属性 只开启当前显示的滚动视图的 scrollsToTop
 *
 *  重点：视图控制器中有其他的 UIScrollView 这些的 scrollsToTop 也需要设置为 NO，不然就会没有效果
 *
 *  @param openScrollview 当前显示的滚动视图
 */
- (void)closeAllScrollsToTopAndOpen:(UIScrollView *)openScrollview{
    self.contentView.scrollsToTop = NO;
    self.pageTableView1.scrollsToTop = NO;
    self.pageTableView2.scrollsToTop = NO;
    self.pageTableView3.scrollsToTop = NO;
    openScrollview.scrollsToTop = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *aCell =@"aCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:aCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"测试数据。第-- %@ --行",@(indexPath.row)];
    
    return cell;
}

@end
