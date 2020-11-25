//
//  StringLabels.h
//  AppItFramework
//
//  Created by  on 30/07/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonImporter.h"

@interface StringLabels : NSObject{
    
}

+(void)initializeCurrentLabels:(NSString*)language;
+(NSString*)getLabelForKey:(NSString*)key;

@end
