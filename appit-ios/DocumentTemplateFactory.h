//
//  DocumentTemplateFactory.h
//  appit-ios
//
//  Created by Goran Rauker on 3/20/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "Document.h"
#include <memory>

@interface DocumentTemplateFactory : NSObject 

+(std::shared_ptr<Document>)load_document_template:(NSString*)path;

+(std::shared_ptr<Document>)create_colorado_id;
+(std::shared_ptr<Document>)create_temp_passport;
+(std::shared_ptr<Document>)create_ozo;
+(std::shared_ptr<Document>)create_passport;

@end