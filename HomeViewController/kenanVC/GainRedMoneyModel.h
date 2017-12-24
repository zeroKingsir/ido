//
//  GainRedMoneyModel.h
//  IDo
//
//  Created by 柯南 on 16/1/24.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GainRedMoneyModel : NSObject
@property (nonatomic,strong) NSString *headImage;
@property (nonatomic,strong) NSString *sexImage;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *money;
@property (nonatomic,strong) NSString *time;

@property (nonatomic,strong) NSString *content;
-(id)initWithJson:(id)json;
@end
