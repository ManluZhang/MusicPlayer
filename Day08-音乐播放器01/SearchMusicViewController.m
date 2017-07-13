//
//  SearchMusicViewController.m
//  MusicPlayer
//
//  Created by 张曼璐 on 17/7/12.
//  Copyright © 2017年 tedu. All rights reserved.
//

#import "SearchMusicViewController.h"
#import "Header.h"
#import "UIView+Extension.h"
#import "PlayMusicViewController.h"
@interface SearchMusicViewController()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSTimer *timer;
@end
@implementation SearchMusicViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //搜索框view
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, 50)];
    //背景颜色
    searchView.backgroundColor = [UIColor whiteColor];
    
    //搜索框
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, WIDTH-50, 50)];
    searchBar.placeholder = @"搜索音乐、歌词、电台";
    searchBar.backgroundColor =[UIColor clearColor];
    searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:searchBar.bounds.size];
    [searchView addSubview:searchBar];
    
    //右侧按钮－点击进入播放音乐
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-50, 0, 50, 50)];
    [btn setImage:[UIImage imageNamed:@"icon1.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toPlayMusic) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:btn];
    
    [self.view addSubview:searchView];
    
    
    //滚动视图
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, WIDTH, WIDTH*280/750)];
    _scrollView.backgroundColor = [UIColor clearColor];
    
    NSArray *imageNameArray = @[@"5.PNG",@"1.PNG",@"2.PNG",@"3.PNG",@"4.PNG",@"5.PNG",@"1.PNG"];

    for (int i = 0; i < 7; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:_scrollView.frame];
        [imageView setImage:[UIImage imageNamed:imageNameArray[i]]];
        imageView.x = i*WIDTH;
        imageView.y = 0;
        [_scrollView addSubview:imageView];
    }
    _scrollView.contentSize = CGSizeMake(WIDTH*7, 0);
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [_scrollView setContentOffset:CGPointMake(WIDTH, 0) animated:NO];
    [self startTimer];
    [self.view addSubview:_scrollView];
    
    UIView *recommendMusicView = [[UIView alloc]initWithFrame:CGRectMake(0, _scrollView.height+_scrollView.y +10, WIDTH, 300)];
    recommendMusicView.backgroundColor = [UIColor redColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    titleLabel.text = @"推荐歌单";
    titleLabel.backgroundColor = [UIColor blueColor];
    
    NSArray *array = @[@"华语绝妙改编，把旧歌谣唱出新鲜味",@"融合爵士，七十年代巅峰爵士音乐大师精选",@"后摇，孤独而不孤阴郁自行者",@"高效率专注记忆音乐",@"欧美，心有盏小橘灯，温暖如斯",@"史诗纯音，画面感max 震撼灵魂"];
    
    
    [recommendMusicView addSubview:titleLabel];
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0; j < 3; j ++) {
            UIImageView *cubeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(j*(WIDTH-10)/3+5*j, i*(WIDTH-10)/3+40+i*40, (WIDTH-10)/3, (WIDTH-10)/3)];
            [cubeImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"cube%d.png",i*3+j+1]]];
            [recommendMusicView addSubview:cubeImgView];
            
            UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(cubeImgView.x, cubeImgView.y+cubeImgView.height, cubeImgView.width, 40)];
            textLabel.text = array[i*2+j];
            textLabel.font = [UIFont systemFontOfSize:13];
            [recommendMusicView addSubview:textLabel];
        }
    }

    
    [self.view addSubview:recommendMusicView];
    
    
    
}
//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    
    //通知主线程
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)nextPage
{
    int page = (int)self.scrollView.contentOffset.x/WIDTH;
    //如果为最后一张图
    if(page == 5){
        //切回第0张图（即图5） 无动画
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        //播放图1 有动画
        [_scrollView setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
    }
    else{
        page ++;
        [_scrollView setContentOffset:CGPointMake(WIDTH*page, 0) animated:YES];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTime];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int currentPage = (int)self.scrollView.contentOffset.x/WIDTH;
    
    if (currentPage==0)
    {
        [scrollView setContentOffset:CGPointMake(WIDTH*5, 0) animated:NO];
    }
    else if (currentPage== 6)
    {
        [scrollView setContentOffset:CGPointMake(WIDTH, 0) animated:NO];
    }
}
-(void)stopTime
{
    [self.timer invalidate];//停止定时器
    self.timer = nil;
}

//进入播放音乐界面
-(void)toPlayMusic{
    PlayMusicViewController *playMusicVC = [[PlayMusicViewController alloc]init];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:playMusicVC animated:YES];
    
}


@end
