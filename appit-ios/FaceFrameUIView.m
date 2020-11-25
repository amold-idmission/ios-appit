//
//  FaceFrameUIView.m
//  appit-ios
//
//  Created by idmission on 14/10/15.
//  Copyright © 2015 IDMission. All rights reserved.
//

#import "FaceFrameUIView.h"

#define DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

@implementation FaceFrameUIView

@synthesize backgroundColor = _backgroundColor;
@synthesize faceRectsArray = _faceRectsArray;
@synthesize smileRectsArray = _smileRectsArray;
@synthesize commonSmileEyeCGPointArray = _commonSmileEyeCGPointArray;

-(void)initializationMethod {
    _backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    _faceRectsArray = [[NSMutableArray alloc] init];
    _smileRectsArray = [[NSMutableArray alloc] init];
    _commonSmileEyeCGPointArray = [[NSMutableArray alloc] init];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializationMethod];
        self.opaque = NO;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializationMethod];
        self.opaque = NO;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    //If face rectangle not found then set clear view without any white background.
    if([_faceRectsArray count]<=0){
        [self initializationMethod];
    }
    
    // Drawing code
    [_backgroundColor setFill];
    UIRectFill(rect);
    
    // Clear face rect area with ellipse size.
    // Clear the background in the given rectangles.
    for (NSValue *holeRectValue in _faceRectsArray) {
        CGRect holeRect = [holeRectValue CGRectValue];
        CGRect holeRectIntersection = CGRectIntersection( holeRect, rect );
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if( CGRectIntersectsRect( holeRectIntersection, rect ) )
        {
            CGContextAddEllipseInRect(context, holeRectIntersection);
            CGContextClip(context);
            CGContextClearRect(context, holeRectIntersection);
            CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
            CGContextFillRect( context, holeRectIntersection);
        }
    }
    
    
    //Draw smile if smile rect available.
    for (NSValue *smileRectangle in _smileRectsArray) {
        
        CGRect smileRect = [smileRectangle CGRectValue];
        
        CGFloat radius = 50;
        
        UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake((smileRect.origin.x+(smileRect.size.width)/2), smileRect.origin.y-radius)
                                                             radius:radius
                                                         startAngle:DEGREES_TO_RADIANS(50)
                                                           endAngle:DEGREES_TO_RADIANS(130)
                                                          clockwise:YES];
        
        UIColor *strokeColor = [UIColor whiteColor];
        [strokeColor setStroke];
        
        [aPath stroke];
    }
    
    //Draw eye if eye rect available.
    for (NSValue *commonSmileEye in _commonSmileEyeCGPointArray) {
        
        CGPoint commonSmileEyePoint = [commonSmileEye CGPointValue];
        
        CGFloat radius = 50;

        UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(commonSmileEyePoint.x, commonSmileEyePoint.y-radius)
                                                             radius:radius
                                                         startAngle:DEGREES_TO_RADIANS(50)
                                                           endAngle:DEGREES_TO_RADIANS(130)
                                                          clockwise:YES];
        
        UIColor *strokeColor = [UIColor whiteColor];
        [strokeColor setStroke];
        
        [aPath stroke];
    }
}

@end
