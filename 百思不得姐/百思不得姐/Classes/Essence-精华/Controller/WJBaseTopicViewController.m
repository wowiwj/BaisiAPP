//
//  WJBaseTopicViewController.m
//  百思不得姐
//
//  Created by wangju on 16/3/24.
//  Copyright © 2016年 wangju. All rights reserved.
//

#import "WJBaseTopicViewController.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import "WJTopic.h"
#import "WJTopicCell.h"
#import "WJCommentViewController.h"

@interface WJBaseTopicViewController ()

@property (nonatomic,strong) AFHTTPSessionManager *manager;
/**加载帖子的数据*/
@property (nonatomic,strong) NSMutableArray *list;

/*加载帖子的Maxtime*/
@property (nonatomic,strong) NSString *maxtime;

/** 记录上一次的请求 */
@property (nonatomic,strong) NSMutableDictionary *parmas;
@end

static NSString * cellID = @"TopicCell";

@implementation WJBaseTopicViewController
- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
    
}

- (NSMutableArray *)list
{
    if (_list == nil) {
        _list = [NSMutableArray array];
    }
    
    return _list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewController];
    
    [self setupRefresh];
    
}


- (void)setupRefresh
{
    //顶部刷新条
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    
    //改变下拉刷新的透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    //底部刷新条
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    self.tableView.mj_footer.hidden = YES;
    
}

- (void)loadNewTopics
{
    self.maxtime = nil;
    
    [self.list removeAllObjects];
    [self loadMoreTopics];
    
}

- (NSString *)listType
{
    
    //childController.tabBarItem.title
    if ([self.navigationController.tabBarItem.title isEqualToString:@"精华"]) {
        return @"list";
    }
    else
    {
        return @"newlist";
    }

}

- (void)loadMoreTopics
{
    
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    parmas[@"a"] = [self listType];
    parmas[@"c"] = @"data";
    parmas[@"maxtime"] = self.maxtime;
    parmas[@"type"] = @(self.type);
    self.parmas = parmas;
    
    [self.manager GET:BSURL parameters:parmas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        
        [self.list addObjectsFromArray:[WJTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (parmas != self.parmas) return;
        
        [self.tableView reloadData];
        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)setupViewController
{
    
    self.view.backgroundColor = [UIColor clearColor];

    
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame) + WJTitleViewHeight;
    CGFloat bottom = self.tabBarController.tabBar.height;
    
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WJTopicCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.tableView.mj_footer.hidden = (self.list.count == 0);
    return self.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    WJTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    WJTopic *topic = self.list[indexPath.row];
    cell.topic = topic;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJTopic *topic = self.list[indexPath.row];

    return topic.rowHeight;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJTopic *topic = self.list[indexPath.row];
    WJCommentViewController *cmtVc = [[WJCommentViewController alloc] init];
    
    cmtVc.topic = topic;
    
    [self.navigationController pushViewController:cmtVc animated:YES];
    

}

@end
