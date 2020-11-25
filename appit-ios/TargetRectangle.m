//
//  TargetRectangle.m
//  appit-ios
//
//  Created by Goran Rauker on 2/5/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import "TargetRectangle.h"

@implementation TargetRectangle {
}

-(void)initializationCodeMethod {
    
    _roi = CGRectMake(0, 0, 0, 0);
    _rects = [[NSMutableArray alloc] init];
    _draw_target_rectangle = true;
//    _line_width = 10.0f;
}

-(id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])){
        [self initializationCodeMethod];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])){
        [self initializationCodeMethod];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    if (self.draw_target_rectangle == false)
        return;
    
    [self drawOutlineAreas:rect];
    [self drawTargetAreas:rect];
    
    CGFloat red[] = {1.0, 0.0, 0.0, 1.0};
    
    for (int i=0; i < [_rects count]; i++ ) {
        CGRect someRect = [[_rects objectAtIndex:i] CGRectValue];
        
        CGFloat green[] = {0.0, 1.0, 0.0, 1.0};
        CGFloat blue[] = {0.0, 0.0, 1.0, 1.0};
        //        CGFloat red[] = {1.0, 0.0, 0.0, 1.0};
        CGFloat yellow[] = {1.0, 1.0, 0.0, 1.0};
        
        if (i==0) [self drawTargetRectangle:someRect color_component:blue lineWidth:1.0f];
        else if (i==1) [self drawTargetRectangle:someRect color_component:green lineWidth:1.0f];
        else [self drawTargetRectangle:someRect color_component:yellow lineWidth:1.0f];
    }
    
    if(_tl_error){
        CGRect tlRect = CGRectMake(_roi.origin.x, _roi.origin.y, _roi.size.width/2, _roi.size.height/2);
        [self drawTargetRectangle:tlRect color_component:red lineWidth:_line_width/2.0];
        if(_is_debuggable){
        NSString *label = [NSString stringWithFormat:@"Focus %d Glare  %d", _tl_focus, _tl_glare];
        [self drawText:tlRect.origin.x yPosition:(tlRect.origin.y + tlRect.size.height/2) canvasWidth:tlRect.size.width canvasHeight:tlRect.size.height label:label];
        }
    }
    
    if(_tr_error){
        CGRect trRect = CGRectMake(_roi.origin.x + _roi.size.width/2, _roi.origin.y, _roi.size.width/2, _roi.size.height/2);
        [self drawTargetRectangle:trRect color_component:red lineWidth:_line_width/2.0];
        if(_is_debuggable){
        NSString *label = [NSString stringWithFormat:@"Focus %d Glare  %d", _tr_focus, _tr_glare];
        [self drawText:trRect.origin.x yPosition:(trRect.origin.y + trRect.size.height/2) canvasWidth:trRect.size.width canvasHeight:trRect.size.height label:label];
        }
    }
    
    if(_bl_error){
        CGRect blRect = CGRectMake(_roi.origin.x, _roi.origin.y + _roi.size.height/2, _roi.size.width/2, _roi.size.height/2);
        [self drawTargetRectangle:blRect color_component:red lineWidth:_line_width/2.0];
        if(_is_debuggable){
        NSString *label = [NSString stringWithFormat:@"Focus %d Glare  %d", _bl_focus, _bl_glare];
        [self drawText:blRect.origin.x yPosition:(blRect.origin.y + blRect.size.height/2) canvasWidth:blRect.size.width canvasHeight:blRect.size.height label:label];
        }
        
    }
    
    if(_br_error){
        CGRect brRect = CGRectMake(_roi.origin.x+_roi.size.width/2, _roi.origin.y + _roi.size.height/2, _roi.size.width/2, _roi.size.height/2);
        [self drawTargetRectangle:brRect color_component:red lineWidth:_line_width/2.0];
        if(_is_debuggable){
        NSString *label = [NSString stringWithFormat:@"Focus %d Glare  %d", _br_focus, _br_glare];
        [self drawText:brRect.origin.x yPosition:(brRect.origin.y + brRect.size.height/2) canvasWidth:brRect.size.width canvasHeight:brRect.size.height label:label];
        }
    }
}

- (void)drawOutlineAreas:(CGRect) rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    //    CGFloat components[] = {1.0, 1.0, 1.0, 0.5};
    //    CGColorRef color = CGColorCreate(colorspace, components);
    CGColorRef color;
    if(self.has_document) {
        color = [self colorwithHexString:_detected_id_outline_outside_color alpha:_detected_id_outline_outside_alpha colorSpace:colorspace];
    } else {
        color = [self colorwithHexString:_id_outline_outside_color alpha:_id_outline_outside_alpha colorSpace:colorspace];
    }
    
    CGContextSetFillColorWithColor( context, color );
    CGContextFillRect( context, rect );
    
    CGRect transparentRect =  CGRectMake(_roi.origin.x - _line_width/2, _roi.origin.y, _roi.size.width + _line_width, _roi.size.height);
    
    //    CGRect holeRectIntersection = CGRectIntersection( holeRect, rect );
    
    CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextFillRect( context, transparentRect );
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
}

- (void)drawTargetAreas:(CGRect) rect {
    
    const float length = 60;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    //    CGFloat components[] = {0.0, 1.0, 0.0, 1.0};
    //    CGColorRef color = CGColorCreate(colorspace, components);
    CGColorRef color;
    if(self.has_document){
        color = [self colorwithHexString:_detected_id_outline_color alpha:_detected_id_outline_color_alpha colorSpace:colorspace];
    }else{
        color = [self colorwithHexString:_id_outline_color alpha:_id_outline_color_alpha colorSpace:colorspace];
    }
    
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, _line_width);
    
    if (self.has_document) {
        CGContextAddRect(context, CGRectMake(_roi.origin.x, _roi.origin.y + _line_width/2.0, _roi.size.width, _roi.size.height - _line_width));
    } else {
        // top left |-
        CGContextMoveToPoint(context, _roi.origin.x, _roi.origin.y + length);
        CGContextAddLineToPoint(context, _roi.origin.x, _roi.origin.y + _line_width/2.0 );
        CGContextAddLineToPoint(context, _roi.origin.x + length, _roi.origin.y + _line_width/2.0);
        
        // top right -|
        CGContextMoveToPoint(context, _roi.origin.x+_roi.size.width-length, _roi.origin.y + _line_width/2.0);
        CGContextAddLineToPoint(context, _roi.origin.x+_roi.size.width, _roi.origin.y + _line_width/2.0);
        CGContextAddLineToPoint(context, _roi.origin.x+_roi.size.width, _roi.origin.y+length);
        
        // bottom right _|
        CGContextMoveToPoint(context, _roi.origin.x+_roi.size.width, _roi.origin.y+_roi.size.height-length);
        CGContextAddLineToPoint(context, _roi.origin.x+_roi.size.width, _roi.origin.y+_roi.size.height-_line_width/2.0);
        CGContextAddLineToPoint(context, _roi.origin.x+_roi.size.width-length, _roi.origin.y+_roi.size.height-_line_width/2.0);
        
        // bottom left
        CGContextMoveToPoint(context, _roi.origin.x,_roi.origin.y+_roi.size.height-length);
        CGContextAddLineToPoint(context, _roi.origin.x,_roi.origin.y+_roi.size.height-_line_width/2.0);
        CGContextAddLineToPoint(context, _roi.origin.x+length, _roi.origin.y+_roi.size.height-_line_width/2.0);
    }
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
}

- (void)drawTargetRectangle:(CGRect)rect color_component:(CGFloat[])color_component lineWidth:(float)lineWidth{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorspace, color_component);
    
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, lineWidth);
    
    CGContextAddRect(context, rect);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
}

- (CGColorRef)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha colorSpace:(CGColorSpaceRef)colorSpace;
{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    //    UIColor *color =
    //    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
    //                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
    //                     blue:((CGFloat) (hexint & 0xFF))/255
    //                    alpha:alpha];
    
    float r = (CGFloat) (((hexint & 0xFF0000) >> 16))/255;
    float g = (CGFloat) (((hexint & 0xFF00) >> 8))/255;
    float b = (CGFloat) ((hexint & 0xFF))/255;
    
    CGFloat components[] = {r, g, b, alpha};
    
    return CGColorCreate(colorSpace, components);
}

- (void)drawText:(CGFloat)xPosition yPosition:(CGFloat)yPosition canvasWidth:(CGFloat)canvasWidth canvasHeight:(CGFloat)canvasHeight label:(NSString*)label
{
    //Draw Text
    CGRect textRect = CGRectMake(xPosition, yPosition, canvasWidth, canvasHeight);
    NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 20], NSForegroundColorAttributeName: UIColor.redColor, NSParagraphStyleAttributeName: textStyle};
    
    [label drawInRect: textRect withAttributes: textFontAttributes];
}

@end
