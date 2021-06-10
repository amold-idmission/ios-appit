//
//  VerifyCredentialsController.h
//  AppItFramework
//
//  Created by  on 13/12/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "NSLogUtils.h"
#import "NSStringUtils.h"
#import "AppItSDK.h"
#import "GlobalGetterSetter.h"

//@interface VerifyCredentialsController : UIViewController<NSXMLParserDelegate> {
@interface VerifyCredentialsController : NSObject<NSXMLParserDelegate> {
    
}
@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) NSString *employeeCode;
@property (nonatomic) bool isFinalSubmit;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *loginID;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *merchantID;
@property (nonatomic) NSString *productID;
@property (nonatomic) NSString *productName;
@property (nonatomic) NSString *language;
@property (nonatomic) bool enableDebug;
@property (nonatomic) bool enableGPS;

+(NSString*)getModelPath;
+(NSString*)getModelPath:(NSString *)uniqueKey;
+(BOOL)isModelDownloaded;
+(void)setIsModelDownloaded:(BOOL)modelDownloaded;
+(BOOL)isIDModelDownloaded;
+(void)setIsIDModelDownloaded:(BOOL)modelDownloaded;
+(NSString *)getRequestCancelCount;
+(void)setRequestCancelCount : (NSString*)_cancelCount;

+(NSString*)getIdModelPath;
+(NSString*)getIdModelPath:(NSString *)uniqueKey;

-(id) initWithData:(id)instance loginId:(NSString *)loginId password:(NSString *)password
               url:(NSString *)url productID:(NSString *)productID merchantID:(NSString *)merchantID enableGPS:(bool)enableGPS EnableDebug:(bool)EnableDebug Language:(NSString *)Language productName:(NSString *)productName;

@end

