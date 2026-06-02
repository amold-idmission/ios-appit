//
//  UpdateEmployeeViewController.h
//  AppItFramework
//
//  Created by  on 11/02/19.
//  Copyright © 2019 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppItSDK.h"
#import "NSLogUtils.h"
#import "Reachability.h"

@interface UpdateEmployeeViewController : UIViewController{
    
}
@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) NSMutableDictionary *employeeDictionary;
@property (nonatomic) bool isFinalSubmit;
@end
