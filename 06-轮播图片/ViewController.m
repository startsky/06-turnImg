//
//  ViewController.m
//  06-轮播图片
//
//  Created by 1 on 16/1/6.
//  Copyright © 2016年 1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIPageControl *pageControl;
@property(nonatomic,strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i< 5; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"img_%02d",i+1]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
        imageView.image = img;
        
        [self.scrollView addSubview:imageView];
    }
    //计算imageView的位置
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * stop) {
        CGRect frame = imageView.frame;
        frame.origin.x = idx*imageView.frame.size.width;
        imageView.frame = frame;
    }];
    
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * 5, 0);
//    UIPageControl *pageConl = [[UIPageControl alloc] init];
//    CGSize pageConlSize = [[UIPageControl alloc] sizeForNumberOfPages:5];
////    UIPageControl *pageConl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.center.x, 130, pageConlSize.width, pageConlSize.height)];
//    pageConl.bounds = CGRectMake(0, 0, pageConlSize.width, pageConlSize.height);
//    pageConl.center = CGPointMake(self.view.center.x, 130);
//    
//    pageConl.numberOfPages = 5;
//    pageConl.currentPageIndicatorTintColor = [UIColor redColor];
//    pageConl.pageIndicatorTintColor = [UIColor blackColor];
//    pageConl.currentPage = 0;
//    [self.view addSubview:pageConl];
    
    
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self startTimer];
}

-(UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        CGSize pageConlSize = [[UIPageControl alloc] sizeForNumberOfPages:5];
        //    UIPageControl *pageConl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.center.x, 130, pageConlSize.width, pageConlSize.height)];
        _pageControl.bounds = CGRectMake(0, 0, pageConlSize.width, pageConlSize.height);
        _pageControl.center = CGPointMake(self.view.center.x, 130);
        
        _pageControl.numberOfPages = 5;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        
        [self.view addSubview:_pageControl];
    }
    return _pageControl;
}

- (void) startTimer
{
    //此方法创建默认的运行循环
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updatePage) userInfo:nil repeats:YES];
    
    //此方法创建的timer要将其添加进运行循环中去
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(updatePage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)updatePage
{
    int page = (self.pageControl.currentPage+1) % 5;
    self.pageControl.currentPage = page;
    [self pageChanged:self.pageControl];
}

- (void) pageChanged:(UIPageControl *) page
{
    //通过pageControl的当前页数来获得当前scrollView的偏移量
    CGFloat x = page.currentPage * self.scrollView.bounds.size.width;
    self.scrollView.contentOffset = CGPointMake(x, 0);
}

-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 20, 300, 130)];
        
        //设置分页
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * 5, 0);
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        _scrollView.delegate = self;
//        _scrollView.backgroundColor = [UIColor blueColor];
        
//        _scrollView.contentOffset = CGPointMake(300, 0);
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //在拖拽图片的时候将时钟timer停止，invalidate是唯一停止时钟的方法，调用了此方法要重新实例化timer
    [self.timer invalidate];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    //计算图片的偏移量得到图片的当前页数，然后将页数复制给self.pageControl.currentPage，因此改变pagecontrol的页数
    int currentImg = scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    
    self.pageControl.currentPage = currentImg;
    
    //重启timer
    [self startTimer];
}
@end
