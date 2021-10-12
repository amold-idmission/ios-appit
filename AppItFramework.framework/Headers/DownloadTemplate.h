//
//  DownloadTemplate.h
//  AppItFramework
//
//  Created by Sanket Garde on 20/09/19.
//  Copyright © 2019 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadTemplate : NSObject<NSXMLParserDelegate> {
    
}

+(void)download_XSLT;
+(NSMutableArray *)getTemplateFieldArray;

//+(void)download_XSLT:(id)instance url:(NSString *)url appCode:(NSString *)appCode loginId:(NSString *)loginId password:(NSString *)password merchantId:(NSString *)merchantId isSDKApiCall:(BOOL)isSDKApiCall;
@end
