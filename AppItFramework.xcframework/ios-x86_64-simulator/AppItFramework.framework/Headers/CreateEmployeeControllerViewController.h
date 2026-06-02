//
//  CreateEmployeeControllerViewController.h
//  AppItFramework
//
//  Created by  on 22/06/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppItSDK.h"
#import "NSLogUtils.h"
#import "Reachability.h"

@interface CreateEmployeeControllerViewController : UIViewController {
    
}
@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) NSMutableDictionary *employeeDictionary;
@property (nonatomic) bool isFinalSubmit;
@end
