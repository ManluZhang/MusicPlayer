//
//  MusicArray.h
//  Day08-音乐播放器01
//
//  Created by 张曼璐 on 17/7/14.
//  Copyright © 2017年 tedu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicArray : NSObject
@property (nonatomic,strong) NSArray *songArray;
@property (nonatomic,strong) NSMutableArray *musicMutableArray;
-(void)addMusic;
@end
