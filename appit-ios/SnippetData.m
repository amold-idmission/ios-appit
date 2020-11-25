//
//  SnippetData.m
//  appit-ios
//
//  Created by  on 06/03/19.
//  Copyright © 2019 IDMission. All rights reserved.
//

#import "SnippetData.h"


@implementation SnippetData {
    NSString* snippetName;
    NSString* responseFormFieldKey;
    NSString* isMandatory;
}


-(id)initWithSnippet:(NSString *)snippetname
responseformfieldkey:(NSString *)responseformfieldkey
         ismandatory:(NSString*)ismandatory {
    
    if( self = [super init] )
    {
        snippetName = snippetname;
        responseFormFieldKey = responseformfieldkey;
        isMandatory = ismandatory;
    }
    
    return self;
}

-(NSString*)getSnippetName {
    return snippetName;
}
-(void)setSnippetName:(NSString *)snippetname {
    snippetName = snippetname;
}

-(NSString*)getResponseFormFieldKey {
    return responseFormFieldKey;
}
-(void)setResponseFormFieldKey:(NSString *)responseformfieldkey {
    responseFormFieldKey = responseformfieldkey;
}

-(NSString*)getIsMandatory {
    return isMandatory;
}
-(void)setIsMandatory:(NSString *)ismandatory {
    isMandatory = ismandatory;
}

@end
