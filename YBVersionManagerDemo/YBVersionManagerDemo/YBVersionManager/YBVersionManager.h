//
//  YBVersionManager.h
//  test_CodeReview
//
//  Created by asance on 2017/10/14.
//  Copyright © 2017年 asance. All rights reserved.
//

#define YB_OPEN_SEVER_CHECK     0

#import <Foundation/Foundation.h>

@interface YBVersionManager : NSObject
@property(assign, nonatomic) BOOL didCheckVersion;
/**return name of company*/
@property(copy, nonatomic) NSString *company;
/**return name of app display*/
@property(copy, nonatomic) NSString *displayName;
/**return name of loan authorization agreement*/
@property(copy, nonatomic) NSString *loanAuthorizationAgreementName;
/**return hotline of company*/
@property(copy, nonatomic) NSString *hotline;
/**return wei xin gong zhong hao of company*/
@property(copy, nonatomic) NSString *wxgzh;
/**return zhi fu bao zhang hao of company*/
@property(copy, nonatomic) NSString *zfbzh;
/**return production environment download url*/
@property(copy, nonatomic) NSString *productionEnvUpdateURL;
/**return test environment download url*/
@property(copy, nonatomic) NSString *testEnvUpdateURL;
/**return production environment Appraise url*/
@property(copy, nonatomic) NSString *productionEnvAppraiseURL;
/**return APPID*/
@property(copy, nonatomic) NSString *APPID;

/**单例对象*/
+ (instancetype)shareInstance;

/**
 * Is the release version,
 * If not for release, to avoid being rejected,
 * Do not call the address book permissions.
 */
+ (BOOL)isPublishVersion;

/**to appraise current version for app*/
+ (void)toAppraiseCurrentVersion;

/**show update view if should remind*/
+ (void)updateWithTitle:(NSString *)title
                content:(NSString *)content
                version:(NSInteger)version
                    url:(NSString *)url
             mustUpdate:(BOOL)mustUpdate;

@end
