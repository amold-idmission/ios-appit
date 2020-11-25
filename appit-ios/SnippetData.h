//
//  SnippetData.h
//  appit-ios
//
//  Created by  on 06/03/19.
//  Copyright © 2019 IDMission. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SnippetData : NSObject

-(NSString*)getSnippetName;
-(void)setSnippetName:(NSString *)snippetName;

-(NSString*)getResponseFormFieldKey;
-(void)setResponseFormFieldKey:(NSString *)responseFormFieldKey;

-(NSString*)getIsMandatory;
-(void)setIsMandatory:(NSString *)isMandatory;

-(id)initWithSnippet:(NSString *)snippetname
               responseformfieldkey:(NSString *)responseformfieldkey
                 ismandatory:(NSString*)ismandatory;

@end

NS_ASSUME_NONNULL_END
