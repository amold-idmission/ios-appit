//
//  VerifyCustomerViewController.h
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 10/03/17.
//  Copyright © 2017 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImporter.h"

@interface VerifyCustomerViewController : UIViewController<NSXMLParserDelegate>{

}

@property(nonatomic,assign)id delegate;

@property(nonatomic) NSMutableDictionary *resultDictionary;

@end
