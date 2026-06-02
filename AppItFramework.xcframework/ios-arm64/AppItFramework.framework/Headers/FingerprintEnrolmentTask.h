//
//  FingerprintEnrolmentTask.h
//  AppItFramework
//
//  Created by  on 08/03/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImporter.h"
#import <Foundation/Foundation.h>
#import "ResultData.h"
#import "NSStringUtils.h"

@interface FingerprintEnrolmentTask : UIViewController {
    
}

+(NSString *)getBiometricEnrolmentXMLNode;
+(NSString *)generateFingerprintJSON;

@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)bool isFinalSubmit;
@property (nonatomic) NSMutableDictionary *employeeDictionary;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@end
