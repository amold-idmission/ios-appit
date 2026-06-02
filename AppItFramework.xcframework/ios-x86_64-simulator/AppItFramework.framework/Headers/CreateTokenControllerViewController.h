//
//  CreateTokenControllerViewController.h
//  AppItFramework
//
//  Created by  on 25/06/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppItSDK.h"
#import "NSLogUtils.h"
#import "Reachability.h"

@interface CreateTokenControllerViewController : UIViewController {
    
}
@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) NSString *employeeCode;
@property (nonatomic) bool isFinalSubmit;
+(NSString*)generateTokenXMLNode;
@end

