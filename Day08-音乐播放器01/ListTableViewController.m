//
//  ListTableViewController.m
//  Day08-音乐播放器01
//
//  Created by 唐金婷 on 17/7/12.
//  Copyright © 2017年 tedu. All rights reserved.
//

#import "ListTableViewController.h"
#import "Header.h"

@interface ListTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *listLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT/2-20, WIDTH, 20)];
    listLabel.backgroundColor=[UIColor grayColor];
    listLabel.text=@"播放队列";
    listLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:listLabel];
    
    UITableView *listTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,HEIGHT/2, WIDTH, HEIGHT/2)];
    listTableView.backgroundColor=[UIColor grayColor];
    listTableView.delegate=self;
    listTableView.dataSource=self;
    [self.view addSubview:listTableView];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *music=[[NSBundle mainBundle]pathsForResourcesOfType:@"mp3" inDirectory:nil];
    return music.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"UITableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    if(cell==nil)
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    
    
    return cell;
}





@end
