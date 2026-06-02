//
//  ProcessImageViewController.h
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 24/05/16.
//  Copyright © 2016 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImporter.h"

@interface ProcessImageViewController : UIViewController<NSXMLParserDelegate>{

    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    
}

@property(nonatomic,assign)id delegate;
@property(nonatomic) NSString* countryCode;
@property(nonatomic) NSString* stateCode;
@property(nonatomic) NSString* idType;


@property(nonatomic) NSMutableDictionary *resultDictionary;
@property (nonatomic) NSMutableDictionary *employeeDictionary;

@end
