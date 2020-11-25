//
//  BarCodeParser.mm
//  appit-ios
//
//  Created by idmission on 02/07/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLReader.h"

#include "BarCodeParser.h"

NSArray* MRZ_WEIGHTS = @[@7,@3,@1];

@interface BarCodeParser ()
@end

@implementation BarCodeParser {
    NSString *statusCode;
}

- (NSString* ) parse_text:(NSString*) text xsl:(NSString *)xslText{
    NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
    NSArray *rows = [text componentsSeparatedByCharactersInSet:separator];
    NSString* xmlText = @"";
    if ([rows count] > 0) {
        NSMutableArray *records = [NSMutableArray array];
        for (NSString *row in rows){
            if ([row length] != 0) {
                NSString *trimmedRow = [row stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ([trimmedRow length] != 0) {
                    trimmedRow = [self esacpeXML:trimmedRow];
                    NSString *record = [NSString stringWithFormat:@"<Record>%@</Record>", trimmedRow];
                    [records addObject:record];
                }
            }
        }
        NSString *recordsString = [records componentsJoinedByString:@"\n"];
        xmlText = [NSString stringWithFormat:@"<Records>%@</Records>", recordsString];
        
        NSUInteger xmlTextLength = [xmlText length];
        unichar buffer[xmlTextLength+1];
        
        [xmlText getCharacters:buffer range:NSMakeRange(0, xmlTextLength)];

        NSMutableString *correctedXmlText = nil;
        correctedXmlText = [@"" mutableCopy];
        for(int i = 0; i < xmlTextLength; i++) {
            if([self isLegalXmlChar:buffer[i]]){
                NSString* character = [NSString stringWithFormat:@"%c" , buffer[i]];
                [correctedXmlText appendString:character];
            }
        }
        
        //xsl transform
        XMLReader *reader = [XMLReader alloc];
        if ( ![xslText isEqualToString: @""] ) {
            xmlText = [reader transform:correctedXmlText xsl:xslText];
            xmlText = [self convert_to_components:xmlText];
        }
    }
    return xmlText;
}

-(NSString* ) esacpeXML:(NSString*) text{
    text = [text stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    text = [text stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return text;
}

- (bool) isLegalXmlChar:(int) character {
    return (character == 0x9 || character == 0xA
    || character == 0xD
            || (character >= 0x20 && character <= 0xD7FF)
            || (character >= 0xE000 && character <= 0xFFFD) || (character >= 0x10000
                                                                && character <= 0x10FFFF));
}

-(NSString* ) convert_to_components:(NSString*) xml{
    NSMutableString *componentXmlText = nil;
    componentXmlText = [@"" mutableCopy];

    NSError *error;
    NSDictionary *xmlData = [XMLReader dictionaryForXMLString:xml error:error];
    if (([xmlData count] > 0)){
        xmlData = [xmlData objectForKey:@"IDData"];
        if (([xmlData count] > 0)){
            NSDictionary* valueData;
            NSString* value;
            for (NSString* key in xmlData) {
                if ([[xmlData objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                    valueData = [xmlData objectForKey:key];
                    value = [valueData objectForKey:@"text"];
                    value = [self correct_value:value];
                    [self create_component:componentXmlText key:key value:value];
                }
            }
        }

    }
    
    return componentXmlText;
}

- (NSString* ) parse_mrz_text:(NSString*) text{
    NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
    NSArray *rows = [text componentsSeparatedByCharactersInSet:separator];
    NSString* xmlText = @"";
    if ([rows count] > 0) {
        NSMutableArray *records = [NSMutableArray array];
        for (NSString *row in rows){
            if ([row length] != 0) {
                NSString *trimmedRow = [row stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ([trimmedRow length] != 0) {
                    trimmedRow = [trimmedRow stringByReplacingOccurrencesOfString:@"<"
                                                                       withString:@"&lt;"];

                    NSString *record = [NSString stringWithFormat:@"<Record>%@</Record>", trimmedRow];
                    [records addObject:record];
                }
            }
        }
        NSString *recordsString = [records componentsJoinedByString:@"\n"];
        xmlText = [NSString stringWithFormat:@"<Records>%@</Records>", recordsString];
        
        NSUInteger xmlTextLength = [xmlText length];
        unichar buffer[xmlTextLength+1];
        
        [xmlText getCharacters:buffer range:NSMakeRange(0, xmlTextLength)];
        
        NSMutableString *correctedXmlText = nil;
        correctedXmlText = [@"" mutableCopy];
        for(int i = 0; i < xmlTextLength; i++) {
            if([self isLegalXmlChar:buffer[i]]){
                NSString* character = [NSString stringWithFormat:@"%c" , buffer[i]];
                [correctedXmlText appendString:character];
            }
        }
        
        //xsl transform
        XMLReader *reader = [XMLReader alloc];
        xmlText = [reader transform_mrz:correctedXmlText];
        xmlText = [self convert_to_mrz_components:xmlText];
    }
    return xmlText;
}

-(NSString* ) convert_to_mrz_components:(NSString*) xml{
    NSMutableString *componentXmlText = nil;
    componentXmlText = [@"" mutableCopy];
    
    NSMutableString *mrzErrorMessages = nil;
    mrzErrorMessages = [@"" mutableCopy];
    
    NSError *error;
    NSDictionary *xmlData = [XMLReader dictionaryForXMLString:xml error:error];
    if (([xmlData count] > 0)){
        xmlData = [xmlData objectForKey:@"IDData"];
        if (([xmlData count] > 0)){
            NSDictionary* valueData;
            NSString* value;
            NSString* mrzValue;
            NSString* checkDigitFieldName;
            NSString *lastName, *firstName = @"", *validlength = @"";
            for (NSString* key in xmlData) {
                if ([[xmlData objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                    valueData = [xmlData objectForKey:key];
                    value = [valueData objectForKey:@"text"];
                    value = [self correct_value:value];
                    mrzValue = nil;
                    if ([key isEqualToString:@"DateofBirth"]) {
                        NSDictionary* mrzValueData = [xmlData objectForKey:@"DateofBirthMRZ"];
                        mrzValue = [mrzValueData objectForKey:@"text"];
                        mrzValue = [self correct_value:mrzValue];
                        checkDigitFieldName=@"DateofBirthCheckDigit";
                    }else if ([key isEqualToString:@"IDNumber"]) {
                        mrzValue = value;
                        checkDigitFieldName=@"IDNumberCheckDigit";
                    }else if ([key isEqualToString:@"ExpiryDate"]) {
                        NSDictionary* mrzValueData = [xmlData objectForKey:@"ExpiryDateMRZ"];
                        mrzValue = [mrzValueData objectForKey:@"text"];
                        mrzValue = [self correct_value:mrzValue];
                        checkDigitFieldName=@"ExpiryCheckDigit";
                    }else if ([key isEqualToString:@"IDNumber2"]) {
                        mrzValue = value;
                        checkDigitFieldName=@"IDNumber2CheckDigit";
                    }else if ([key isEqualToString:@"FinalCheckDigitString"]) {
                        mrzValue = value;
                        checkDigitFieldName=@"CheckDigit";
                    }else if ([key isEqualToString:@"LastName"]) {
                        lastName = value;
                    }else if ([key isEqualToString:@"FirstName"]) {
                        firstName = value;
                    }else if ([key isEqualToString:@"ValidLength"]) {
                        validlength = value;
                    }

                    if (mrzValue != nil) {
                        [self validateCheckDigitFor:key mrzValue:mrzValue checkDigitFieldName:checkDigitFieldName
                                   mrzErrorMessages:mrzErrorMessages xmlData:xmlData];
                    }
                    [self create_component:componentXmlText key:key value:value];
                }
            }
            
            if ([validlength isEqualToString:@"N"]) {
                NSString* errorMessage = [NSString stringWithFormat:@" Number of character mismatch "];
                [mrzErrorMessages appendString:errorMessage];
            }
            
            //append error messages and MRZ Valid component
            if (![mrzErrorMessages isEqualToString:@""]) {
                [self create_component:componentXmlText key:@"MRZValid" value:@"N"];
                
                [self create_component:componentXmlText key:@"MRZErrorMessages" value:mrzErrorMessages];
            }else{
                [self create_component:componentXmlText key:@"MRZValid" value:@"Y"];
            }
            
            //Create Name from LastName and FirstName
            if (![lastName isEqualToString:@""] || ![firstName isEqualToString:@""]) {
                NSString* value = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                [self create_component:componentXmlText key:@"Name" value:value];
            }
        }
        
    }
    
    return componentXmlText;
}

-(void) create_component:(NSMutableString*) componentXmlText key:(NSString*) key value:(NSString*) value {
    NSString* keyText = [NSString stringWithFormat:@"%@%@%@", @"<Name>", key,@"</Name>\n"];
    NSString* valueText = [NSString stringWithFormat:@"%@%@%@", @"<Value>", value,@"</Value>\n"];
    NSString* componentText = [NSString stringWithFormat:@"%@%@%@%@", @"<Component>\n", keyText, valueText,@"</Component>\n"];
    [componentXmlText appendString:componentText];
}

-(NSString *)correct_value:(NSString*) value{
    NSString* correcteValue = [value stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    correcteValue = [correcteValue stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@" "];
    correcteValue = [correcteValue stringByTrimmingCharactersInSet:charset];
    correcteValue = [XMLReader replaceSpecialCharacters:correcteValue];
    return correcteValue;
}

- (void) validateCheckDigitFor:(NSString*) fieldName mrzValue:(NSString*) mrzValue checkDigitFieldName:(NSString*) checkDigitFieldName  mrzErrorMessages:(NSMutableString*) mrzErrorMessages xmlData:(NSDictionary*) xmlData{
    NSError* error = nil;
    NSDictionary* checkDigitData = [xmlData objectForKey:checkDigitFieldName];
    if(nil != checkDigitData){
        NSString* checkDigit = [checkDigitData objectForKey:@"text"];
        checkDigit = [self correct_value:checkDigit];
        if ([mrzValue length] > 0 && [checkDigit length] > 0) {
            [self validateCheckDigit:mrzValue checkDigit:[checkDigit characterAtIndex:0] fieldName:fieldName error:&error];
            if (error != nil) {
                NSString* errorMessage = [error localizedDescription];
                [mrzErrorMessages appendString:errorMessage];
            }
        }else{
            NSString* errorMessage = [NSString stringWithFormat:@"Check digit missing for field: %@ ", fieldName];
            [mrzErrorMessages appendString:errorMessage];
        }
    }
}

- (void) validateCheckDigit:(NSString*)str checkDigit:(char)checkDigit fieldName:(NSString*) fieldName error:(NSError**) error{
    NSString* correctedCheckDigit = str;
    if ([fieldName isEqualToString:@"passport number"] || [fieldName isEqualToString:@"personal number"]
        || [fieldName isEqualToString:@"mrz"] || [fieldName isEqualToString:@"document number"]) {
        // correctedCheckDigit = str.replaceAll("[<>]", "");
    } else {
        correctedCheckDigit = [self correctNumberString:str];
    }
    char digit = (char) [self computeCheckDigit:correctedCheckDigit] + '0';
    NSString* correctedCheckDigitData = [correctedCheckDigit stringByReplacingOccurrencesOfString:@"[<>]"
                                                       withString:@""];

    if ([fieldName isEqualToString:@"personal number"] && digit != checkDigit
        && [correctedCheckDigitData length] == 0) {
        checkDigit = digit;
    }
    if (digit != checkDigit || (checkDigit != '<' && checkDigit != '0' && digit == '0')) {
        NSString* errorMessage = [NSString stringWithFormat:@"Check digit verification failed for %@: expected %c but got %c", fieldName, checkDigit, digit];
        NSLog(@"%@", errorMessage);
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorMessage};
        *error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:102 userInfo:userInfo];
    }
}

- (NSString*) correctNumberString: (NSString*) str {
    NSString* result = [str stringByReplacingOccurrencesOfString:@"[sS]" withString:@"5"];
    result = [result stringByReplacingOccurrencesOfString:@"[zZ]" withString:@"2"];
    result = [result stringByReplacingOccurrencesOfString:@"[[oODd]" withString:@"0"];
    result = [result stringByReplacingOccurrencesOfString:@"[LlIi|]" withString:@"1"];
    result = [result stringByReplacingOccurrencesOfString:@"[B]" withString:@"8"];
    return result;
}

- (int) computeCheckDigit:(NSString*) str {
    int result = 0;
    NSError* error = nil;
    int charValue;
    int currentMRZWeight;
    for (int i = 0; i < [str length]; i++) {
        charValue = [self getCharacterValue:[str characterAtIndex:i] error:error];
        if (error == nil) {
            currentMRZWeight = [(NSNumber *)[MRZ_WEIGHTS objectAtIndex:(i % [MRZ_WEIGHTS count])] intValue];
            charValue = charValue * currentMRZWeight;
            result += charValue;
        }else{
            result = 0;
            return result;
        }
    }
    return result % 10;
}

- (int) getCharacterValue:(char) c error:(NSError*) error {
    if (c == '<') {
        return 0;
    }
    if (c >= '0' && c <= '9') {
        return c - '0';
    }
    if (c >= 'A' && c <= 'Z') {
        return c - 'A' + 10;
    }
    
    NSString* errorMessage = [NSString stringWithFormat:@"Invalid character in MRZ record %c", c];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorMessage};
    error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:101 userInfo:userInfo];
    return 0;
}

@end