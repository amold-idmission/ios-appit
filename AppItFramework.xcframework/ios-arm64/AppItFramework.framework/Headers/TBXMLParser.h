//
//  TBXMLParser.h
//  AppItFramework
//
//  Created by Dipen Patel on 16/04/20.
//  Copyright © 2020 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

NS_ASSUME_NONNULL_BEGIN

@interface TBXMLParser : NSObject{
    
}

-(void)initParameter;
    
- (void) traverseElement:(TBXMLElement *)element resultDictionary:(NSMutableDictionary *)resultDictionary_ keyArray:(NSMutableArray *)keyArray isToSetProcessedImage:(bool)isToSetProcessedImage;

@end

NS_ASSUME_NONNULL_END
