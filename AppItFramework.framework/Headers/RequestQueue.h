//
//  RequestQueue.h
//  AppItFramework
//
//  Created by  on 15/03/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestQueue : NSObject

extern NSString const *REQ_PROCESS_IMAGE, *REQ_MATCH_FACE, *REQ_PROCESS_IMAGE_MATCH_FACE, *REQ_VERIFY_CUSTOMER, *REQ_COMPLETE_OPERATION;

+(NSMutableDictionary*)requestQueue;

+(void)setRequestRunning:(NSString*)reqType;
+(void)setRequestComplete:(NSString*)reqType;
+(BOOL)isRequestAlreadyRunning:(NSString*)reqType;
+(BOOL)isSafeToExecuteRequest:(NSString*)reqType;

@end
