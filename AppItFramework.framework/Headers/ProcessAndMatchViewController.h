//
//  ProcessAndMatchViewController.h
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 21/10/16.
//  Copyright © 2016 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImporter.h"

@interface ProcessAndMatchViewController : UIViewController<NSXMLParserDelegate>{

    IBOutlet UIActivityIndicatorView *uiActivityIndicator;

}

@property(nonatomic,assign)id delegate;
@property(nonatomic) NSString* countryCode;
@property(nonatomic) NSString* stateCode;
@property(nonatomic) NSString* idType;
@property(nonatomic) NSString* matchDocumentType;

@property(nonatomic) NSMutableDictionary *resultDictionary;
@property (nonatomic) NSMutableDictionary *employeeDictionary;

@end
