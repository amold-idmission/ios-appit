//
//  stringutil.h
//  appit-ios
//
//  Created by Goran Rauker on 3/6/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef appit_ios_stringutil_h
#define appit_ios_stringutil_h

#include <algorithm>
#include <functional>
#include <cctype>
#include <locale>
#include <regex>

// trim from start
static inline std::string &ltrim(std::string &s) {
    s.erase(s.begin(), std::find_if(s.begin(), s.end(), std::not1(std::ptr_fun<int, int>(std::isspace))));
    return s;
}

// trim from end
static inline std::string &rtrim(std::string &s) {
    s.erase(std::find_if(s.rbegin(), s.rend(), std::not1(std::ptr_fun<int, int>(std::isspace))).base(), s.end());
    return s;
}

// trim from both ends
static inline std::string &trim(std::string &s) {
    return ltrim(rtrim(s));
}

static inline std::string& remove_spaces(std::string &input)
{
    input.erase(std::remove(input.begin(),input.end(),' '),input.end());
    return input;
}

static inline std::string clean_mrz(std::string input)
{
    trim(input);
    remove_spaces(input);
    
    // common OCR issues
    std::replace(input.begin(), input.end(),'(','<');
    std::replace(input.begin(), input.end(),'$','S');

    // remove invalid characters
    return std::regex_replace(input,std::regex("[^a-zA-Z0-9<]"), "");
}

static inline std::string replaceAll(std::string basestring, std::string replacestring, std::string replacewith){
    std::string resultstring = basestring;
    long charPosition = 0;
    while ((charPosition = resultstring.find(replacestring)) != -1){
        resultstring.replace(charPosition, replacestring.length(), replacewith);
    }
    return resultstring;
}

static inline std::string removeAllWhiteSpace(std::string string){
    std::string str = string;
    if(str.empty()){
        return str;
    }
    str.erase(remove_if(str.begin(), str.end(), isspace), str.end());
    return str;
}

static inline std::string correctOCRReading(std::string string, std::string format){
    std::string result = string;
    
    if(!result.empty()){
        result = trim(result);
    }else{
        return result;
    }
    
    if(!format.empty()){
        
        std::string componentdata = removeAllWhiteSpace(result);
        int length = componentdata.length();
        if(length == format.length()){
            
            result = std::string(length, 'X');
            
            for (int i=0; i<length; i++) {
                
                char componentChar = componentdata[i];
                char formatChar = format[i];
                
                if(formatChar == 'A'){
                    if(componentChar == '5'){
                        result[i] = 'S';
                    }else if (componentChar=='2'){
                        result[i] = 'Z';
                    }else if (componentChar=='0'){
                        result[i] = 'O';
                    }else if (componentChar=='1'){
                        result[i] = 'I';
                    }else if (componentChar=='8'){
                        result[i] = 'B';
                    }else if (componentChar=='|'){
                        result[i] = 'I';
                    }else{
                        result[i] = componentChar;
                    }
                }else if(formatChar == 'N'){
                    if(componentChar == 'S' || componentChar == 's'){
                        result[i] = '5';
                    }else if(componentChar == 'Z' || componentChar == 'z'){
                        result[i] = '2';
                    }else if(componentChar == 'Z' || componentChar == 'z'){
                        result[i] = '2';
                    }else if(componentChar == 'o' || componentChar == 'O' || componentChar == 'D' || componentChar == 'd'){
                        result[i] = '0';
                    }else if(componentChar == 'L' || componentChar == 'l' || componentChar == 'I' || componentChar == 'i'){
                        result[i] = '1';
                    }else if(componentChar == 'B'){
                        result[i] = '8';
                    }else{
                        result[i] = componentChar;
                    }
                }else{
                    result[i] = formatChar;
                }
            }
        }
    }
    
    return result;
}

std::string base64_encode(const std::string &string);

#endif
