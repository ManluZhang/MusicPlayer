//
//  Header.h
//  Day08-音乐播放器01
//
//  Created by 张曼璐 on 17/7/12.
//  Copyright © 2017年 tedu. All rights reserved.
//

#ifndef Header_h
#define Header_h
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/1.0]
#define RandomColor TDColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#endif /* Header_h */
