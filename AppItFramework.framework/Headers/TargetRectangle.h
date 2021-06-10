//
//  TargetRectangle.h
//  appit-ios
//
//  Created by Goran Rauker on 2/5/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanningModeClass.h"

@interface TargetRectangle : UIView

@property (assign,readwrite) CGRect roi; // width/height
@property (readwrite) NSMutableArray* rects;
@property (readwrite) bool has_document;
@property (readwrite) bool draw_target_rectangle;
@property (readwrite) float line_width;
@property (readwrite) NSString *id_outline_color;
@property (readwrite) float id_outline_color_alpha;
@property (readwrite) NSString *detected_id_outline_color;
@property (readwrite) float detected_id_outline_color_alpha;
@property (readwrite) NSString *id_outline_outside_color;
@property (readwrite) float id_outline_outside_alpha;
@property (readwrite) NSString *detected_id_outline_outside_color;
@property (readwrite) float detected_id_outline_outside_alpha;
@property (readwrite) bool is_debuggable;
@property (readwrite) bool tl_error;
@property (readwrite) bool tr_error;
@property (readwrite) bool bl_error;
@property (readwrite) bool br_error;

@property (readwrite) int tl_focus;
@property (readwrite) int tr_focus;
@property (readwrite) int bl_focus;
@property (readwrite) int br_focus;

@property (readwrite) int tl_glare;
@property (readwrite) int tr_glare;
@property (readwrite) int bl_glare;
@property (readwrite) int br_glare;

//FastFillController changes
@property (readwrite) bool isTargetRectangleForFastFillController;

@property(nonatomic, assign) ScanningModeClass *currentModeForMRZandBarcode;

@property(nonatomic) BOOL capture_in_portrait_mode;

@property(nonatomic) NSString *imageFilterType;

@end
