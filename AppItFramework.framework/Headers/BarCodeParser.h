//
//  BarCodeParser.h
//  appit-ios
//
//  Created by idmission on 02/07/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

@interface BarCodeParser : NSObject

-(NSString* ) parse_text:(NSString*) text xsl:(NSString*) xslText;
-(NSString* ) convert_to_components:(NSString*) xml;
//-(NSString* ) parse_mrz_text:(NSString*) text;
- (NSMutableDictionary* ) parse_mrz_text:(NSString*) text;
-(NSString* ) esacpeXML:(NSString*) text;
-(NSMutableDictionary* ) parse_text_mutableDictionary:(NSString*) text xsl:(NSString *)xslText isUSA_DL_CO:(bool)isUSA_DL_CO;

@end


