//
//  PlayMusicViewController.m
//  Day08-音乐播放器01
//
//  Created by 张曼璐 on 17/7/13.
//  Copyright © 2017年 tedu. All rights reserved.
//

#import "PlayMusicViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Extension.h"
#import "LrcParser.h"
#import "NSMutableArray+extension.h"
#import "Header.h"
#import "MusicArray.h"

@interface PlayMusicViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    AVAudioPlayer *audioPlayer;
    UISlider *volumeSlider;
    UISlider *progressSlider;
    UILabel *currentTimeLabel;
    UILabel *fullTimeLabel;
    MusicArray *_music;
    //    NSMutableArray *randomMusicArray;
    int index;
    UIButton *playBtn;
    UILabel *musicNameLabel;
    UILabel *artistLabel;
    UILabel *albumLabel;
    UIImageView *albumImageView;
    NSTimer *albumImageTimer;
    NSString *playType;
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    
    UITableView *lrcTable;
    
    LrcParser *lrcContent;
    NSTimer *timer;
    NSInteger currentRow;
    UITableView *listTableView;
    UILabel *listLabel;

}
@end

@implementation PlayMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //获取当前应用束下所有的mp3音乐
    _music = [[MusicArray alloc]init];;
    
    //    randomMusic = [[NSMutableArray alloc]initWithCapacity:_music.count];
    //把第一首音乐转成URL格式
    NSURL *fileURL = [[NSURL alloc]initFileURLWithPath:_music[0]];
    [self getMusicName:fileURL];
    //让audioPlayer默认音乐是第一首音乐
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    index = 0;
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    background.image = [UIImage imageNamed:@"9.jpeg"];
    [self.view addSubview:background];
    
    //创建一个按钮控制音乐的播放和停止
    playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(WIDTH/2-25, HEIGHT-100, 50, 50);
    [playBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    //给按钮添加点事件
    [playBtn addTarget:self action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    
    //上一首按钮
    UIButton *forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardBtn.frame = CGRectMake(WIDTH/2-100, HEIGHT-100, 50, 50);
    [forwardBtn setImage:[UIImage imageNamed:@"forward.png"] forState:UIControlStateNormal];
    [forwardBtn addTarget:self action:@selector(forwardMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forwardBtn];
    
    //下一首按钮
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(WIDTH/2+50, HEIGHT-100, 50, 50);
    [nextBtn setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    //播放模式按钮
    UIButton *palyTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    palyTypeBtn.frame = CGRectMake(WIDTH/2-155, HEIGHT-90, 30, 30);
    [palyTypeBtn setImage:[UIImage imageNamed:@"loop.png"] forState:UIControlStateNormal];
    playType= @"loop";
    [palyTypeBtn addTarget:self action:@selector(changePlayType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:palyTypeBtn];
    
    //播放列表按钮
    UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    listBtn.frame = CGRectMake(WIDTH/2+115, HEIGHT-90, 30, 30);
    [listBtn setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    [listBtn addTarget:self action:@selector(musicList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listBtn];
    
    
    
    //创建滑动条
    //    volumeSlider = [[UISlider alloc]init];
    //    volumeSlider.value = 0.5;
    //    volumeSlider.minimumValue = 0.0;
    //    volumeSlider.maximumValue = 1.0;
    //    volumeSlider.frame = CGRectMake(190, 300, 325, 30);
    //    volumeSlider.transform = CGAffineTransformMakeRotation(-90*M_PI/180);
    //    [volumeSlider addTarget:self action:@selector(changeVolume:) forControlEvents:UIControlEventValueChanged];
    //    [self.view addSubview:volumeSlider];
    
    progressSlider = [[UISlider alloc]init];
    progressSlider.value = 0.0;
    progressSlider.minimumValue = 0.0;
    progressSlider.maximumValue = 200.0;
    progressSlider.frame = CGRectMake(60, HEIGHT-150, 255, 30);
    [progressSlider addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:progressSlider];
    
    musicNameLabel = [[UILabel alloc]init];
    musicNameLabel.frame = CGRectMake(WIDTH/2-100, HEIGHT-300, 200, 30);
    musicNameLabel.textAlignment = 1;
    musicNameLabel.text = [self getMusicName:fileURL];
    [self.view addSubview:musicNameLabel];
    
    artistLabel = [[UILabel alloc]init];
    artistLabel.frame = CGRectMake(WIDTH/2-100, HEIGHT-250, 200, 30);
    artistLabel.textAlignment = 1;
    artistLabel.text = [self getArtist:fileURL];
    [self.view addSubview:artistLabel];
    
    albumLabel = [[UILabel alloc]init];
    albumLabel.frame = CGRectMake(WIDTH/2-100, HEIGHT-200, 200, 30);
    albumLabel.textAlignment = 1;
    albumLabel.text = [self getAlbumName:fileURL];
    [self.view addSubview:albumLabel];
    
    //创建一个监听方法，用来跟踪音乐进度
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(process:) userInfo:nil repeats:YES];
    
    //添加当前时间
    currentTimeLabel = [[UILabel alloc]init];
    currentTimeLabel.frame = CGRectMake(10, HEIGHT-150, 50, 30);
    currentTimeLabel.textColor = [UIColor grayColor];
    NSString *tempStr = [NSString stringWithFormat:@"00:00"];
    currentTimeLabel.text = tempStr;
    [self.view addSubview:currentTimeLabel];
    
    //添加歌曲时间
    fullTimeLabel = [[UILabel alloc]init];
    fullTimeLabel.frame = CGRectMake(320, HEIGHT-150, 50, 30);
    fullTimeLabel.textColor = [UIColor grayColor];
    fullTimeLabel.text = [self getMusicTime];
    [self.view addSubview:fullTimeLabel];
    
    //左右滚动视图
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, WIDTH, HEIGHT-220)];
    //设置滚动范围
    scrollView.contentSize = CGSizeMake(WIDTH*2, 0);
    //分页显示
    scrollView.pagingEnabled = YES;
    //禁止纵向滚动
    scrollView.showsHorizontalScrollIndicator = NO;
    //委托
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    UIView *view2 = [[UIView alloc]initWithFrame:scrollView.bounds];
    view2.x = WIDTH;
    [scrollView addSubview:view2];
    
    //专辑图片
    albumImageView = [[UIImageView alloc]init];
    albumImageView.frame = CGRectMake(WIDTH/2-100, 70, 200, 200);
    albumImageView.image = [UIImage imageNamed:@"人生海海.jpg"];
    albumImageView.layer.cornerRadius = 100;
    albumImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    albumImageView.layer.borderWidth = 1;
    albumImageView.layer.masksToBounds = YES;
    //添加到滚动视图里
    [scrollView addSubview:albumImageView];
    
    //滚动标注
    pageControl = [[UIPageControl alloc]init];
    pageControl.center = CGPointMake(WIDTH/2, scrollView.frame.origin.y+scrollView.frame.size.height-10);
    //分页数
    pageControl.numberOfPages = 2;
    //未选中颜色
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    //选中颜色
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    //禁止点击
    pageControl.enabled = NO;
    [self.view addSubview:pageControl];
    
    lrcTable = [[UITableView alloc]init];
    lrcTable.frame = view2.bounds;
    lrcTable.frame = CGRectMake(0, 0, WIDTH, view2.height-20);
    lrcTable.dataSource = self;
    lrcTable.delegate = self;
    lrcTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [view2 addSubview:lrcTable];
    lrcContent = [[LrcParser alloc]init];
    currentRow = 0;
    [lrcContent doParseLrc:[self getMusicName:fileURL]];
    [lrcTable reloadData];//重新刷一下表
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 20, 30, 30)];
    //    backBtn.backgroundColor = [UIColor redColor];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    //    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    //
    //    UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
    //
    //    view.frame = scrollView.bounds;
    //    view.x = WIDTH;
    //    [scrollView addSubview:view];
    //    [self.view addSubview:view];
    
}
-(void)musicList:(id)sender{
    
    listLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT/2-25, WIDTH, 45)];
    listLabel.backgroundColor=[UIColor lightGrayColor];
    listLabel.text=@"    播放队列";
    listLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:listLabel];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(340, HEIGHT/2-18, 80, 30)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(moveFromListTableView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    listTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,HEIGHT/2+20, WIDTH, HEIGHT/2-20)];
    listTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    listTableView.delegate=self;
    listTableView.dataSource=self;
    [self.view addSubview:listTableView];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x /(WIDTH*0.7);
    pageControl.currentPage = page;
    
}

//播放音乐方法
-(void)playMusic:(id)selector{
    UIButton *btn = (UIButton *)selector;
    if (audioPlayer.playing) {
        [audioPlayer stop];
        [btn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [albumImageTimer invalidate];
    }
    else{
        [audioPlayer play];
        [btn setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
        albumImageTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(imgTransform) userInfo:nil repeats:YES];
    }
    //    NSLog(@"%@",_music[index]);
}
//根据播放模式播放音乐
-(void)playMusicWithPlayType{
    
    if ([playType isEqual:@"loop"]||[playType isEqual:@"single"]) {
        NSURL *fileURL = [[NSURL alloc]initFileURLWithPath:_music[index]];
        [self playMusicWithFileURL:fileURL];
    }
    else if ([playType isEqual:@"random"]){
        
        //        int randomIndex = arc4random_uniform((u_int32_t )_music.count);
        //        NSLog(@"%d",randomIndex);
        
        index = arc4random_uniform((u_int32_t)_music.count);
        NSURL *fileURL = [[NSURL alloc]initFileURLWithPath:_music[index]];
        [self playMusicWithFileURL:fileURL];
    }
    else{
        NSLog(@"error");
    }
}
//播放音乐
-(void)playMusicWithFileURL:(NSURL*)fileURL{
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    fullTimeLabel.text = [self getMusicTime];
    [audioPlayer play];
    [playBtn setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
    musicNameLabel.text = [self getMusicName:fileURL];
    artistLabel.text = [self getArtist:fileURL];
    albumLabel.text = [self getAlbumName:fileURL];
    [albumImageTimer invalidate];
    albumImageView.transform = CGAffineTransformIdentity;
    albumImageTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(imgTransform) userInfo:nil repeats:YES];
    
    [lrcContent doParseLrc:[self getMusicName:fileURL]];
    [lrcTable reloadData];
}
//-(void)playMusicAtIndex{
//        NSURL *fileURL = [[NSURL alloc]initFileURLWithPath:_music[index]];
//        audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
//        fullTimeLabel.text = [self getMusicTime];
//        [audioPlayer play];
//        [playBtn setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
//        musicNameLabel.text = [self getMusicName:fileURL];
//        artistLabel.text = [self getArtist:fileURL];
//        albumLabel.text = [self getAlbumName:fileURL];
//        [albumImageTimer invalidate];
//        albumImageView.transform = CGAffineTransformIdentity;
//        albumImageTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(imgTransform) userInfo:nil repeats:YES];
//
//        [lrcContent doParseLrc:[self getMusicName:fileURL]];
//        [lrcTable reloadData];
//
//}

//上一首
-(void)forwardMusic{
    //单曲循环模式时
    if ([playType isEqual:@"single"]) {
        [self playMusicWithPlayType];
        return;
    }
    //其他模式时
    if (index != 0) {
        index --;
        [self playMusicWithPlayType];
    }
    else{
        index = (int)_music.count-1;
        [self playMusicWithPlayType];
    }
}
//下一首
-(void)nextMusic{
    //单曲循环模式时
    if ([playType isEqual:@"single"]) {
        [self playMusicWithPlayType];
        return;
    }
    if (index != (_music.count-1)) {
        index ++;
        [self playMusicWithPlayType];
    }
    else{
        index = 0;
        [self playMusicWithPlayType];
    }
}
//改变音量
//-(void)changeVolume:(id)selector{
//    audioPlayer.volume = volumeSlider.value;
//}

//手动更改进度时，音乐进度跟着手动进度条位置改
-(void)changeProgress:(id)selector{
    audioPlayer.currentTime = (progressSlider.value/progressSlider.maximumValue)*audioPlayer.duration;
}
//跟踪音乐进度方法
-(void)process:(id)selector{
    progressSlider.value = progressSlider.maximumValue*audioPlayer.currentTime/audioPlayer.duration;
    //时间
    int minute = audioPlayer.currentTime/60;
    int second = (int)(audioPlayer.currentTime)%60;
    NSString *str = [NSString stringWithFormat:@"%02d:%02d",minute,second];
    currentTimeLabel.text = str;
    //自动播放下一首
    if ((int)audioPlayer.currentTime == (int)audioPlayer.duration) {
        [self nextMusic];
    }
}
//获取歌曲时间，转换成字符串
-(NSString *)getMusicTime{
    int minute = audioPlayer.duration/60;
    int second = (int)(audioPlayer.duration)%60;
    NSString *str = [NSString stringWithFormat:@"%02d:%02d",minute,second];
    return str;
}
//获取歌曲名字
-(NSString*)getMusicName:(NSURL*)fileURL{
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    NSArray *titles = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyTitle keySpace:AVMetadataKeySpaceCommon];
    if (titles.count > 0) {
        AVMetadataItem *title = titles[0];
        NSString *str = [title.value copyWithZone:nil];
        return str;
    }
    else{
        NSMutableString *str = [[NSMutableString alloc]initWithString:_music[index]];
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
        albumImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",str]];
        return str;
    }
    else{
        return @" ";
    }
}
//旋转专辑图片
-(void)imgTransform{
    albumImageView.transform = CGAffineTransformRotate(albumImageView.transform, 0.01);
}

-(void)createAlert:(NSTimer *)timer{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
}
//更改播放模式
-(void)changePlayType:(id)selector{
    UIButton *btn = (UIButton *)selector;
    //    if (isShow) {
    //        NSLog(@"重叠");
    //        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    //        NSArray *array = window.subviews;
    //        for (int i = 0; i < array.count; i ++) {
    //            if (i == array.count-1) {
    //                [array[i] removeFromSuperview];
    //            }
    //        }
    //    }
    
    //    UIAlertController *alertController;
    
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-50, HEIGHT/2, 100, 40)];
    alertLabel.backgroundColor = ColorRGBA(50, 50, 50, 0.5);
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.layer.cornerRadius = 10;
    alertLabel.clipsToBounds = YES;
    
    if ([playType  isEqual: @"loop"]) {
        [btn setImage:[UIImage imageNamed:@"single.png"] forState:UIControlStateNormal];
        playType = @"single";
        alertLabel.text = @"单曲循环";
    }
    else if ([playType isEqual:@"single"]){
        [btn setImage:[UIImage imageNamed:@"random.png"] forState:UIControlStateNormal];
        playType = @"random";
        //        randomMusicArray = [[NSMutableArray alloc]initWithArray:_music];
        //        [randomMusicArray shuffle];
        alertLabel.text = @"随机播放";
    }
    else if([playType isEqual:@"random"]){
        [btn setImage:[UIImage imageNamed:@"loop.png"] forState:UIControlStateNormal];
        playType = @"loop";
        alertLabel.text = @"列表循环";
    }
    else{
        NSLog(@"error:播放模式错误。playType:%@",playType);
    }
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dimissAlertLabel:) userInfo:alertLabel repeats:NO];
    
    [self.view addSubview:alertLabel];
}
-(void)dimissAlertLabel:(NSTimer *)timer{
    
    UILabel *label = [timer userInfo];
    [label removeFromSuperview];
    //    isShow = NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:lrcTable])
        return lrcContent.wordArray.count;
    else if([tableView isEqual:listTableView])
        return _music.count;
    else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [lrcTable dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: ID];
    }
    
    if([tableView isEqual:lrcTable])
    {
        cell.textLabel.text=lrcContent.wordArray[indexPath.row];
        if(indexPath.row==currentRow)
            cell.textLabel.textColor = [UIColor colorWithRed:115.0/256.0 green:138.0/256.0 blue:149.0/256.0 alpha:1.0];
        else
            cell.textLabel.textColor = [UIColor grayColor];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.backgroundColor=[UIColor clearColor];
    }
    
    else if ([tableView isEqual:listTableView])
    {
        NSURL *url=[[NSURL alloc]initFileURLWithPath:_music[indexPath.row]];
        NSString *musicName=[self getMusicName:url];
        cell.textLabel.text=[NSString stringWithFormat:@"%02d %@",(int)(indexPath.row+1),musicName];
        if(indexPath.row==index){
            cell.textLabel.textColor=[UIColor orangeColor];
            if(indexPath.row>=4){
                UITableView *tempTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, HEIGHT/2+20, WIDTH, HEIGHT/2-20)];
                
            }
            
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:listTableView]){
        index = (int)indexPath.row;
        NSURL *fileURL = [[NSURL alloc]initFileURLWithPath:_music[index]];
        [self playMusicWithFileURL:fileURL];
        
        for(int i=0;i<_music.count;i++){
            NSIndexPath *currentIndexPath=[NSIndexPath indexPathForRow:(int)i inSection:0];
            UITableViewCell *cell=[tableView cellForRowAtIndexPath:currentIndexPath];
            cell.textLabel.textColor=[UIColor blackColor];
        }
        
        UITableViewCell *selectedCell=[tableView cellForRowAtIndexPath:indexPath];
        selectedCell.textLabel.textColor=[UIColor orangeColor];
        
    }
    
    
    
}


-(void) updateTime{
    CGFloat currentTime=audioPlayer.currentTime;
    for (int i=0; i<lrcContent.timerArray.count; i++) {
        NSArray *timeArray=[lrcContent.timerArray[i] componentsSeparatedByString:@":"];
        float lrcTime=[timeArray[0] intValue]*60+[timeArray[1] floatValue];
        if(currentTime>lrcTime){
            currentRow=i;
        }else
            break;
    }
    [lrcTable reloadData];
    [lrcTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
}

//实现高斯模糊
//-(UIImage *)getBlurredImage:(UIImage *)image{
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CIImage *ciImage=[CIImage imageWithCGImage:image.CGImage];
//    CIFilter *filter=[CIFilter filterWithName:@"CIGaussianBlur"];
//    [filter setValue:ciImage forKey:kCIInputImageKey];
//    [filter setValue:@5.0f forKey:@"inputRadius"];
//    CIImage *result=[filter valueForKey:kCIOutputImageKey];
//    CGImageRef ref=[context createCGImage:result fromRect:[result extent]];
//    return [UIImage imageWithCGImage:ref];
//}

-(void)moveFromListTableView:(id)sender{
    [listTableView removeFromSuperview];
    [listLabel removeFromSuperview];
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

@end
