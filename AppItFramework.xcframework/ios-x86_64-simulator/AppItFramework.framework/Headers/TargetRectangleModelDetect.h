//
//  TargetRectangleModelDetect.h
//  AppItFramework
//
//  Created by Sanket Garde on 26/08/20.
//  Copyright © 2020 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanningModeClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface TargetRectangleModelDetect : UIView

@property (assign, readwrite) CGRect roi, redLineRoi, tensorFlowDetectedRect;
@property (readwrite) float line_width, red_line_width;
@property (readwrite) bool has_document, draw_target_rectangle, is_debuggable, isTargetRectangleForFastFillController;
@property (readwrite) NSMutableArray* rects;
@property (nonatomic) NSString *imageFilterType, *debugDataString;

@property (readwrite) NSString *id_outline_color, *detected_id_outline_color, *id_outline_outside_color, *detected_id_outline_outside_color;
@property (readwrite) float id_outline_color_alpha, detected_id_outline_color_alpha, id_outline_outside_alpha, detected_id_outline_outside_alpha;

//FastFillController changes
@property(nonatomic, assign) ScanningModeClass *currentModeForMRZandBarcode;
@property(nonatomic) BOOL capture_in_portrait_mode, isDisableDrawingRect;

@end

NS_ASSUME_NONNULL_END
