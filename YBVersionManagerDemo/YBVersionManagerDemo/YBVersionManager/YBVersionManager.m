//
//  YBVersionManager.m
//  test_CodeReview
//
//  Created by asance on 2017/10/14.
//  Copyright © 2017年 asance. All rights reserved.
//

#import "YBVersionManager.h"
#import "YBRemindNewVersionView.h"
#import "YBKeychain.h"

#define kKeychainServerAPPVersion       (@"kKeychainServerAPPVersion")

@implementation YBVersionManager

+ (instancetype)shareInstance{
    static YBVersionManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareInstance = [[YBVersionManager alloc] init];
        shareInstance.productionEnvUpdateURL = @"https://itunes.apple.com/us/app/id1270143054?ls=1&mt=8";
        shareInstance.productionEnvAppraiseURL = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1270143054";
        shareInstance.testEnvUpdateURL = @"https://www.pgyer.com/ddkq";
        shareInstance.APPID = @"1270143054";
    });
    return shareInstance;
}
+ (BOOL)isPublishVersion{
    //如果服务器版本号>本地版本号，则是发布版本，其需要上报所有流水号
    NSString *serverVersion = [YBKeychain passwordForService:kKeychainService account:kKeychainServerAPPVersion];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appBuildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSInteger serverVersionInt = (serverVersion.length?(serverVersion.integerValue):0);
    NSInteger appBuildVersionInt = (appBuildVersion.length?(appBuildVersion.integerValue):0);
    
    if(serverVersionInt>=appBuildVersionInt){
        return YES;
    }
    return NO;
}

- (NSString *)company{
    if(_company.length){
        return _company;
    }
    if(NO==[YBVersionManager isPublishVersion]){
        return @"深圳市优办互联网金融服务有限公司";
    }
    else{
        return @"深圳市嘀嘀快钱互联网金融服务有限公司";
    }
}
- (NSString *)displayName{
    if(_displayName.length){
        return _displayName;
    }
    if(NO==[YBVersionManager isPublishVersion]){
        return @"滴滴快钱";
    }
    else{
        return @"嘀嘀快钱";
    }
}
- (NSString *)loanAuthorizationAgreementName{
    if(_loanAuthorizationAgreementName.length){
        return _loanAuthorizationAgreementName;
    }
    if(NO==[YBVersionManager isPublishVersion]){
        return @"滴滴快钱借款授权综合协议";
    }
    else{
        return @"嘀嘀快钱借款授权综合协议";
    }
}
- (NSString *)hotline{
    if(_hotline.length){
        return _hotline;
    }
    return @"0755-26914693";
}
- (NSString *)wxgzh{
    if(_wxgzh.length){
        return _wxgzh;
    }
    return @"ddkqfw";
}
- (NSString *)zfbzh{
    if(_zfbzh.length){
        return _zfbzh;
    }
    return @"ddkuaiqian@126.com";
}
- (void)setAPPID:(NSString *)APPID{
    if(0==APPID.length){
        return;
    }
    _APPID = [APPID copy];
    self.productionEnvUpdateURL = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8",APPID];
}
+ (void)toAppraiseCurrentVersion{
    
    NSString *urlStr = [YBVersionManager shareInstance].APPID;
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if([[UIApplication sharedApplication] canOpenURL:url]){
        if(YES==[[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]){
            NSDictionary *options = @{};
            [[UIApplication sharedApplication] openURL:url options:options completionHandler:^(BOOL success) {}];
        }
        else{
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

+ (void)updateWithTitle:(NSString *)title
                content:(NSString *)content
                version:(NSInteger)version
                    url:(NSString *)url
             mustUpdate:(BOOL)mustUpdate{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    //保存服务器app版本号
    NSString *serverVersionString = [NSString stringWithFormat:@"%@",@(version)];
    [YBKeychain setPassword:serverVersionString forService:kKeychainService account:kKeychainServerAPPVersion];
    
    // app build版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appBuildString = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSInteger buildVersion = [appBuildString integerValue];
    if(version>buildVersion){
        YBRemindNewVersionView *view = [[YBRemindNewVersionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        view.center = CGPointMake(screenWidth*0.5, screenHeight*0.5);
        view.onConfirmBlock = ^() {
            NSString *oriURL = [YBVersionManager shareInstance].productionEnvUpdateURL;
#if YB_OPEN_SEVER_CHECK
            oriURL = [YBVersionManager shareInstance].testEnvUpdateURL;
#endif
            NSURL *gURL = [NSURL URLWithString:oriURL];
            if([[UIApplication sharedApplication] canOpenURL:gURL]){
                if(YES==[[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]){
                    NSDictionary *options = @{};
                    [[UIApplication sharedApplication] openURL:gURL options:options completionHandler:^(BOOL success) {}];
                }
                else{
                    [[UIApplication sharedApplication] openURL:gURL];
                }
            }
        };
        view.onCancelBlock = ^{
        };
        view.alpha = 0;
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        [view setTitle:title content:content mustUpdate:mustUpdate];
        
        dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 0.2f*NSEC_PER_SEC);
        dispatch_after(timer, dispatch_get_main_queue(), ^{
            view.alpha = 1;
            [view startAnimationing];
        });
    }
}
@end
