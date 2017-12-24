//
//  Storage.m
//  
//
//  Created by G.Z on 16/1/19.
//  Copyright (c) 2016年 G.Z. All rights reserved.
//

#import "Storage.h"
#define GUIDANCE_KEY @"IDO_FREE_GUIDANCE"


@implementation Storage
#pragma mark -- 设置/获取引导标记
+ (BOOL)setGuidanceValue:(BOOL)value{

    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    [userDef setBool:value forKey:GUIDANCE_KEY];
    
    return [userDef synchronize];
    
}
+ (BOOL)getGuidanceValue{

    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    return [userDef boolForKey:GUIDANCE_KEY];
    
}
@end






