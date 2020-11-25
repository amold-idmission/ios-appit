//
//  DocumentTemplateFactory.cpp
//  appit-ios
//
//  Created by Goran Rauker on 3/20/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include "DocumentTemplateFactory.h"

@interface DocumentTemplateFactory ()
@end

@implementation DocumentTemplateFactory

+(std::shared_ptr<Document>)load_document_template:(NSString*)path {
    
    return std::shared_ptr<Document>( std::shared_ptr<Document>( std::move( Document::load([path UTF8String]) ) ) );
}

+(std::shared_ptr<Document>)create_colorado_id {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"colorado_id_front" ofType:@"xml" inDirectory:@"/templates/xml"];
    return [DocumentTemplateFactory load_document_template:path];
}

+(std::shared_ptr<Document>)create_temp_passport {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"passport" ofType:@"xml" inDirectory:@"/templates/xml"];
    return [DocumentTemplateFactory load_document_template:path];
}

+(std::shared_ptr<Document>)create_ozo {
    cv::Mat template_image = cv::imread([[[NSBundle mainBundle] pathForResource:@"ozo_template" ofType:@"jpg" inDirectory:@"/templates/template_images"] UTF8String]);
    
    return std::shared_ptr<Document>( new Document("OZO Coffee",
                                                   template_image,
                                                   {},
                                                   {},
                                                   {},
                                                   {},
                                                   {}
                                                   )
                                     );
}

+(std::shared_ptr<Document>)create_passport {
    const std::map<std::string, std::string> regulareExpressionMap;
    return std::shared_ptr<Document>(
                                     new Document("USA Passport",
                                                  cv::Size(800.0,545.0),
                                                  {},
                                                  {},
                                                  {},
                                                  { std::shared_ptr<FaceComponent>(new FaceComponent("Face", cv::Rect())) },
                                                  {std::shared_ptr<TextComponent>( new TextComponent("MRZ", cv::Rect(5,410,790,110), LetterSize(4,16), LetterSize(10,22), 2, "", "", "", "", "", "", regulareExpressionMap, "", 2) ) }
                                                  )
                                     );
    
}

@end
