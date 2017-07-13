//
//  AppDelegate.m
//  Day08-音乐播放器01
//
//  Created by 张曼璐 on 17/6/28.
//  Copyright © 2017年 tedu. All rights reserved.
//

#import "AppDelegate.h"
#import "myTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化窗口，并给定大小
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    myTabBarController *tabBarController = [[myTabBarController alloc]init];
    self.window.rootViewController = tabBarController;
    
    //窗口可见
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}
@end
