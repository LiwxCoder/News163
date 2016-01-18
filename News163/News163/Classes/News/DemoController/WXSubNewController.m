//
//  WXSubNewController.m
//  News163
//
//  Created by 李伟雄 on 16/1/15.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import "WXSubNewController.h"
#import "TopLineViewController.h"
#import "HotViewController.h"
#import "VideoViewController.h"
#import "ScoietyViewController.h"
#import "ReaderViewController.h"
#import "ScienceViewController.h"

@implementation WXSubNewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 添加子控制器
    [self setupAllChildViewController];
    
}


/** 添加子控制器 */
- (void)setupAllChildViewController {
    
    // 头条
    TopLineViewController *topLineVc = [[TopLineViewController alloc] init];
    // 保存对应按钮的标题
    topLineVc.title = @"头条";
    [self addChildViewController:topLineVc];
    
    // 热点
    HotViewController *hotVc = [[HotViewController alloc] init];
    hotVc.title = @"热点";
    [self addChildViewController:hotVc];
    
    // 视频
    VideoViewController *videoVc = [[VideoViewController alloc] init];
    videoVc.title = @"视频";
    [self addChildViewController:videoVc];
    
    // 社会
    ScoietyViewController *scoietyVc = [[ScoietyViewController alloc] init];
    scoietyVc.title = @"社会";
    [self addChildViewController:scoietyVc];
    
    // 订阅
    ReaderViewController *readerVc = [[ReaderViewController alloc] init];
    readerVc.title = @"订阅";
    [self addChildViewController:readerVc];
    
    // 科技
    ScienceViewController *scienceVc = [[ScienceViewController alloc] init];
    scienceVc.title = @"科技";
    [self addChildViewController:scienceVc];
    
}


@end
