//
//  PhotoCollectionViewCell.m
//  IDo
//
//  Created by G.Z on 16/3/29.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

//懒加载创建数据
- (UIImageView *)photoV{

    if (_photoV == nil) {
        
        self.photoV = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    
    return _photoV;
}


//创建自定义cell时调用该方法
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self.contentView addSubview:self.photoV];
    }
    return self;
}

//- (void)awakeFromNib {
//    // Initialization code
//}

@end
