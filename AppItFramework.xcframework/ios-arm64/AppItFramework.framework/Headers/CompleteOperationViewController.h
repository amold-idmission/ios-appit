//
//  CompleteOperationViewController.h
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 21/10/16.
//  Copyright © 2016 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImporter.h"

@interface CompleteOperationViewController : UIViewController<NSXMLParserDelegate>{

    IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property(nonatomic,assign)id delegate;

@property(nonatomic) NSMutableDictionary *resultDictionary;

@end
