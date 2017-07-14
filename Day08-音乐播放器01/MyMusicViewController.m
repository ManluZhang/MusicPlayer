//
//  MyMusicViewController.m
//  MusicPlayer
//
//  Created by 张曼璐 on 17/7/12.
//  Copyright © 2017年 tedu. All rights reserved.
//

#import "MyMusicViewController.h"
#import "PlayMusicViewController.h"
#import "Header.h"
#import "PlayMusicViewController.h"
@interface MyMusicViewController()<UITableViewDataSource,UITableViewDelegate>
{
    UITableViewController *musicListViewController;
    UITableViewController *singersListViewController;
    UITableViewController *albumsListViewController;
    UITableView *musicListView;
    UITableView *singersListView;
    UITableView *albumsListView;
}
@end

@implementation MyMusicViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    //导航栏的设置
    self.navigationItem.title=@"我的音乐";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon1.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(playMusic)];
    
  
    //播放列表button
    UIButton *playBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 70, WIDTH, 60)];
    [playBtn setTitle:@"播放列表" forState:UIControlStateNormal];
    [playBtn setFont:[UIFont systemFontOfSize:21]];
    playBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    playBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    [playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [playBtn setBackgroundColor:[UIColor lightGrayColor]];
    [playBtn addTarget:self action:@selector(showMusicList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    
    //歌手列表button
    UIButton *singerBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 135, WIDTH, 60)];
    [singerBtn setTitle:@"歌手列表" forState:UIControlStateNormal];
    [singerBtn setFont:[UIFont systemFontOfSize:21]];
    singerBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    singerBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    [singerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [singerBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [singerBtn setBackgroundColor:[UIColor lightGrayColor]];
    [singerBtn addTarget:self action:@selector(showSingers) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:singerBtn];
    
    //专辑列表button
    
    UIButton *albumBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 200, WIDTH, 60)];
    [albumBtn setTitle:@"专辑列表" forState:UIControlStateNormal];
    [albumBtn setFont:[UIFont systemFontOfSize:21]];
    albumBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    albumBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    [albumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [albumBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [albumBtn setBackgroundColor:[UIColor lightGrayColor]];
    [albumBtn addTarget:self action:@selector(showAlbums) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:albumBtn];
}

-(void)playMusic{
    PlayMusicViewController *playMusicVC=[[PlayMusicViewController alloc]init];
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController pushViewController:playMusicVC animated:YES];
}

-(void)showMusicList{
    musicListViewController=[[UITableViewController alloc]init];
    musicListView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    musicListView.dataSource=musicListViewController;
    musicListView.delegate=musicListViewController;
    [musicListViewController.view addSubview:musicListView];
    [self.navigationController pushViewController:musicListViewController animated:YES];
    
    
}

-(void)showSingers{
    singersListViewController=[[UITableViewController alloc]init];
    singersListView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    singersListView.dataSource=musicListViewController;
    singersListView.delegate=musicListViewController;
    [singersListViewController.view addSubview:singersListView];
    [self.navigationController pushViewController:singersListViewController animated:YES];
}


-(void)showAlbums{
    albumsListViewController=[[UITableViewController alloc]init];
    albumsListView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    albumsListView.dataSource= albumsListViewController;
    albumsListView.delegate= albumsListViewController;
    [albumsListViewController.view addSubview: albumsListView];
    [self.navigationController pushViewController: albumsListViewController animated:YES];
    
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if([tableView isEqual:musicListView]){
//        
//    }
//    else if([tableView isEqual:singersListView]){
//        
//    }
//    else if([tableView isEqual:albumsListView]){
//        
//    }
//    
//    else
//        return 0;
//    
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"UITableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    if(cell==nil)
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    
    if([tableView isEqual:musicListView]){
        
    }
    else if([tableView isEqual:singersListView]){
        
    }
    else if([tableView isEqual:albumsListView]){
        
    }
    
    return cell;
}
@end

