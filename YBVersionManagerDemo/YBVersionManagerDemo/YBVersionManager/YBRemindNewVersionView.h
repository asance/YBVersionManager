//
//  YBRemindNewVersionView.h
//  YoubanAgent
//
//  Created by asance on 2017/9/27.
//  Copyright © 2017年 asance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBObjectDefine.h"

@class YBCloseButton;

@interface YBRemindNewVersionView : UIView
YBPropertyStrongSetter(UIView, backgroundView);
YBPropertyStrongSetter(UIView, contentView);

YBPropertyStrongSetter(UIView, whiteBGView);
YBPropertyStrongSetter(UIImageView, imageView);
YBPropertyStrongSetter(UILabel, titleLabel);

YBPropertyStrongSetter(YBCloseButton, cancelButton);
YBPropertyStrongSetter(UIView, cancelLineView);
YBPropertyStrongSetter(UIButton, confirmButton);

YBPropertyStrongSetter(UITableView, myTableView);
YBPropertyStrongSetter(NSMutableArray, myDataSource);

@property(copy, nonatomic) void(^onCancelBlock)(void);
@property(copy, nonatomic) void(^onConfirmBlock)(void);

- (void)setTitle:(NSString *)title
         content:(NSString *)content
      mustUpdate:(BOOL)mustUpdate;

- (void)startAnimationing;
- (void)stopAnimaitoning;

@end
