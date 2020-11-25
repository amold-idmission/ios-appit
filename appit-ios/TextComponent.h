//
//  TextComponent.h
//  appit-ios
//
//  Created by Goran Rauker on 3/4/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__TextComponent__
#define __appit_ios__TextComponent__

#include "Component.h"
#include "LetterSize.h"
#include "fileutil.h"
#include <map>
#include <thread>

class TextComponent : public Component {
public:

    //	String corrected = et.text.replaceAll("[^a-zA-Z 0-9\\.\\,\\-]", "");
    TextComponent( const std::string & name, const cv::Rect &roi, const LetterSize &letterWidth, const LetterSize &letterHeight, int text_lines, const std::string & fontCode, const std::string & whiteListConfChars, const std::string & whiteListConfigCode, const std::string & preserveSpace, const std::string & format, const std::string & dateFormat, const std::map<std::string, std::string> regulareExpressionMap,const std::string & type, int confidence_level=2 ) : Component(name,roi), _letter_width(letterWidth), _letter_height(letterHeight), _text_lines(text_lines), _fontCode(fontCode), _whiteListConfigChars(whiteListConfChars), _whiteListConfigCode(whiteListConfigCode), _preserveSpace(preserveSpace), _format(format), _dateFormat(dateFormat), _regulareExpressionMap(regulareExpressionMap), _componentType(type), _confidence_level(confidence_level) {}
    TextComponent() : _text_lines(1), _confidence_level(2) {}
    
    // checks to see if the bounding rect of the contour is the right size to be a letter ...
    bool isBoundingRectCorrectSizeForLetter(const cv::Rect &br) {
        return isBoundingRectCorrectSizeForLetter(br,1.0);
    }

    bool isBoundingRectCorrectSizeForLetter(const cv::Rect &br, double sf) {
        
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        if (br.width < this->_letter_width.min*sf || br.width > this->_letter_width.max*sf || br.height < this->_letter_height.min*sf
            || br.height > this->_letter_height.max*sf)
            return false;
        return true;
    }
    
    bool isTextRegion() {
        
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        return _roi.isValid() && _letter_width.isValid() && _letter_height.isValid();
    }
    
    bool hasTextConfidence(int line_number) {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        return has_text_confidence(text_map_for(line_number));
    }
    
    bool hasTextConfidence() {
        
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        
        if (_text_lines == 1 ) {
            return has_text_confidence(_string_map_line1);
        }else if (_text_lines == 2 ) {
            return has_text_confidence(_string_map_line1) && has_text_confidence(_string_map_line2);
        }
        else {
            return has_text_confidence(_string_map_line1) && has_text_confidence(_string_map_line2) && has_text_confidence(_string_map_line3);
        }
    }
    
    LetterSize letterHeight() {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        return _letter_height;
    }
    
    LetterSize letterWidth() {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        return _letter_width;
    }
    
    void set_confidence_level(int level) {
        _confidence_level = level;
    }
    
    std::string text() {
        
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        if (_text_lines == 1 )
            return string_with_max_confidence(_string_map_line1);
        else if (_text_lines == 2 )
            return string_with_max_confidence(_string_map_line1) + "\n" + string_with_max_confidence(_string_map_line2);
        else
            return string_with_max_confidence(_string_map_line1) + "\n" + string_with_max_confidence(_string_map_line2)+ "\n" + string_with_max_confidence(_string_map_line3);
    }
    
    size_t text_confidence(int line_number) {
        size_t count = 0;
        auto map = text_map_for(line_number);
        for (auto entry : map ) {
            if (entry.second >= count) {
                count = entry.second;
            }
        }
        return count;
    }
    
    int text_lines() const {
        return _text_lines;
    }
    
    std::string font_code() {
        return _fontCode;
    }
    
    std::string white_List_Config_Chars() {
        return _whiteListConfigChars;
    }
    
    std::string white_List_Config_Code() {
        return _whiteListConfigCode;
    }
    
    std::string preserve_Space() {
        return _preserveSpace;
    }
    
    std::string format() {
        return _format;
    }
    
    std::string date_Format() {
        return _dateFormat;
    }
    
    std::string type() {
        return _componentType;
    }
    
    std::map<std::string, std::string> regulare_Expression_Map() {
        //fisrt param is "ReplaceRegex" and second is "ReplaceWith"
        return _regulareExpressionMap;
    }
    
    std::string toXml() {

        std::lock_guard<std::recursive_mutex> lock(_mutex);
        std::string xml = "";
        
        if(_name == "MRZData"){

//            xml += "<Component>\n";
//            xml += "<Name>MRZDetected</Name>\n";
//            if (_processed_mrz_text != "") {
//                xml += "<Value>true</Value>\n";
//            }else{
//              xml += "<Value>false</Value>\n";
//            }
//            xml += "</Component>\n";
            
            xml += "<Component>\n";
            xml += "<Name>" + _name + "</Name>\n";
            xml += "<Value>"+_original_mrz_text+"</Value>";
            xml += "</Component>\n";

            xml += "<Component>\n";
            xml += "<Name>MRZImage</Name>\n";
            xml += "<Value>"+get_mrz_image()+"</Value>";
            xml += "</Component>\n";

            xml += "<Component>\n";
            xml += "<Name>MRZDetected</Name>\n";
            xml += "<Value>"+get_mrz_detected()+"</Value>";
            xml += "</Component>\n";
            
            xml += _processed_mrz_text;
        }else {
            xml += "<Component>\n";
            xml += "<Name>" + _name + "</Name>\n";
            xml += "<Value>" + text() + "</Value>\n";
            xml += "</Component>\n";
        }
        return xml;
    }
    
    void putText(const std::string &text, int line_number=0, bool removeOldValues=false) {
        if(removeOldValues){
            std::lock_guard<std::recursive_mutex> lock(_mutex);
            std::map<std::string,int> &text_map = text_map_for(line_number);
            text_map.clear();
            putText(text, text_map);
        }else{
            std::lock_guard<std::recursive_mutex> lock(_mutex);
            putText(text, text_map_for(line_number));
        }
    }
    
    void setProcessedMRZText(const std::string &text) {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        _processed_mrz_text = text;
    }
    
    void setOriginalMRZText(const std::string &text) {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        _original_mrz_text = text;
    }
    
    std::string get_mrz_image() {
        if ( !_mrz_image.empty()) {
            return FileUtil::base64_encode_image(_mrz_image);
        }
        return "";
        //return _mrz_image;
    }
    
    void set_mrz_image(const cv::Mat im) {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        _mrz_image = im;
    }

    std::string get_cropped_mrz_data() {
        if(!_cropped_mrz_data.empty()){
            return _cropped_mrz_data;
        }
        return "";
    }
    
    void set_cropped_mrz_data(const std::string mrzdata) {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        _cropped_mrz_data = mrzdata;
    }

    std::string get_mrz_detected() {
        if(!_mrz_detected.empty()){
            return _mrz_detected;
        }
        return "NA";
    }
    
    void set_mrz_detected(const std::string mrz_detected) {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        _mrz_detected = mrz_detected;
    }
protected:
    
    std::map<std::string,int>& text_map_for(int line_number) {
        //return line_number == 0 ? _string_map_line1 : _string_map_line2;
        return line_number == 0 ? _string_map_line1 : (line_number == 1 ? _string_map_line2 : _string_map_line3);
    }
    
    void putText(const std::string &text, std::map<std::string,int> &map) {

        if (text.empty())
            return;
        
        auto it = map.find(text);
        
        if (it == map.end())
            map.insert( std::make_pair(text,1));
        else
            map[text] += 1;
    }
    
    bool has_text_confidence(const std::map<std::string,int> &map) {
        for (auto entry : map ) {
            if (entry.second >= _confidence_level) {
                return true;
            }
        }
        return false;
    }
    
    std::string string_with_max_confidence(const std::map<std::string,int> &map) {
        // find the entry with the most number of occurrences
        int max_count(-1);
        std::string max_value("");
        
        for ( auto entry : map) {
            if (entry.second > max_count) {
                max_count = entry.second;
                max_value  =entry.first;
            }
        }
        
        return max_value;
    }
    
    
    std::atomic<int> _text_lines;
    std::atomic<int> _confidence_level;
    LetterSize _letter_width;
    LetterSize _letter_height;
    std::string _fontCode = "";
    std::string _whiteListConfigChars = "";
    std::string _whiteListConfigCode = "";
    std::string _preserveSpace = "";
    std::string _format = "";
    std::string _dateFormat = "";
    std::map<std::string, std::string> _regulareExpressionMap; //fisrt param is "ReplaceRegex" and second is "ReplaceWith"
    std::string _componentType = "";
    
    std::map<std::string,int> _string_map_line1;
    std::map<std::string,int> _string_map_line2;
    std::map<std::string,int> _string_map_line3;
    std::string _processed_mrz_text = "";
    std::string _original_mrz_text = "";
    cv::Mat _mrz_image;
    
    std::string _cropped_mrz_data;
    std::string _mrz_detected;
};

#endif /* defined(__appit_ios__TextComponent__) */
