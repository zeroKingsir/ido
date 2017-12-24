//
//  PlaceholderTextView.h
//  IDo
//
//  Created by G.Z on 16/3/29.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

@property (nonatomic,strong) UILabel *placeHolderLabel;

@property (nonatomic,copy) NSString *placeholder;

@property (nonatomic,strong)UIColor *placeholderColor;

- (void)textChanged:(NSNotification * )notification;

@end
