//
//  MatchFaceViewController.h
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 07/07/16.
//  Copyright © 2016 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImporter.h"

@interface MatchFaceViewController : UIViewController<NSXMLParserDelegate>{
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
}

@property(nonatomic,assign)id delegate;

@property(nonatomic) NSMutableDictionary *resultDictionary;
@property (nonatomic) NSMutableDictionary *employeeDictionary;

@end
