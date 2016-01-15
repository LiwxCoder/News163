//
//  NewsViewController.m
//  21-网易新闻
//
//  Created by 李伟雄 on 16/1/15.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import "NewsViewController.h"

/**
 01-网易新闻(搭建界面)
 02-网易新闻(设置标题)
 03-网易新闻(处理标题按钮点击)
 04-网易新闻(监听内容滚动)
 05-网易新闻(标题居中处理)
 06-网易新闻(标题文字缩放)
 07-网易新闻(标题文字渐变)
 08-网易新闻(抽取框架)
 */


#define WXColor(r, g, b) [UIColor colorWithRed:(r)  green:(g)  blue:(b) alpha:1]
#define WXScreenW [UIScreen mainScreen].bounds.size.width
#define WXScreenH [UIScreen mainScreen].bounds.size.height

NSInteger const titleScrollViewHeight = 44;


@interface NewsViewController ()<UIScrollViewDelegate>
/** titleScrollView */
@property (nonatomic, weak) UIScrollView *titleScrollView;
/** contentScrollView */
@property (nonatomic, weak) UIScrollView *contentScrollView;

/** 记录当前选中按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 存放按钮的数组 */
@property (nonatomic, strong) NSMutableArray *buttons;

/**  */
@property (nonatomic, assign) BOOL isInitial;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"网易新闻";
    // 1.搭建标题滚动视图
    [self setupTitleScrollView];
    
    // 2.搭建内容滚动视图
    [self setupContentScrollView];
    
    // 4.添加TitleScrollView中所有button,设置标题
    [self setupAllTitle];
    
    // 5.设置contentScrollView和titleScrollView的初始配置信息
    [self setupAllScrollViewSetting];
    
}

// ----------------------------------------------------------------------------
// 初始化设置
#pragma mark - 初始化设置

/** view即将显示的时候调用 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 设置titleBtn的标题
    if (self.isInitial == NO) {
        
        [self setupAllTitle];
        self.isInitial = YES;
    }
    
}

/** 设置contentScrollView和titleScrollView的初始配置信息 */
- (void)setupAllScrollViewSetting {
    
    // 设置contentScrollView的代理
    self.contentScrollView.delegate = self;
    
    // 设置contentScrollView和titleScrollView不添加额外滚动区域,隐藏滚动条,开启分页功能
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.bounces = NO;
    self.contentScrollView.pagingEnabled = YES;
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
}

/** 搭建标题滚动视图 */
- (void)setupTitleScrollView {
    
    // 创建titleScrollView,设置frame,并添加到控制器的view
    UIScrollView *titleScrollView = [[UIScrollView alloc] init];
    titleScrollView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:titleScrollView];
    self.titleScrollView = titleScrollView;
    
    // 设置titleScrollView的frame
    CGFloat y = self.navigationController.navigationBar.hidden ? 20 : 64;
    titleScrollView.frame = CGRectMake(0, y, WXScreenW, 44);
}

/** 搭建内容滚动视图 */
- (void)setupContentScrollView {
    
    // 创建contentScrollView,设置frame,并添加到控制器的view
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    //    contentScrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:contentScrollView];
    self.contentScrollView = contentScrollView;
    
    // 设置titleScrollView的frame
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
    CGFloat h = WXScreenH - y;
    contentScrollView.frame = CGRectMake(0, y, WXScreenW, h);
    
}

/** 添加TitleScrollView中所有button,设置标题 */
- (void)setupAllTitle {
    
    // 1.获取子控制器的个数
    NSInteger count = self.childViewControllers.count;
    CGFloat btnX = 0;
    CGFloat btnW = 100;
    
    // 2.添加按钮,并设置标题
    for (NSInteger i = 0; i < count; i++) {
        // 获取标题
        UIViewController *vc = self.childViewControllers[i];
        NSString *title = vc.title;
        
        // --------------------------------------------------------------------
        // 创建btn,设置frame,添加到titleScrollView上
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        [self.titleScrollView addSubview:btn];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchDown];
        btnX = i * btnW;
        btn.frame = CGRectMake(btnX, 0, btnW, titleScrollViewHeight);
        
        [self.buttons addObject:btn];
        
        // 设置默认选中按钮
        if (i == 0) {
            [self titleButtonClick:btn];
        }
    }
    
    // ------------------------------------------------------------------------
    // 设置_contentScrollView和titleScrollView的contentSize
    self.contentScrollView.contentSize = CGSizeMake(count * WXScreenW, 0);
    self.titleScrollView.contentSize = CGSizeMake(count * btnW, 0);
}

// ----------------------------------------------------------------------------
// 事件处理,按钮的点击事件
#pragma mark - 事件处理

/** 监听标题按钮的点击 */
- (void)titleButtonClick:(UIButton *)btn {
    
    // 1.切换选中状态,修改当前选中的按钮文字颜色
    [self selectedBtn:btn];
    
    // 2.将子控制器的view添加到_contentScrollView对应的位置
    [self setupOneViewControllerView:btn.tag];
    
    // 3.设置_contentScrollView的偏移量
    self.contentScrollView.contentOffset = CGPointMake(btn.tag * WXScreenW, 0);
    
}

/** 将子控制器的view添加到_contentScrollView对应的位置 */
- (void)setupOneViewControllerView:(NSInteger)index {
    
    UIViewController *vc = self.childViewControllers[index];
    // 判断该子控制器的view是否已经添加到当前的控制器view上,如果已添加,则直接退出
    if (vc.view.superview) {
        return;
    }
    // 添加到contentScrollView对应的位置上
    vc.view.frame = CGRectMake(index * WXScreenW, 0, WXScreenW, self.contentScrollView.frame.size.height);
    [self.contentScrollView addSubview:vc.view];
    
}

/** 切换选中状态,修改当前选中的按钮文字颜色 */
- (void)selectedBtn:(UIButton *)btn {
    
    // 还原上一个按钮的字体颜色和字体形变大小
    [self.selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selectedButton.transform = CGAffineTransformIdentity;
    
    // 设置当前选中的按钮的字体颜色和字体形变大小
    self.selectedButton = btn;
    [self.selectedButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.selectedButton.transform = CGAffineTransformMakeScale(1.3, 1.3);
    
    // 当前选中设置按钮标题居中
    [self setupTitleButtonCenter:self.selectedButton];
}

/** 设置当前选中按钮居中 */
- (void)setupTitleButtonCenter:(UIButton *)selectedBtn {
    
    // 偏移量计算 偏移量 = selectedBtn.center.x - self.contentScrollView.frame.size.width * 0.5
    CGFloat offSetX = selectedBtn.center.x - self.contentScrollView.frame.size.width * 0.5;
    
    // 如果计算出来的偏移量小于0,则不偏移,将偏移量置0
    if (offSetX < 0) {
        offSetX = 0;
    }
    
    // 获取最大的x偏移量,如果超过最大偏移量,则偏移到最大偏移量的位置
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - WXScreenW;
    if (offSetX > maxOffsetX) {
        offSetX = maxOffsetX;
    }
    
    // 开始偏移titleScrollView
    [self.titleScrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
}

// ----------------------------------------------------------------------------
// contentScrollView和titleScrollView代理监听
#pragma mark - 代理监听ScrollView的滚动

/** ScrollView滚动的时候调用 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // ------------------------------------------------------------------------
    // 滚动过程中实现标题的文字大小变化(形变),标题文字颜色渐变
    
    // 1.获取左右两个按钮
    // 1.1 获取左右按钮的角标
    NSInteger leftIndex = scrollView.contentOffset.x / WXScreenW;
    NSInteger rightIndex = leftIndex + 1;
    
    // 1.2 获取左右按钮
    UIButton *leftBtn = self.buttons[leftIndex];
    NSUInteger count = self.childViewControllers.count;
    UIButton *rightBtn = nil;
    if (rightIndex < count) {
        rightBtn = self.buttons[rightIndex];
    }
    
    // 2.计算左右按钮缩放的比例
    // 2.1 计算右边按钮的缩放比例
    CGFloat rightScale = scrollView.contentOffset.x / WXScreenW;
    // 2.2 处理左边和右边的比例范围0.0 ~ 1.0
    // 假设rightScale: 0.22 ,leftScale: 0.78
    rightScale = rightScale - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    // 3.改变文字的大小,不是修改字体,修改按钮的形变属性transform
    // 3.1 计算最终要缩放的比例, 将缩放比例0.0 ~ 1.0变成1.0 ~ 1.3
    CGFloat lastRightScale = (rightScale * 0.3) + 1;
    CGFloat lastLeftScale = (leftScale * 0.3) + 1;
    // 3.2 开始缩放左右按钮
    leftBtn.transform = CGAffineTransformMakeScale(lastLeftScale, lastLeftScale);
    rightBtn.transform = CGAffineTransformMakeScale(lastRightScale, lastRightScale);
    
    // 4.设置按钮颜色渐变
    [leftBtn setTitleColor:[UIColor colorWithRed:leftScale green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithRed:rightScale green:0 blue:0 alpha:1] forState:UIControlStateNormal];
}

/** ScrollView减速完成调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 获取按钮的角标
    NSInteger index = scrollView.contentOffset.x / WXScreenW;
    
    // 通过角标从存放按钮的数组中取出按钮
    UIButton *btn = self.buttons[index];
    
    // 切换按钮的状态
    [self selectedBtn:btn];
    
    // 添加对应子控制器的view到contentScrollView
    [self setupOneViewControllerView:index];
    
}

// ----------------------------------------------------------------------------
// 懒加载
#pragma mark - 懒加载

- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

@end