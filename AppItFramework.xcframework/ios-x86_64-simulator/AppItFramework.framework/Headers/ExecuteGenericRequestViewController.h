//
//  ExecuteGenericRequestViewController.h
//  AppItFramework
//
//  Created by  on 17/12/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImporter.h"

@interface ExecuteGenericRequestViewController : UIViewController<NSXMLParserDelegate>{
    
}
@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *customProductDefination;
@property (nonatomic) NSMutableDictionary *additionalDictionary;
@property (nonatomic) NSMutableDictionary *employeeDictionary;
@property(nonatomic) BOOL isClearFormKey;
@property(nonatomic) BOOL isFinalSubmit;

@property(nonatomic) NSMutableDictionary *resultDictionary;


@end
