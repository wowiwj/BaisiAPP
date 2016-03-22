//
//  WJEssenceController.m
//  百思不得姐
//
//  Created by wangju on 16/3/13.
//  Copyright © 2016年 wangju. All rights reserved.
//

#import "WJEssenceController.h"
#import "WJRecommandTagController.h"
#import "WJAllViewController.h"
#import "WJPictureViewController.h"
#import "WJSoundViewController.h"
#import "WJWordViewController.h"
#import "WJVideoViewController.h"

@interface WJEssenceController ()<UIScrollViewDelegate>


/*标题栏底部的指示器*/
@property (nonatomic,weak) UIView *indicatorView;

/*选中的按钮*/
@property (nonatomic,weak) UIButton *selButton;

/*指示条*/
@property (nonatomic,weak) UIView *titleView;

/*contentView*/
@property (nonatomic,strong) UIScrollView *contentView;


@end

@implementation WJEssenceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildViewControllers];
    //初始化控制器的导航栏和背景
    [self setupNav];

    //初始化导航条下边的指示器
    [self setupTitlesView];
    
    [self setupScrollView];
    
    //默认选中第一个标签
    UIButton *button = [self.titleView viewWithTag:1];
    [button layoutIfNeeded];
    [self titleButtonClicked:button];
  
}

- (void)setupScrollView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *contentView = [[UIScrollView alloc] init];
    
    contentView.frame = self.view.bounds;

    WJLog(@"%@",NSStringFromCGRect(self.view.bounds));

    [self.view insertSubview:contentView atIndex:0];
    
    contentView.contentSize = CGSizeMake(self.childViewControllers.count * contentView.width, 0);
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    self.contentView = contentView;

}

- (void)setupTitlesView
{
    UIView *titleView = [[UIView alloc] init];

    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    titleView.width = self.view.width;
    titleView.height = WJTitleViewHeight;
    titleView.y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
//    titleView.x = 0;
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    //设置底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.y = titleView.height - indicatorView.height;
    [titleView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    //添加按钮
    NSArray *titles = @[@"全部",@"图片",@"声音",@"视频",@"段子"];
    int count = 5;
    CGFloat buttonWidth = titleView.width / count;
    CGFloat buttonHeigth = titleView.height;
    CGFloat buttonY = 0;
    for (int i = 0; i < count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.width = buttonWidth;
        button.height = buttonHeigth;
        button.x = i * button.width;
        button.y = buttonY;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        [titleView addSubview:button];
        [button addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 1;

    }
    
    
}




- (void)titleButtonClicked:(UIButton *)button
{
    self.selButton.enabled = YES;
    button.enabled = NO;
    self.selButton = button;
    [UIView animateWithDuration:0.2f animations:^{
        self.indicatorView.x = button.titleLabel.x + button.x;
        self.indicatorView.width = button.titleLabel.width;
    }];
    
    //让底部的contentView滚动
    CGPoint contentOffset = self.contentView.contentOffset;
    contentOffset.x = (button.tag - 1) * self.contentView.width;
    [self.contentView setContentOffset:contentOffset animated:YES];


    //添加子控制器
    //取出控制器
    UITableViewController *vc = self.childViewControllers[button.tag - 1];
    vc.view.x = self.contentView.contentOffset.x;
    vc.view.y = 0;
    vc.view.height = self.view.height;
    
//    WJLog(@"%@",NSStringFromUIEdgeInsets(vc.tableView.contentInset));
//    CGFloat top = CGRectGetMaxY(self.titleView.frame);
//    CGFloat bottom = self.tabBarController.tabBar.height;
//    WJLog(@"%f",bottom);
//    vc.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
//    vc.tableView.scrollIndicatorInsets = vc.tableView.contentInset;
    [self.contentView addSubview:vc.view];



}


- (void)addChildViewControllers
{
    WJAllViewController *allVc = [[WJAllViewController alloc] init];

    [self addChildViewController:allVc];
    WJPictureViewController *picVc = [[WJPictureViewController alloc] init];
    
    [self addChildViewController:picVc];
    WJSoundViewController *soundVc = [[WJSoundViewController alloc] init];
    
    [self addChildViewController:soundVc];
    WJVideoViewController *videoVc = [[WJVideoViewController alloc] init];
    
    [self addChildViewController:videoVc];
    WJWordViewController *wordVc = [[WJWordViewController alloc] init];
    
    [self addChildViewController:wordVc];

}


- (void)buttonClicked
{
    WJRecommandTagController *tagVc= [[WJRecommandTagController alloc] init];
    [self.navigationController pushViewController:tagVc animated:YES];

}


- (void)setupNav
{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    //    UIView *view = [[UIView alloc] init];
    //    view.backgroundColor = [UIColor yellowColor];
    //    view.width = 200;
    //    view.heigth = 40;
    //    self.navigationItem.titleView = view;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(buttonClicked)];
    
    //设置背景色
    self.view.backgroundColor = WJGlobalBGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    UIButton *selButton = [self.titleView viewWithTag:index + 1];
    
    NSLog(@"%zd",index);
    
    [self titleButtonClicked:selButton];
    WJLogFunc;
}


@end
