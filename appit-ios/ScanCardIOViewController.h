//
//  ScanCardIOViewController.h
//  appit-ios
//
//  Created by idmission solutions pvt ltd  on 13/04/16.
//  Copyright © 2016 IDMission. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIOPaymentViewControllerDelegate.h"

@interface ScanCardIOViewController : UIViewController{

}

@property(nonatomic, strong) NSString *responseStatus, *responseCardImage, *responseCardNumber, *responseCardType;

@end
