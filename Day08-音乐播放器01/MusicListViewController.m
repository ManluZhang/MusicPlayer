//
//  MusicListViewController.m
//  Day08-音乐播放器01
//
//  Created by 唐金婷 on 17/7/14.
//  Copyright © 2017年 tedu. All rights reserved.
//

#import "MusicListViewController.h"
#import "MusicArray.h"
#import "Music.h"

@interface MusicListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    MusicArray *musicArray;
}

@end

@implementation MusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *musicListView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    musicListView.dataSource=self;
    musicListView.delegate=self;
    [self.view addSubview:musicListView];
    
    musicArray=[[MusicArray alloc]init];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return musicArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"UITableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    if(cell==nil)
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    
   
    Music *music=musicArray[indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%d %@",(int)indexPath.row,music.name];
    cell.textLabel.textColor=[UIColor grayColor];
        
    return cell;
}



@end
