//
//  VerifyPOAClass.h
//  AppItFramework
//
//  Created by  on 14/06/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSLogUtils.h"
#import "Reachability.h"

@interface VerifyPOAClass : UIViewController<NSXMLParserDelegate> {
    
}
//-(id)initWithParameters:(NSMutableDictionary*)initaddJSONDictionary;
@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) NSMutableDictionary *additionalAddressDict;
@property (nonatomic) bool doExtract;
@property (nonatomic) bool doVerify;
@property (nonatomic) bool isFinalSubmit;
@end
