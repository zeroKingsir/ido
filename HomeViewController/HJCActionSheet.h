//
//  HJCActionSheet.h
//  wash
//
//  Created by weixikeji on 15/5/11.
//
//

#import <UIKit/UIKit.h>

@class HJCActionSheet;

@protocol HJCActionSheetDelegate <NSObject>

@optional

/**
 *  点击按钮
 */
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface HJCActionSheet : UIView

/**
 *  代理
 */
@property (nonatomic, weak) id <HJCActionSheetDelegate> delegate;

/**
 *  创建对象方法
 */
- (instancetype)initWithDelegate:(id<HJCActionSheetDelegate>)delegate CancelTitle:(NSString *)cancelTitle OtherTitles:(NSString*)otherTitles,... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithDelegate:(id<HJCActionSheetDelegate>)delegate CancelTitle:(NSString *)cancelTitle title:(NSString *)title OtherTitles:(NSString *)otherTitles, ...NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithDelegate:(id<HJCActionSheetDelegate>)delegate CancelTitle:(NSString *)cancelTitle TitleArray:(NSMutableArray *)titleArray;
-(void)setupBtnImageWithTitle:(NSDictionary *)dic; //带图片的按钮

- (void)show;

@end
