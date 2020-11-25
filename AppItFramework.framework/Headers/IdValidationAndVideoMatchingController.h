//
//  IdValidationAndVideoMatchingController.h
//  AppItFramework
//
//  Created by  on 12/02/19.
//  Copyright © 2019 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImporter.h"

@interface IdValidationAndVideoMatchingController : UIViewController<NSXMLParserDelegate> {
    
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
