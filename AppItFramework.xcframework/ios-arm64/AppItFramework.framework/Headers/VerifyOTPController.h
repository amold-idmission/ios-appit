//
//  VerifyOTPController.h
//  AppItFramework
//
//  Created by  on 11/09/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppItSDK.h"
#import "NSLogUtils.h"
#import "Reachability.h"

@interface VerifyOTPController : UIViewController {
    
}
@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) NSString *receivedOTP;
@end
