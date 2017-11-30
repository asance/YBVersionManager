//
//  YBRemindNewVersionView.h
//  YoubanAgent
//
//  Created by asance on 2017/9/27.
//  Copyright © 2017年 asance. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBCloseButton;

@interface YBRemindNewVersionView : UIView
@property(strong, nonatomic) UIView *backgroundView;
@property(strong, nonatomic) UIView *contentView;

@property(strong, nonatomic) UIView *whiteBGView;
@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UILabel *titleLabel;

@property(strong, nonatomic) YBCloseButton *cancelButton;
@property(strong, nonatomic) UIView *cancelLineView;
@property(strong, nonatomic) UIButton *confirmButton;

@property(strong, nonatomic) UITableView *myTableView;
@property(strong, nonatomic) NSMutableArray *myDataSource;

@property(copy, nonatomic) void(^onCancelBlock)(void);
@property(copy, nonatomic) void(^onConfirmBlock)(void);

- (void)setTitle:(NSString *)title
         content:(NSString *)content
      mustUpdate:(BOOL)mustUpdate;

- (void)startAnimationing;
- (void)stopAnimaitoning;

@end
