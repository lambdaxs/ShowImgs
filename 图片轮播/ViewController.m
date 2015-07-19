//
//  ViewController.m
//  图片轮播
//
//  Created by xiaos on 15/6/29.
//  Copyright (c) 2015年 com.xsdota. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageCtrl;
@property (nonatomic,strong) NSTimer *imgTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //图片总数
    int imgCount = 5;
    CGFloat scrollWidth = self.scrollView.frame.size.width;
    CGFloat scrollHeight = self.scrollView.frame.size.height;
    
    //动态生成图片视图，添加到滑动视图上
    for (int i = 0; i < imgCount; i++) {
        CGFloat x = i * scrollWidth;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [self.scrollView addSubview:imgView];
        imgView.frame = CGRectMake(x, 0, scrollWidth, scrollHeight);
        NSString *imgName = [NSString stringWithFormat:@"img_%02d",i+1];
        imgView.image = [UIImage imageNamed:imgName];
    }

    //设置滑动视图的属性
    self.scrollView.delegate = self;
    //滑动范围
    self.scrollView.contentSize = CGSizeMake(imgCount * scrollWidth, 0);
    //是否分页
    self.scrollView.pagingEnabled = YES;
    //隐藏横向滑动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    //设置pagecontrol
    self.pageCtrl.numberOfPages = imgCount;
    //添加计时器
    [self createTimer];
}

//轮播图片
- (void) nextImg
{
    NSInteger page = self.pageCtrl.currentPage;
    
    if (page == self.pageCtrl.numberOfPages - 1) {
        page = 0;
    }else {
        page++;
    }
    
    CGFloat offSet = page * self.scrollView.frame.size.width;
    
    //切换图片的动画
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(offSet, 0);
    }];
    
}

//创建一个计时器
- (void) createTimer
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:4.5 target:self selector:@selector(nextImg) userInfo:nil repeats:YES];
    self.imgTimer = timer;
    //设置异步循环
    NSRunLoop *run = [NSRunLoop currentRunLoop];
    [run addTimer:timer forMode:NSRunLoopCommonModes];

}

#pragma mark --- scroll的代理方法
//滑动超过图片宽度的1/2就page++
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat imgWidth = self.scrollView.frame.size.width;
    CGFloat index = (self.scrollView.contentOffset.x + imgWidth/2)/imgWidth;
    self.pageCtrl.currentPage = index;
}

//当抓住图片时，停止计时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.imgTimer invalidate];
}

//当松开图片时，新建一个轮播图片的异步计时器
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self createTimer];
    
}



@end
