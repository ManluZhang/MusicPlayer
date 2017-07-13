//
//  myTabBarController.m
//  MusicPlayer
//
//  Created by 张曼璐 on 17/7/12.
//  Copyright © 2017年 tedu. All rights reserved.
//

#import "myTabBarController.h"
#import "SearchMusicViewController.h"
#import "MyMusicViewController.h"

@implementation myTabBarController
-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    SearchMusicViewController *searchMusic = [[SearchMusicViewController alloc]init];
    [searchMusic.tabBarItem setTitle:@"发现音乐"];
    [searchMusic.tabBarItem setImage:[UIImage imageNamed:@"search1.png"]];
    searchMusic.tabBarItem.selectedImage =[[UIImage imageNamed:@"search1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSMutableDictionary *atts = [NSMutableDictionary dictionary];
    atts[NSForegroundColorAttributeName] = [UIColor grayColor];
    NSMutableDictionary *attsSelected = [NSMutableDictionary dictionary];
    attsSelected[NSForegroundColorAttributeName] =[UIColor blackColor];
    [searchMusic.tabBarItem setTitleTextAttributes:atts forState:UIControlStateNormal];
    [searchMusic.tabBarItem setTitleTextAttributes:attsSelected forState:UIControlStateSelected];
    
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:searchMusic];
    nav1.navigationBarHidden = YES;
    [self addChildViewController:nav1];
    
    MyMusicViewController *myMusic = [[MyMusicViewController alloc]init];
    [myMusic.tabBarItem setTitle:@"我的音乐"];
    myMusic.tabBarItem.title = @"我的音乐";
    [myMusic.tabBarItem setImage:[UIImage imageNamed:@"mymusic1.png"]];
    myMusic.tabBarItem.selectedImage =[[UIImage imageNamed:@"mymusic1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [myMusic.tabBarItem setTitleTextAttributes:atts forState:UIControlStateNormal];
    [myMusic.tabBarItem setTitleTextAttributes:attsSelected forState:UIControlStateSelected];
//    [self addChildViewController:myMusic];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:myMusic];
    [self addChildViewController:nav2];
}
@end
