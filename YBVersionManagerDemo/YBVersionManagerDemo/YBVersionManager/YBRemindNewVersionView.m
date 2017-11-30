//
//  YBRemindNewVersionView.m
//  YoubanAgent
//
//  Created by asance on 2017/9/27.
//  Copyright © 2017年 asance. All rights reserved.
//

#import "YBRemindNewVersionView.h"
#import "NSNumber+LayoutAdaptation.h"
#import "UIColor+HexInt.h"
#import "YBCloseButton.h"

#define kDivisionString     (@"##")

@interface YBRemindNewVersionCellInfo : NSObject
@property(copy, nonatomic) NSString *remind;
@property(assign, nonatomic) CGFloat cellHeight;
@end

@implementation YBRemindNewVersionCellInfo

- (void)setRemind:(NSString *)remind{
    _remind = remind;
    _cellHeight = [NSNumber adaptToHeight:32 minValueEnable:YES];
    
    if(remind.length){
        CGFloat maxWidth = ([NSNumber adaptToWidth:251 minValueEnable:YES]-[NSNumber adaptToWidth:12]*4);
        CGRect rect = [remind boundingRectWithSize:CGSizeMake(maxWidth, 100)
                                           options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin)
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[NSNumber adaptToHeight:14]]}
                                           context:nil];
        _cellHeight = rect.size.height+2;
        _cellHeight = MAX([NSNumber adaptToHeight:32 minValueEnable:YES], _cellHeight);
    }
}

@end

@interface YBRemindNewVersionCell : UITableViewCell
@property(strong, nonatomic) UILabel *remindLabel;
@end

@implementation YBRemindNewVersionCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.remindLabel];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = self.contentView.frame.size.height;
    CGFloat leftMargin = [NSNumber adaptToWidth:12];
    self.remindLabel.frame = CGRectMake(leftMargin, 0, width-leftMargin*2, height);
}

- (UILabel *)remindLabel{
    if(!_remindLabel){
        _remindLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _remindLabel.font = [UIFont systemFontOfSize:[NSNumber adaptToHeight:14]];
        _remindLabel.textColor = [UIColor hexColor:@"666666"];
        _remindLabel.textAlignment = NSTextAlignmentLeft;
        _remindLabel.backgroundColor = [UIColor whiteColor];
        _remindLabel.numberOfLines = 0;
        _remindLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _remindLabel;
}

@end

@interface YBRemindNewVersionView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YBRemindNewVersionView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self addSubview:self.backgroundView];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.cancelLineView];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.whiteBGView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.myTableView];
        [self.contentView addSubview:self.confirmButton];
    }
    return self;
}

- (void)setTitle:(NSString *)title content:(NSString *)content mustUpdate:(BOOL)mustUpdate{
    [self.myDataSource removeAllObjects];
    if(title.length){
        self.titleLabel.text = title;
    }
    if(content.length){
        NSArray *reminds = [content componentsSeparatedByString:kDivisionString];
        for(NSInteger i=0;i<reminds.count;i++){
            NSString *remind = reminds[i];
            if(0==remind.length){
                continue;
            }
            YBRemindNewVersionCellInfo *label = [[YBRemindNewVersionCellInfo alloc] init];
            label.remind = remind;
            [self.myDataSource addObject:label];
        }
        if(0==self.myDataSource.count){
            YBRemindNewVersionCellInfo *label = [[YBRemindNewVersionCellInfo alloc] init];
            label.remind = @"1、提高用户体验";
            [self.myDataSource addObject:label];
        }
    }
    else{
        YBRemindNewVersionCellInfo *label = [[YBRemindNewVersionCellInfo alloc] init];
        label.remind = @"1、提高用户体验";
        [self.myDataSource addObject:label];
    }
    
    self.cancelButton.hidden = NO;
    self.cancelLineView.hidden = NO;
    if(mustUpdate){
        self.cancelButton.hidden = YES;
        self.cancelLineView.hidden = YES;
    }
    
    self.myTableView.scrollEnabled = NO;
    if(2<self.myDataSource.count){
        self.myTableView.scrollEnabled = YES;
    }
    [self.myTableView reloadData];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


#pragma mark - Button Action
- (void)onCancelAction{
    if(self.onCancelBlock){
        self.onCancelBlock();
    }
    [self removeFromSuperviewAfterSeconds];
}
- (void)onConfirmAction{
    if(self.onConfirmBlock){
        self.onConfirmBlock();
    }
}

- (void)removeFromSuperviewAfterSeconds{
    [self stopAnimaitoning];
    
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC);
    dispatch_after(timer, dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
#pragma mark - Public Mehtod
- (void)startAnimationing{
    self.contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.backgroundView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.contentView.transform = CGAffineTransformMakeScale(1, 1);
                         self.backgroundView.alpha = 0.5f;
                     }
                     completion:nil];
}
- (void)stopAnimaitoning{
    [UIView animateWithDuration:0.2f
                          delay:0.0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{self.alpha = 0.0f;}
                     completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myDataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YBRemindNewVersionCellInfo *info = [self.myDataSource objectAtIndex:indexPath.row];
    return info.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YBRemindNewVersionCellInfo *info = [self.myDataSource objectAtIndex:indexPath.row];
    NSString *identifier = @"YBRemindNewVersionCell";
    YBRemindNewVersionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.remindLabel.text = info.remind;
    
    return cell;
}

#pragma mark -
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
    
    CGFloat titleLabelHeight = 40;
    CGFloat remindHeight = ([NSNumber adaptToHeight:32 minValueEnable:YES]*3);
    CGFloat imageHeight = [NSNumber adaptToHeight:135 minValueEnable:YES];
    CGFloat buttonHeight = [NSNumber adaptToHeight:40 minValueEnable:YES];
    
    CGFloat contentWidth = ([NSNumber adaptToWidth:251 minValueEnable:YES]);
    CGFloat contentHeight = titleLabelHeight;
    
    contentHeight += remindHeight;
    contentHeight += 10;
    contentHeight += buttonHeight;
    contentHeight += imageHeight;
    contentHeight += 15;
    
    CGFloat leftMargin = [NSNumber adaptToWidth:12];
    
    self.contentView.frame = CGRectMake(0, 0, contentWidth,contentHeight);
    self.contentView.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    
    self.imageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width,imageHeight);
    
    CGFloat whiteBGViewTop = CGRectGetMaxY(self.imageView.frame);
    self.whiteBGView.frame = CGRectMake(0, whiteBGViewTop, self.contentView.frame.size.width,contentHeight-whiteBGViewTop);
    
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.contentView.frame.size.width,titleLabelHeight);
    
    self.myTableView.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.titleLabel.frame), contentWidth-leftMargin*2, remindHeight);
    
    self.confirmButton.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.myTableView.frame)+10, self.myTableView.frame.size.width,buttonHeight);
    
    CGFloat cancelButtonWidth = 28;
    self.cancelButton.frame = CGRectMake(contentWidth-cancelButtonWidth, 0, cancelButtonWidth,cancelButtonWidth);
    self.cancelButton.layer.cornerRadius = (cancelButtonWidth*0.5);
    
    self.cancelLineView.frame = CGRectMake(0, CGRectGetMaxY(self.cancelButton.frame), 1,150);
    self.cancelLineView.center = CGPointMake(self.cancelButton.center.x, self.cancelLineView.center.y);
}

#pragma mark - Getter Setter
- (UIView *)backgroundView{
    if(!_backgroundView){
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.6;
    }
    return _backgroundView;
}
- (UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.8, [NSNumber adaptToHeight:250 minValueEnable:YES])];
        _contentView.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.clipsToBounds = YES;
        _contentView.layer.cornerRadius = 8;
    }
    return _contentView;
}
- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.userInteractionEnabled = YES;
        _imageView.image = [UIImage imageNamed:@"update_bg"];
    }
    return _imageView;
}
- (UIView *)whiteBGView{
    if(!_whiteBGView){
        _whiteBGView = [[UIView alloc] initWithFrame:CGRectZero];
        _whiteBGView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBGView;
}
- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:[NSNumber adaptToHeight:16]];
        _titleLabel.textColor = [UIColor hexColor:@"0099ff"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.text = @"发现新内容";
    }
    return _titleLabel;
}
- (UIView *)cancelLineView{
    if(!_cancelLineView){
        _cancelLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _cancelLineView.backgroundColor = [UIColor hexColor:@"ffffff" alpha:0.5];
    }
    return _cancelLineView;
}
- (YBCloseButton *)cancelButton{
    if(!_cancelButton){
        _cancelButton = [YBCloseButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:[NSNumber adaptToHeight:14]];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(onCancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton{
    if(!_confirmButton){
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.backgroundColor = [UIColor hexColor:@"0099ff"];
        _confirmButton.layer.cornerRadius = 4;
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:[NSNumber adaptToHeight:16]];
        [_confirmButton setTitle:@"马上升级" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateHighlighted];
        [_confirmButton addTarget:self action:@selector(onConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
- (UITableView *)myTableView{
    if(!_myTableView){
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        
        [_myTableView registerClass:[YBRemindNewVersionCell class] forCellReuseIdentifier:@"YBRemindNewVersionCell"];
    }
    return _myTableView;
}
- (NSMutableArray *)myDataSource{
    if(!_myDataSource){
        _myDataSource = [[NSMutableArray alloc] init];
    }
    return _myDataSource;
}

@end
