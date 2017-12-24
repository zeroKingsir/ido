//
//  GuidanceViewController.h
//  
//
//  Created by G.Z on 16/1/19.
//  Copyright (c) 2016年 G.Z. All rights reserved.
//
//实现引导页 App安装后只展示一次

#import <UIKit/UIKit.h>
typedef void(^MyBlock)(void);
@interface GuidanceViewController : UIViewController

/*
- (instancetype)initWithImagesArr:(NSArray *)imagesArr andBlock:(void(^)(void))block;
*/
- (instancetype)initWithImagesArr:(NSArray *)imagesArr andBlock:(MyBlock)block;



@end









