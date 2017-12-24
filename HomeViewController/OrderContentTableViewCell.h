//
//  OrderContentTableViewCell.h
//  IDo
//
//  Created by liangpengshuai on 9/25/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>

//跳转订单详情页的代理
@protocol selectionLabelDelegate <NSObject>

- (void)selectionLabelClickWithSelection:(id)labelText;

@end

@interface OrderContentTableViewCell : UITableViewCell <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeholderTextField;
@property (weak, nonatomic) IBOutlet UIImageView *indicateImageView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (nonatomic) BOOL isSendRed;  //是否是发送红包
//添加代理
@property (nonatomic,assign)id <selectionLabelDelegate>delegate;



@end
