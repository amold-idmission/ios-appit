//
//  main.cpp
//  TextExtractor
//
//  Created by Goran Rauker on 3/4/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include "Document.h"
#include "DocumentMatcher.h"
#include "fileutil.h"
#include <iostream>
#include <opencv2/opencv.hpp>
#include "TextComponent.h"
#include "TextExtractor.h"
#include <tesseract/baseapi.h>

std::string ocr_extracted_text(tesseract::TessBaseAPI &ocr, const cv::Mat &im) {
    
    if (im.empty())
        return "";
    
    ocr.SetImage(im.data, im.cols, im.rows, im.channels(), (int)im.step1());
    ocr.Recognize(0);
    std::string text(ocr.GetUTF8Text());
    return text;
}

int main(int argc, const char * argv[]) {

    auto u_ptr = Document::load("/Users/goranrauker/Development/idmission appit-ios/appit-ios/Resources/templates/xml/colorado_id_front.xml");
    std::shared_ptr<Document> doc( std::shared_ptr<Document>(std::move(u_ptr)) );
    
    tesseract::TessBaseAPI ocr;
    ocr.Init("/Users/goranrauker/Development/idmission appit-ios/appit-ios/Resources/", "eng");
    
    // insert code here...
    cv::Mat im = cv::imread("/Users/goranrauker/Downloads/IMG_1202.JPG");
    
    cv::Mat template_image(doc->template_image());

    DocumentMatcher matcher;
    
    double up_sf(2.0), down_sf(2.5f);
    if ( matcher.match(template_image, up_sf, im, down_sf) == false )
        return 0;

    cv::imshow("warped",matcher.warped);
    cv::waitKey();
    
    TextExtractor extractor;

    for (auto c : doc->text_fields) {
        TextComponent scaled(c->name(), c->roi(up_sf).toRect(), LetterSize(c->letterWidth().min*up_sf,c->letterWidth().max*up_sf), LetterSize(c->letterHeight().min*up_sf,c->letterHeight().max*up_sf), c->text_lines() );
        
        cv::Mat tmp, colorSnippet( matcher.warped, scaled.roi().toRect());
        cv::GaussianBlur(colorSnippet, tmp, cv::Size(25, 25), 9);
        cv::addWeighted(colorSnippet, 1.5, tmp, -0.5, 0, colorSnippet);
        
        auto clips = extractor.extract_text(colorSnippet,scaled);
        auto snippets = extractor.extract_text(colorSnippet, scaled);

        for (auto snip : snippets) {
            
            cv::imwrite("/Users/goranrauker/Desktop/" + c->name() + ".png", snip.first);

            std::cout << ocr_extracted_text(ocr, snip.first) << std::endl;
            std::cout << ocr_extracted_text(ocr, snip.second) << std::endl;

            cv::imshow("reconstructed", snip.first);
            cv::imshow("cropped", snip.second);
        }
    }
    for (auto c: doc->text_fields)
        cv::rectangle(matcher.warped, c->roi(up_sf).toRect(), cv::Scalar(0,255,0));

    cv::imshow("matcher", matcher.warped);
    cv::waitKey(0);

    return 0;
}
