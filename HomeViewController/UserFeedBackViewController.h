//
//  UserFeedBackViewController.h
//  IDo
//
//  Created by G.Z on 16/3/29.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJCActionSheet.h"

@protocol UserFeedBackViewControllerDelegate <NSObject>

-(void)editDoneWithText:(NSString *)text imageArr:(NSMutableArray *)imageArr;

@end

@interface UserFeedBackViewController : UIViewController<HJCActionSheetDelegate>

{
    BOOL isFirstAddPhoto;
    
}

@property (nonatomic, weak) id <UserFeedBackViewControllerDelegate> delegate;


+ (UserFeedBackViewController *)SingelUser;


@end
