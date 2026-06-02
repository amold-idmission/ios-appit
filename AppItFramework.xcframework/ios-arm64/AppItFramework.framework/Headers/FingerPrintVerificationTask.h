//
//  FingerPrintVerificationTask.h
//  AppItFramework
//
//  Created by  on 12/03/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImporter.h"
#import <Foundation/Foundation.h>
#import "ResultData.h"

@interface FingerPrintVerificationTask : UIViewController {
    
}
@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)bool isFinalSubmit;
@property(nonatomic) NSMutableDictionary *resultDictionary;

+(NSString *)getBiometricVerificationXMLNode;
@end
