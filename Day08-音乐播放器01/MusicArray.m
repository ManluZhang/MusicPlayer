//
//  MusicArray.m
//  Day08-音乐播放器01
//
//  Created by 张曼璐 on 17/7/14.
//  Copyright © 2017年 tedu. All rights reserved.
//

#import "MusicArray.h"
#import "Music.h"
#import <AVFoundation/AVFoundation.h>
@implementation MusicArray
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"hh");
        self.songArray = [[NSBundle mainBundle]pathsForResourcesOfType:@"mp3" inDirectory:nil];
        self.musicMutableArray  = [[NSMutableArray alloc]initWithCapacity:self.songArray.count];
        for (int i = 0; i < self.songArray.count; i ++) {
            Music *song = [[Music alloc]init];
            song.fileURL = [[NSURL alloc]initFileURLWithPath:self.songArray[i]];
            song.name = [self getMusicName:song.fileURL index:i];
            song.artist = [self getArtist:song.fileURL];
            song.albumName = [self getAlbumName:song.fileURL];
    
            [self.musicMutableArray addObject:song];
        }
//        self = [[NSMutableArray alloc]initWithCapacity:self.songArray.count];
    }
    return self;
}
//add music
-(void)addMusic
{
//    for (int i = 0; i < self.songArray.count; i ++) {
//        Music *song = [[Music alloc]init];
//        song.fileURL = [[NSURL alloc]initFileURLWithPath:self.songArray[i]];
//        song.name = [self getMusicName:song.fileURL index:i];
//        song.artist = [self getArtist:song.fileURL];
//        song.albumName = [self getAlbumName:song.fileURL];
//        
//        [self addObject:song];
//    }
}
//获取歌曲名字
-(NSString*)getMusicName:(NSURL*)fileURL index:(int)index
{
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    NSArray *titles = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyTitle keySpace:AVMetadataKeySpaceCommon];
    if (titles.count > 0) {
        AVMetadataItem *title = titles[0];
        NSString *str = [title.value copyWithZone:nil];
        return str;
    }
    else{
        NSMutableString *str = [[NSMutableString alloc]initWithString:self.songArray[index]];
        NSLog(@"%@",str);
        return @"";
    }
}
//获取歌手
-(NSString*)getArtist:(NSURL*)fileURL{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    NSArray *artists = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyArtist keySpace:AVMetadataKeySpaceCommon];
    if (artists.count > 0) {
        AVMetadataItem *artist = artists[0];
        NSString *str = [artist.value copyWithZone:nil];
        return str;
    }
    else{
        return @"";
    }
}
//获取专辑名、设置专辑图片
-(NSString*)getAlbumName:(NSURL*)fileURL{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    NSArray *albumNames = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyAlbumName keySpace:AVMetadataKeySpaceCommon];
    if (albumNames.count > 0) {
        AVMetadataItem *albumName = albumNames[0];
        NSString *str = [albumName.value copyWithZone:nil];
        //设置专辑图片
//        albumImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",str]];
        return str;
    }
    else{
        return @" ";
    }
}

@end
