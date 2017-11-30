//
//  YBVersionManager.h
//  test_CodeReview
//
//  Created by asance on 2017/10/14.
//  Copyright © 2017年 asance. All rights reserved.
//

#define YB_OPEN_SEVER_CHECK     0

#import <Foundation/Foundation.h>
#import "YBObjectDefine.h"

@interface YBVersionManager : NSObject
YBPropertyAssignSetter(BOOL, didCheckVersion);
/**return name of company*/
YBPropertyCopySetter(NSString, company);
/**return name of app display*/
YBPropertyCopySetter(NSString, displayName);
/**return name of loan authorization agreement*/
YBPropertyCopySetter(NSString, loanAuthorizationAgreementName);
/**return hotline of company*/
YBPropertyCopySetter(NSString, hotline);
/**return wei xin gong zhong hao of company*/
YBPropertyCopySetter(NSString, wxgzh);
/**return zhi fu bao zhang hao of company*/
YBPropertyCopySetter(NSString, zfbzh);
/**return production environment download url*/
YBPropertyCopySetter(NSString, productionEnvUpdateURL);
/**return test environment download url*/
YBPropertyCopySetter(NSString, testEnvUpdateURL);
/**return production environment Appraise url*/
YBPropertyCopySetter(NSString, productionEnvAppraiseURL);
/**return APPID*/
YBPropertyCopySetter(NSString, APPID);

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
