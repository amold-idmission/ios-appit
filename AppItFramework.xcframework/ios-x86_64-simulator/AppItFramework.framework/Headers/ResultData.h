//
//  ResultData.h
//  AppItFramework
//
//  Created by  on 09/03/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppItSDK.h"

@interface ResultData : NSObject

//@property(nonatomic) NSMutableDictionary *resultImageDictionary;

+(void)setFingerprintImageDictionary:(NSMutableDictionary*)resultImageData ;
+(NSMutableDictionary *)getFingerprintImageDictionary;
+(void)addFingerprintImageDictionary:(NSMutableDictionary*)resultImageData ;
+(NSMutableDictionary *)getImageConfigJSONValue;
+(void)putImageConfigJSONValue:(NSString*)key value:(NSMutableDictionary*)value isFinishRetry:(BOOL)isFinishRetry;
+(void)clearImageConfigJSONValue;
+(void)setVoiceData:(NSString*)voicedata;
+(NSString*)getVoiceData;
@end
