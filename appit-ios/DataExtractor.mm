//
//  DataExtractor.cpp
//  appit-ios
//
//  Created by Goran Rauker on 3/6/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include "DataExtractor.h"
#include "fileutil.h"
#include <regex>
#include "stringutil.h"
#include "zxingwrapper.h"
#include <sys/stat.h>
//#include <GoogleMobileVision/GoogleMobileVision.h>
#include "ImageUtils.h"
#include "NSStringUtils.h"

DataExtractor::DataExtractor(const Document &doc,
                             tesseract::TessBaseAPI &tesseract,
                             const std::string &face_detector_classifier_path,
                             std::atomic<size_t> &processed_counter,
                             const std::string &tess_data_path,
                             const std::size_t image_to_consume) :
document(doc),
document_matcher(),
ocr(tesseract),
face_detector(),
text_extractor(),
security_check(),
num_images_processed(processed_counter),
datapath(tess_data_path),
images_to_consume(image_to_consume)
{
    // randomize the order of text extraction so that the threads can work on different sections of the docuemnt
    std::random_shuffle(document.text_fields.begin(), document.text_fields.end());
    
    face_detector.init(face_detector_classifier_path);
}

bool DataExtractor::is_complete() {
    bool complete(true);
    
    for (auto c : document.bar_code_fields) {
        if (c->text().empty()) {
            c->found = false;
        }
        complete &= c->found;
//        std::cout << "barcode : " << c->found << std::endl;
//        std::cout << "barcode text : " << c->text() << std::endl;
    }
    for (auto c : document.text_fields) {
        complete &= c->hasTextConfidence();
       // std::cout << "text : " << c->hasTextConfidence() << std::endl;
    }
    for (auto c : document.security_check_fields) {
        complete &= c->found_security_check;
//        std::cout << "security feature : " << c->found_security_check << std::endl;
    }
    for (auto c : document.face_fields) {
        complete &= c->found_face;
//        std::cout << "face : " << c->found_face << std::endl;
    }
    for (auto c : document.mrz_fields) {
        complete &= c->hasTextConfidence();
        //std::cout << "mrz : " << c->hasTextConfidence() << std::endl;
    }
    return complete;
}

void DataExtractor::extract(cv::Mat &image, const cv::Rect &roi) {
    
    if (is_complete())
        return;
    std::cout << "Processing....."  << std::endl;
    double up_sf(1.0);
    bool template_not_matched = false;
    //MA cv::Mat warped;
    if (document.requires_accurate_matching) {
        //MA up_sf = 2.0;
        if (!document_matcher.match(document.template_image(), up_sf, image, 2.5) ) {
            std::cout << "Template not matched"  << std::endl;
            template_not_matched = true;
            warped = cv::Mat(image,roi);
            //If template not found then crop roi from image and only process face detection
//            return;
        } else {
            template_not_matched = false;
            warped = document_matcher.warped;
        }
    } else {
        // just clip the roi from the provided frame
        warped = cv::Mat(image,roi);
    }
    
    //If template not found but "requires_accurate_matching" is true then only process face detection and skip other processes.
    bool process_face_only = false;
    if(template_not_matched && document.requires_accurate_matching){
        cv::resize(warped, warped, document.template_size(), 0, 0,cv::INTER_CUBIC);
        process_face_only = true;
    }else{
        process_face_only = false;
    }
    image = cv::Mat();
    
    if(!process_face_only){
        if (!document.bar_code_fields.empty()) {
            std::cout << "processing barcodes" << std::endl;
            process_bar_code_tasks(warped.clone(), up_sf);
            if (is_complete()) return;
        }
        
        if (!document.text_fields.empty()) {
            std::cout << "processing text tasks" << std::endl;
            process_text_tasks(warped.clone(), up_sf);
            if (is_complete()) return;
        }
        
        if (!document.security_check_fields.empty()) {
            std::cout << "processing security tasks" << std::endl;
            process_security_check_tasks(warped.clone(), up_sf);
            if (is_complete()) return;
        }
    }
    
    if (!document.face_fields.empty()) {
        std::cout << "processing face detect tasks" << std::endl;
        process_face_detect_tasks(warped.clone(), up_sf);
        if (is_complete()) return;
    }
    
    if(!process_face_only){
    
        if (!document.mrz_fields.empty()) {
            std::cout << "processing mrz tasks" << std::endl;
            
            if(croppedMrz){
                //Resizing warped image, according to template size so that we can send cropped mrz image to MRZDetector.detect and process_cropped_mrz function.
                cv::resize(warped, warped, document.template_size(), 0, 0,cv::INTER_CUBIC);
                cv::Mat resizeWarped = warped.clone();
                process_mrz_tasks(warped, up_sf, resizeWarped);
            }else{
                //Resizing warped image, according to template size so that we can send cropped mrz image to "process_cropped_mrz" function.
                cv::Mat resizeWarped;
                cv::resize(warped, resizeWarped, document.template_size(), 0, 0,cv::INTER_CUBIC);
                process_mrz_tasks(warped, up_sf, resizeWarped);
            }
            
            /*
             Adding fallback to get mrz result.
             If all the images are processed but mrz is not detected then get mrz data from cropped mrz image and set its result.
             Note : Data from cropped mrz image is already taken while executing "process_mrz_tasks".
             we just need to set it if we didn't get result while mrz detection.
             */
            if((num_images_processed+1 > images_to_consume )){
                
                for (auto c : document.mrz_fields) {
                    //                if (c->hasTextConfidence())
                    //                    continue;
                    
                    std::string mrzResult = c->get_cropped_mrz_data();
                    
                    std::string text = c->text();
                    mrzResult = trim(mrzResult);
                    
                    if((trim(text).length() == 0)){
                        
                        //MRZ not detected, using fallback method
                        c->set_mrz_detected("D");
                        
                        if((mrzResult.length()>0)){
                            c->putText(mrzResult);
                            std::string text =  c->text();
                            
                            std::string originalMRZText = "";
                            //convert mrz to xml
                            bool found = read_mrzdata(text, originalMRZText);
                            if (found) {
                                c->setProcessedMRZText(text);
                                c->setOriginalMRZText(originalMRZText);
                            }
                        }
                    }
                }
            }
        }
    }
    
    num_images_processed++;
}

std::string DataExtractor::ocr_extracted_text(const cv::Mat &im) {

    if (im.empty())
        return "";
    
    ocr.SetImage(im.data, im.cols, im.rows, im.channels(), (int)im.step1());
    ocr.Recognize(0);
    std::string text(ocr.GetUTF8Text());
    std::cout << "OCR Extracted Text : " << text << std::endl;
    return trim(text);
}

std::string DataExtractor::summary(bool br_instead_of_new_line) {

    std::string s;
    std::string ending = br_instead_of_new_line ? "<br/>" : "\n";
    for (auto c : document.bar_code_fields) {
        s += "[" + c->name() + "] " + c->text() + ending;
    }
    
    for (auto c : document.text_fields) {
        s += "[" + c->name() + "] " + c->text() + ending;
    }
    
    for (auto c : document.security_check_fields) {
        s += "[" + c->name() + "] " + (c->found_security_check ? "found" : "not found") + ending;
    }
    
    for (auto c : document.face_fields) {
        s += "[" + c->name() + "] " + (c->found_face ? "found" : "not found") + ending;
    }
    for (auto c : document.mrz_fields) {
        s += "[" + c->name() + "] " + c->text() + ending;
    }
    
    return s;
}

void DataExtractor::process_bar_code_tasks(const cv::Mat &warped, double up_sf) {
    
    // resize the image into the size expected by the template
    
    cv::Size sz(document.template_size());
    double sfx = 1.0 * warped.cols / sz.width;
    double sfy = 1.0 * warped.rows / sz.height;
    
    for (auto c : document.bar_code_fields) {
        //std::cout << "barcode found : " << c->found << "text : " << c->text() << std::endl;
        if (c->found) {
            continue;
        }
        //std::cout << "loading barcode " << std::endl;
        cv::Mat region( warped, c->roi(sfx,sfy).toRect() );
        std::string text;
        std::string xsl = c->base64xsl();
        //std::cout << "reading barcode " << std::endl;
        bool found = read_barcode(region,text,xsl);
         c->setBarcodeImage(region);
        if (found) {
            c->found = true;
            c->setText(text);
           
            //std::cout << "found : " << found << "text : " << text << std::endl;
        }
        else{
            std::cout << "reading barcode first attempt failed " << region.type() << std::endl;
            cv::Mat regionDoubled(region.rows*3, region.cols*3, region.type());
            cv::resize(region, regionDoubled, regionDoubled.size(),0,0,cv::INTER_CUBIC);
             c->setBarcodeImage(regionDoubled);
            found = read_barcode(regionDoubled,text,xsl);
            if (found) {
                c->found = true;
                c->setText(text);
                
                //std::cout << "second attempt : found : " << found << "text : " << text << std::endl;
            }else {
                std::cout << "reading barcode second attempt failed " << regionDoubled.type() << std::endl;
            }
        }
    }
}

//void DataExtractor::process_text_tasks1(const cv::Mat &warped, double up_sf) {
//
//    for (auto c : document.text_fields) {
//
//        if (c->hasTextConfidence()) {
//            continue;
//        }
//
//        std::string fontcode = c->font_code();
//        std::string whiteListChars = c->white_List_Config_Chars();
//
//        if(isFontFileExist(fontcode)){
//            ocr.Init(datapath.c_str(), fontcode.c_str());
//        }else{
//            ocr.Init(datapath.c_str(), "eng");
//        }
//
//        ocr.SetPageSegMode(tesseract::PageSegMode::PSM_SINGLE_LINE);
//        ocr.SetVariable("load_system_dawg", "0");
//        ocr.SetVariable("load_freq_dawg", "0");
//
//        if(!whiteListChars.empty()){
//            ocr.SetVariable("tessedit_char_whitelist", whiteListChars.c_str());
//        }else{
//            ocr.SetVariable("tessedit_char_whitelist", "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-");
//        }
//
//
//        TextComponent scaled(c->name(), c->roi(up_sf).toRect(), LetterSize(c->letterWidth().min*up_sf,c->letterWidth().max*up_sf), LetterSize(c->letterHeight().min*up_sf,c->letterHeight().max*up_sf), c->text_lines(), c->font_code(), c->white_List_Config_Chars(), c->white_List_Config_Code(), c->preserve_Space(), c->format(), c->date_Format(), c->regulare_Expression_Map(), c->type() );
//
//        // deblur the image snippet
//        cv::Mat tmp, colorSnippet( warped, scaled.roi().toRect());
//        cv::GaussianBlur(colorSnippet, tmp, cv::Size(25, 25), 9);
//        cv::addWeighted(colorSnippet, 1.5, tmp, -0.5, 0, colorSnippet);
//
//        auto clips = text_extractor.extract_text(colorSnippet,scaled);
//
//        for (auto clip : clips ) {
//
//            // try to decode the reconstructed version of the data
//            std::string txt(ocr_extracted_text(clip.first));
//            c->putText(txt);
//
//            // try to decode the cropped version of the data
//            txt = ocr_extracted_text(clip.second);
//            c->putText(txt);
//
//            if (c->hasTextConfidence()) {
//                break;
//            }
//
//        }
//
//        /******************************************************************
//         Re-arrange/Correct extracted text according to given configuration
//         ******************************************************************/
//        std::string extractedText = c->text();
//        if(!extractedText.empty()){
//            std::cout << "process_text_tasks Extracted Text :  " << extractedText << std::endl;
//
//            std::map<std::string, std::string>  regulareExpressionMap = c->regulare_Expression_Map();
//            if(!regulareExpressionMap.empty()){
//
//                std::map<std::string, std::string>::iterator it;
//
//                for ( it = regulareExpressionMap.begin(); it != regulareExpressionMap.end(); it++ )
//                {
//                    //fisrt param is "ReplaceRegex" and second is "ReplaceWith"
//                    if(!it->first.empty()){
//                        extractedText = replaceAll(extractedText, it->first, it->second);
//                    }
//                }
//            }
//
//            if(!c->preserve_Space().empty() && c->preserve_Space()=="N"){
//                extractedText = removeAllWhiteSpace(extractedText);
//            }
//
//            if(!c->format().empty()){
//                extractedText = correctOCRReading(extractedText, c->format());
//            }
//
//            if(!c->preserve_Space().empty() && c->preserve_Space()=="N" && !c->format().empty()){
//                extractedText = removeAllWhiteSpace(extractedText);
//            }
//
//            if(!c->type().empty() && c->type()=="String"){
//                std::transform(extractedText.begin(), extractedText.end(), extractedText.begin(), ::toupper);
//            }
//
//            //Parsing extracted date according to given format in template and returning it in "dd/mm/yyyy" format.
//            if(!c->type().empty() && c->type()=="Date"){
//
//                std::string format = c->date_Format();
//
//                if(!format.empty()){
//
//                    std::string formater;
//                    bool dateFound=false, monthFound=false, yearFound=false;
//
//                    //We need to create formater pattern for parsing extracted date
//                    //e.g if temlate says date is in dd/mm/yyyy then formater will be %d/%m/%y
//                    for (int i=0; i<format.size() ; i++) {
//                        if((format[i] == 'd'|| format[i] == 'D')){
//                            if(!dateFound){
//                                dateFound = true;
//                                formater += "%d";
//                            }
//                        }else if((format[i] == 'm' || format[i] == 'M')){
//                            if(!monthFound){
//                                monthFound = true;
//                                if( (format.find("mmm") != std::string::npos) || (format.find("MMM") != std::string::npos) ){
//                                    formater += "%b"; //For parsing month name
//                                }else{
//                                    formater += "%m";
//                                }
//                            }
//                        }else if((format[i] == 'y' || format[i] == 'Y')){
//                            if(!yearFound){
//                                yearFound = true;
//                                formater += "%Y";
//                            }
//                        }else{
//                            formater += format[i];
//                        }
//                    }
//
//                    std::cout << "Date formater according to cpp: " << formater << std::endl;
//
//                    if(!formater.empty()){
//                        struct tm tm;
//                        if(strptime(extractedText.c_str(), formater.c_str(), &tm)){
//
//                            char dateBuffer [20];
//                            strftime(dateBuffer, 20, "%d/%m/%Y", &tm);
//                            extractedText = dateBuffer;
//
//                            std::cout << "Date formated in dd/mm/yyyy format: " << extractedText << std::endl;
//                        }else{
//                            std::cout << "Invalid Date " << std::endl;
//                        }
//                    }
//                }
//            }
//
//            //Adding back corrected text
//            c->putText(extractedText, 0, true);
//            std::cout << "process_text_tasks Corrected Text :  " << c->text() << std::endl;
//        }
//    }
//}

void DataExtractor::process_text_tasks(const cv::Mat &warped, double up_sf) {
    
//    UIImage *capturedImage = [ImageUtils UIImageFromCVMat:warped convert_color:true];
//
//    GMVDetector *textDetector = [GMVDetector detectorOfType:GMVDetectorTypeText options:nil];
//
//    cv::Size templatesize = document._template_size;
//
//    CGSize templateCGSize = CGSizeMake(templatesize.width, templatesize.height);
//
//    UIGraphicsBeginImageContext(templateCGSize);
//    [capturedImage drawInRect:CGRectMake(0, 0, templateCGSize.width, templateCGSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    NSArray<GMVTextBlockFeature *> *features = [textDetector featuresInImage:newImage options:nil];
//
//
//    for (auto c : document.text_fields) {
//
//        if (c->hasTextConfidence()) {
//            continue;
//        }
//
//        NSMutableString *componentString = [NSMutableString new];
//
//        cv::Rect templateRect = c->roi().toRect();
//
//        CGRect templateNewRect = CGRectMake(templateRect.x - 15, templateRect.y - 15, templateRect.width + 15, templateRect.height + 15);
//
//        for (GMVTextBlockFeature *textBlock in features) {
//            //        NSLog(@"Text Block: %@", NSStringFromRect(textBlock.bounds));
//            //        NSLog(@"lang: %@ value: %@", textBlock.language, textBlock.value);
//
//            for (GMVTextLineFeature *textLine in textBlock.lines) {
//                //            NSLog(@"Text Line: %@", NSStringFromRect(textLine.bounds));
//                //            NSLog(@"lang: %@ value: %@", textLine.language, textLine.value);
//
//                for (GMVTextElementFeature *textElement in textLine.elements) {
//
//                    NSArray<NSValue *> *coordinates =textElement.cornerPoints;
//
//                    CGPoint firstPt = [[coordinates objectAtIndex:0] CGPointValue];
//
//                    CGFloat widthFloat = [[coordinates objectAtIndex:2] CGPointValue].x - firstPt.x;
//
//                    CGFloat heightFloat = [[coordinates objectAtIndex:2] CGPointValue].y - firstPt.y;
//
//                    CGRect visionRect = CGRectMake(firstPt.x, firstPt.y, widthFloat, heightFloat);
////                    NSLog(@"All Text = %@",textElement.value);
//
//                   if(CGRectContainsRect(templateNewRect, visionRect) || CGRectEqualToRect(templateNewRect, visionRect)) {
//                           NSString *chkString = textElement.value;
////                           NSLog(@"Matched Text = %@",chkString);
//                           [componentString appendString:textElement.value];
//                           [componentString appendString:@" "];
//                   }
//
//                }
//            }
//        }
//
//        /******************************************************************
//         Re-arrange/Correct extracted text according to given configuration
//         ******************************************************************/
//        std::string extractedText = std::string([componentString UTF8String]);
//        if(!extractedText.empty()){
//            std::cout << "process_text_tasks Extracted Text :  " << extractedText << std::endl;
//
//            std::map<std::string, std::string>  regulareExpressionMap = c->regulare_Expression_Map();
//            if(!regulareExpressionMap.empty()){
//
//                std::map<std::string, std::string>::iterator it;
//
//                for ( it = regulareExpressionMap.begin(); it != regulareExpressionMap.end(); it++ )
//                {
//                    //fisrt param is "ReplaceRegex" and second is "ReplaceWith"
//                    if(!it->first.empty()){
//                        extractedText = replaceAll(extractedText, it->first, it->second);
//                    }
//                }
//            }
//
//            if(!c->preserve_Space().empty() && c->preserve_Space()=="N"){
//                extractedText = removeAllWhiteSpace(extractedText);
//            }
//
//            if(!c->format().empty()){
//                extractedText = correctOCRReading(extractedText, c->format());
//            }
//
//            if(!c->preserve_Space().empty() && c->preserve_Space()=="N" && !c->format().empty()){
//                extractedText = removeAllWhiteSpace(extractedText);
//            }
//
//            if(!c->type().empty() && c->type()=="String"){
//                std::transform(extractedText.begin(), extractedText.end(), extractedText.begin(), ::toupper);
//            }
//
//            //Parsing extracted date according to given format in template and returning it in "dd/mm/yyyy" format.
//            if(!c->type().empty() && c->type()=="Date"){
//
//                std::string format = c->date_Format();
//
//                if(!format.empty()){
//
//                    std::string formater;
//                    bool dateFound=false, monthFound=false, yearFound=false;
//
//                    //We need to create formater pattern for parsing extracted date
//                    //e.g if temlate says date is in dd/mm/yyyy then formater will be %d/%m/%y
//                    for (int i=0; i<format.size() ; i++) {
//                        if((format[i] == 'd'|| format[i] == 'D')){
//                            if(!dateFound){
//                                dateFound = true;
//                                formater += "%d";
//                            }
//                        }else if((format[i] == 'm' || format[i] == 'M')){
//                            if(!monthFound){
//                                monthFound = true;
//                                if( (format.find("mmm") != std::string::npos) || (format.find("MMM") != std::string::npos) ){
//                                    formater += "%b"; //For parsing month name
//                                }else{
//                                    formater += "%m";
//                                }
//                            }
//                        }else if((format[i] == 'y' || format[i] == 'Y')){
//                            if(!yearFound){
//                                yearFound = true;
//                                formater += "%Y";
//                            }
//                        }else{
//                            formater += format[i];
//                        }
//                    }
//
//                    std::cout << "Date formater according to cpp: " << formater << std::endl;
//
//                    if(!formater.empty()){
//                        struct tm tm;
//                        if(strptime(extractedText.c_str(), formater.c_str(), &tm)){
//
//                            char dateBuffer [20];
//                            strftime(dateBuffer, 20, "%d/%m/%Y", &tm);
//                            extractedText = dateBuffer;
//
//                            std::cout << "Date formated in dd/mm/yyyy format: " << extractedText << std::endl;
//                        }else{
//                            std::cout << "Invalid Date " << std::endl;
//                        }
//                    }
//                }
//            }
//        }
////        if(![NSStringUtils stringIsNilOrEmpty:componentString]) {
//        if(!extractedText.empty()) {
//            //std::string cppComponentString = std::string([componentString UTF8String]);
//            c->putText(extractedText, 0, true);
//            std::cout << "process_text_tasks Corrected Text :  " << c->text() << std::endl;
//        }
//    }
}

std::string DataExtractor::process_cropped_mrz(const cv::Mat &cropped_mrz, const std::shared_ptr<TextComponent> &text_component) {

    MRZDetector mrz_detector;
    
    ocr.Init(datapath.c_str(), "mrz");
    ocr.SetPageSegMode(tesseract::PageSegMode::PSM_SINGLE_BLOCK);
    ocr.SetVariable("load_system_dawg", "0");
    ocr.SetVariable("load_freq_dawg", "0");
    ocr.SetVariable("tessedit_char_whitelist", "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ<");
    
    cv::Mat cropped_mrz_gray;
    cv::cvtColor(cropped_mrz, cropped_mrz_gray, cv::COLOR_RGBA2GRAY);
    
    cv::Mat mrz = mrz_detector.cleanupBackground(cropped_mrz_gray, cv::THRESH_BINARY);

    //Setting mrz image, which is used to grab mrz data
    text_component->set_mrz_image(mrz);
    
    std::string mrzResult = ocr_extracted_text(mrz);
    std::cout << "process_cropped_mrz RESULT 1 : "<<mrzResult << std::endl;
    
    mrzResult = process_mrz_string(mrzResult);
    std::cout << "process_cropped_mrz RESULT 2 : "<<mrzResult << std::endl;
    
    return mrzResult;
}

void DataExtractor::process_security_check_tasks(const cv::Mat &warped, double up_sf) {
    for (auto component : document.security_check_fields) {
        
        if (component->found_security_check)
            continue;
        
        component->found_security_check = security_check.match(component->template_image(), warped);
    }
}

void DataExtractor::process_face_detect_tasks(const cv::Mat &warped, double up_sf) {

    for (auto component : document.face_fields) {
        if (component->found_face)
            continue;

        bool found = face_detector.detect(warped);
        if ( found ) {
            component->found_face = true;
            //component->set_base64_encoded_face_image( FileUtil::base64_encode_image(cv::Mat(warped, face_detector.mFaces[0])) );
            //component->set_face_image(cv::Mat(warped, face_detector.mFaces[0]));
            cv::Mat face_image_from_ocr(warped, face_detector.mFaces[0]);
            cv::Mat face_image( warped, component->roi().toRect() );
            bool faceFoundInCroppedImage = face_detector.detect(face_image);
            if ( faceFoundInCroppedImage ) {
                component->set_face_image(face_image);
            }else{
                component->set_face_image(face_image_from_ocr);
            }
        }else{
            cv::Mat face_image( warped, component->roi().toRect() );
            component->set_face_image(face_image);
        }
    }
}

//void DataExtractor::process_mrz_tasks(const cv::Mat &incoming, double up_sf, const cv::Mat &resizeWarped) {
//
//    for (auto c : document.mrz_fields) {
//        if (c->hasTextConfidence())
//            continue;
//
//        MRZDetector mrz_detector;
//        mrz_detector.setNumMrzLines(c->text_lines());
//
//        std::string fontcode = c->font_code();
//        std::string whiteListChars = c->white_List_Config_Chars();
//
//        if(isFontFileExist(fontcode)){
//            ocr.Init(datapath.c_str(), fontcode.c_str());
//        }else{
//            //Re-Initializing tesseract for using mrz.traineddata
//            ocr.Init(datapath.c_str(), "mrz");
//        }
//
//        ocr.SetPageSegMode(tesseract::PageSegMode::PSM_SINGLE_LINE);
//
//        if(!whiteListChars.empty()){
//            ocr.SetVariable("tessedit_char_whitelist", whiteListChars.c_str());
//        }else{
//            ocr.SetVariable("tessedit_char_whitelist", "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ<");
//        }
//
//        //        cv::Mat roi = cv::Mat(warped, c->roi().toRect());
//        //        cv::cvtColor(roi, roi, cv::COLOR_RGBA2GRAY);
//        //        mrz_detector.detect(roi, 0);
//        //        auto snippets = mrz_detector.extractMrzRegions(cv::Mat(warped, c->roi().toRect()), true);
//
//        cv::Mat warped(incoming), gray;
//        //        cv::resize(incoming,warped,cv::Size(),0.5,0.5);
//        cv::cvtColor(warped, gray, cv::COLOR_RGBA2GRAY);
//        //c->set_mrz_image(gray);
//        double sfx = 1.0* warped.cols / document.template_size().width;
//        double sfy = 1.0* warped.rows / document.template_size().height;
//
//        TextComponent scaled("",c->roi(up_sf).toRect(), LetterSize(c->letterWidth().min*sfx,c->letterWidth().max*sfx), LetterSize(c->letterHeight().min*sfy,c->letterHeight().max*sfy), c->text_lines(), c->font_code(), c->white_List_Config_Chars(), c->white_List_Config_Code(), c->preserve_Space(), c->format(), c->date_Format(), c->regulare_Expression_Map(), c->type());
//        //cv::imshow("gray   : ", gray  );
//        cv::Mat detected;
//        if(croppedMrz){
//            //Send cropped mrz image to detecter
//            //Reduce offset value as mat image is already cropped now
//            gray = cv::Mat(gray, c->roi().toRect());
//            detected = mrz_detector.detect(gray, scaled.letterWidth(), scaled.letterHeight(), 0.0);
//        }else{
//            detected = mrz_detector.detect(gray, scaled.letterWidth(), scaled.letterHeight(), 0.5);
//        }
//        //cv::imshow("detected   : ", detected  );
//        if ( !detected.empty()) {
//            c->set_mrz_image(detected);
//            cv::cvtColor(detected,detected,cv::COLOR_GRAY2BGR);
//
//            int line_number = 0;
//            for (auto snippet : mrz_detector.extractMrzRegions(detected,true) ) {
//                std::cout << " line number :  " << line_number << std::endl;
//                if (c->hasTextConfidence(line_number)) {
//                    line_number++;
//                    continue;
//                }
//
//                auto clips = text_extractor.extract_text(snippet, scaled);
//                for (auto clip : clips) {
//
//                    std::cout << clean_mrz(ocr_extracted_text(clip.first) ) << std::endl;
//                    std::string try1 = clean_mrz(ocr_extracted_text(clip.first));
//                    std::string try2 = clean_mrz(ocr_extracted_text(clip.second));
//
//                    c->putText(try1, line_number);
//                    std::cout << "[" << c->text_confidence(line_number) << "] " << try1 << std::endl;
//                    c->putText(try2, line_number);
//                    std::cout << "[" << c->text_confidence(line_number) << "] " << try2 << std::endl;
//
//                    if (c->hasTextConfidence(line_number)) {
//                        std::cout << "breaking with confidenced for line " << line_number << std::endl;
//                        break;
//                    }
//                }
//                line_number++;
//            }
//
//            std::string text =  c->text();
//            std::string originalMRZText = "";
//            //convert mrz to xml
//            bool found = read_mrzdata(text, originalMRZText);
//            if (found) {
//                c->setProcessedMRZText(text);
//                c->setOriginalMRZText(originalMRZText);
//                c->set_mrz_detected("Y");
//            }
//        }else{
//            //Cropped mrz region from actual image.
//            cv::Mat cropped_mrz = cv::Mat(resizeWarped, c->roi().toRect());
//
//            //Processing this cropped_mrz image to get text from this image.
//            std::string mrzResult = process_cropped_mrz(cropped_mrz, c);
//
//            //Maintaining this result to send it in response if we didn't get mrz result from MRZDetector.detect after processing every images.
//            c->set_cropped_mrz_data(mrzResult);
//        }
//    }
//    //Reverting tesseract for using eng.traineddata
//    //    ocr.Init(datapath.c_str(), "eng");
//}

void DataExtractor::process_mrz_tasks(const cv::Mat &incoming, double up_sf, const cv::Mat &resizeWarped) {
    
//    for (auto c : document.mrz_fields) {
//        if (c->hasTextConfidence())
//            continue;
//        
//        MRZDetector mrz_detector;
//        mrz_detector.setNumMrzLines(c->text_lines());
//        
//        std::string fontcode = c->font_code();
//        std::string whiteListChars = c->white_List_Config_Chars();
//        
//        if(isFontFileExist(fontcode)){
//            ocr.Init(datapath.c_str(), fontcode.c_str());
//        }else{
//            //Re-Initializing tesseract for using mrz.traineddata
//            ocr.Init(datapath.c_str(), "mrz");
//        }
//        
//        ocr.SetPageSegMode(tesseract::PageSegMode::PSM_SINGLE_LINE);
//        
//        if(!whiteListChars.empty()){
//            ocr.SetVariable("tessedit_char_whitelist", whiteListChars.c_str());
//        }else{
//            ocr.SetVariable("tessedit_char_whitelist", "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ<");
//        }
//
//        cv::Mat warped(incoming), gray;
////        cv::resize(incoming,warped,cv::Size(),0.5,0.5);
//        cv::cvtColor(warped, gray, cv::COLOR_RGBA2GRAY);
//        //c->set_mrz_image(gray);
//        double sfx = 1.0* warped.cols / document.template_size().width;
//        double sfy = 1.0* warped.rows / document.template_size().height;
//        
//        //Google Vision Start
//        UIImage *capturedMRZImage = [ImageUtils UIImageFromCVMat:warped convert_color:true];
//        
//        GMVDetector *textDetector = [GMVDetector detectorOfType:GMVDetectorTypeText options:nil];
//        
//        NSArray<GMVTextBlockFeature *> *features = [textDetector featuresInImage:capturedMRZImage options:nil];
//        
//        cv::Rect templateRect = c->roi().toRect();
//        
//        CGRect templateNewRect = CGRectMake(templateRect.x - 20, templateRect.y - 20, templateRect.width + 20, templateRect.height + 20);
//        
//         NSMutableString *componentString = [NSMutableString new];
//        
//        for (GMVTextBlockFeature *textBlock in features) {
//            //        NSLog(@"Text Block: %@", NSStringFromRect(textBlock.bounds));
//            //        NSLog(@"lang: %@ value: %@", textBlock.language, textBlock.value);
//            
//            for (GMVTextLineFeature *textLine in textBlock.lines) {
//                //            NSLog(@"Text Line: %@", NSStringFromRect(textLine.bounds));
//                //            NSLog(@"lang: %@ value: %@", textLine.language, textLine.value);
//                
//                NSArray<NSValue *> *coordinates =textLine.cornerPoints;
//                
//                CGPoint firstPt = [[coordinates objectAtIndex:0] CGPointValue];
//                
//                CGFloat widthFloat = [[coordinates objectAtIndex:2] CGPointValue].x - firstPt.x;
//                
//                CGFloat heightFloat = [[coordinates objectAtIndex:2] CGPointValue].y - firstPt.y;
//                
//                CGRect visionRect = CGRectMake(firstPt.x, firstPt.y, widthFloat, heightFloat);
//                
//                if(CGRectContainsRect(templateNewRect, visionRect)) {
//                    NSString *value = [NSString stringWithFormat:@"%@\n",textLine.value];
//                    [componentString appendString:value];
//                }
//            }
//        }
//        
//        std::string text =  std::string([componentString UTF8String]);
//        std::string originalMRZText = "";
//        //convert mrz to xml
//        bool found = read_mrzdata(text, originalMRZText);
//        if (found) {
//            c->setProcessedMRZText(text);
//            c->setOriginalMRZText(originalMRZText);
//            c->set_mrz_detected("Y");
//        }
//    }
}


bool DataExtractor::fileExists(const std::string& filename)
{
    struct stat buf;
    if (stat(filename.c_str(), &buf) != -1)
    {
        return true;
    }
    return false;
}

bool DataExtractor::isFontFileExist(const std::string &fontCode){
    
    bool isFontFileExist = false;
    
    if(!fontCode.empty() && !datapath.empty()){
        
        std::string filepath;
        if(datapath.find("/") != std::string::npos){
            filepath = datapath + "/" + fontCode + ".traineddata";
        }else{
            filepath = datapath + "\\" + fontCode + ".traineddata";
        }
        
        isFontFileExist = fileExists(filepath);
    }
    
    return isFontFileExist;
}
