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

+(NSString*)getFaceModelPath;
+(NSString*)getFaceModelPath:(NSString *)uniqueKey;
+(BOOL)isFaceModelDownloaded;
+(void)setIsFaceModelDownloaded:(BOOL)modelDownloaded;

+(NSString*)getIdModelPath;
+(NSString*)getIdModelPath:(NSString *)uniqueKey;
+(BOOL)isIDModelDownloaded;
+(void)setIsIDModelDownloaded:(BOOL)modelDownloaded;

-(id)initWithData:(id)instance loginId:(NSString *)loginId password:(NSString *)password url:(NSString *)url productID:(NSString *)productID merchantID:(NSString *)merchantID enableGPS:(bool)enableGPS EnableDebug:(bool)EnableDebug Language:(NSString *)Language productName:(NSString *)productName;

+(void)sendKeyCloak_TokenRequest:(NSString*)captureEntityType isrealORspoof:real_spoof_string outFileDirectoryPath:outFileDirectoryPath;
+(NSString*)getKeyclokFaceUsername;
+(NSString*)getKeyclokFacePassword;
+(NSString*)getKeyclokIDUsername;
+(NSString*)getKeyclokIDPassword;

@end

