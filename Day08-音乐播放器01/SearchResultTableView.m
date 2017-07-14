//
//  SearchResultTableView.m
//  Day08-音乐播放器01
//
//  Created by 张曼璐 on 17/7/14.
//  Copyright © 2017年 tedu. All rights reserved.
//

#import "SearchResultTableView.h"
@interface SearchResultTableView()<UITableViewDelegate>
@end
@implementation SearchResultTableView

//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
        
    }
    
    return cell;
}
//点击row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
