//
//  UpdateCustomerViewController.h
//  AppItFramework
//
//  Created by  on 14/08/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppItSDK.h"
#import "NSLogUtils.h"
#import "Reachability.h"
#import "CommonImporter.h"
@interface UpdateCustomerViewController : UIViewController{
    
}
@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *hostReachability;

@end
