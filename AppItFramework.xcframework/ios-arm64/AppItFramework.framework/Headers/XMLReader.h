//
//  XMLReader.h
//
//  Created by Troy on 9/18/10.
//  Copyright 2010 Troy Brant. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "xsltInternals.h"
#include "transform.h"
#include "xsltutils.h"
#import "exslt.h"

@interface XMLReader : NSObject
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *errorPointer;
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError *)errorPointer;
- (NSString *) transform:(NSString *)xml xsl:(NSString *)xsl;
- (NSString *) transform_mrz:(NSString *)xml;
+ (NSString *) replaceSpecialCharacters:(NSString*) string;
+ (void) initSpecialCharactersArray;
@end
