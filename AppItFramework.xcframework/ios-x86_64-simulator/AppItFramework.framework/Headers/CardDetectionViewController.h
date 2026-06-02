//
//  CardDetectionViewController.h
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 31/01/17.
//  Copyright © 2017 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIOPaymentViewControllerDelegate.h"
#import "CommonImporter.h"

@interface CardDetectionViewController : UIViewController

@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;

@end
