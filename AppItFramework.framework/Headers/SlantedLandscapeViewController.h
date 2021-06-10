//
//  SlantedLandscapeViewController.h
//  AppItFramework
//
//  Created by Dipen Patel on 28/08/19.
//  Copyright © 2019 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCaptureFingerprintViewController.h"
#import "CommonImporter.h"


@interface SlantedLandscapeViewController : VideoCaptureFingerprintViewController{
    
}

@property(nonatomic) NSString *imageType;

//Property define for maintaining response data
@property(nonatomic, strong) NSString *responseStatus;
@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;

@property(nonatomic, assign) int enable_capture_button_time;
@property(nonatomic, assign) NSString *id_outline_color;
@property(nonatomic, assign) int id_outline_color_alpha;
@property(nonatomic, assign) NSString *id_outline_outside_color;
@property(nonatomic, assign) int id_outline_outside_color_alpha;
@property(nonatomic, assign) NSString *detected_id_outline_color;
@property(nonatomic, assign) int detected_id_outline_color_alpha;
@property(nonatomic, assign) NSString *title_message_style;
@property(nonatomic, assign) NSString *hint_message_style;
@property(nonatomic, assign) NSString *title_message_color;
@property(nonatomic, assign) NSString *hint_message_color;
@property(nonatomic, assign) int title_message_color_alpha;
@property(nonatomic, assign) int hint_message_color_alpha;
@property(nonatomic, assign) NSString *back_button_color;
@property(nonatomic, assign) int back_button_color_alpha;
@property(nonatomic, assign) NSString *text_font_size;
@property(nonatomic, assign) NSString *header_font_size;

@property(nonatomic) NSString *genericFieldName;
@property(nonatomic) BOOL capture_in_portrait_mode;

@end
