//
//  FaceFrameUIView.h
//  appit-ios
//
//  Created by idmission on 14/10/15.
//  Copyright © 2015 IDMission. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceFrameUIView : UIView{
}
@property(readwrite) NSMutableArray *faceRectsArray;
@property(readwrite) NSMutableArray *smileRectsArray;
@property(readwrite) NSMutableArray *commonSmileEyeCGPointArray;
@property(readwrite) UIColor *backgroundColor;

@end
