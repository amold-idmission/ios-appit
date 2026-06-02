//
//  TemplateFieldValues.h
//  AppItFramework
//
//  Created by Sanket Garde on 23/09/19.
//  Copyright © 2019 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplateFieldValues : NSObject

@property(nonatomic, strong) NSString *code;
@property(nonatomic, strong) NSString *match_pattern;
@property(nonatomic, strong) NSString *xslt;
@property(nonatomic, strong) NSString *is_disabled;
@property(nonatomic, strong) NSString *document_type_id;
@property(nonatomic, strong) NSString *country_code;
@property(nonatomic, strong) NSString *state;
@property(nonatomic, strong) NSString *side;

-(id)initWithName:(NSString *)code
       match_pattern:(NSString *)match_pattern
       xslt:(NSString *)xslt
      is_disabled:(NSString *)is_disabled document_type_id:(NSString *)document_type_id country_code:(NSString *)country_code state:(NSString *)state side:(NSString *)side;

-(NSString *) getCode;

-(NSString *) getMatchPattern;

-(NSString *) getXslt;

-(NSString *) getIsDisabled;

-(NSString *) getDocumentTypeID;

-(NSString *) getCountryCode;

-(NSString *) getState;

-(NSString *) getSide;
@end
