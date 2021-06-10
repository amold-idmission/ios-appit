//
//  GetTemplateInfoTask.h
//  AppItFramework
//
//  Created by Dipen Patel on 25/02/20.
//  Copyright © 2020 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TemplateFieldValues.h"
#import "OCRLayoutDefs.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetTemplateInfoTask : NSObject<NSXMLParserDelegate>{
    
}

+(void) download_Template_info;
+(NSMutableArray *)getTemplateInfoArray;

+(TemplateFieldValues *) getXsltNodeForBarcode:(NSString *)country state:(NSString *)state doc_type:(NSString *)doc_type imagesTypes:(NSString *)imagesTypes;

+(OCRLayoutDefs *) isTemplateFoundForMRZ:(NSString *)country state:(NSString *)state doc_type:(NSString *)doc_type imagesTypes:(NSString *)imagesTypes;

+(OCRLayoutDefs *) isExtractTemplate:(NSString *)country state:(NSString *)state doc_type:(NSString *)doc_type side:(NSString *)side;

@end

NS_ASSUME_NONNULL_END
