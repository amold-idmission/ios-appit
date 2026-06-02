//
//  TFDetectedDataClass.h
//  AppItFramework
//
//  Created by Sanket Garde on 28/08/20.
//  Copyright © 2020 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TFDetectedDataClass : NSObject

@property(nonatomic) UIImage *originalImage;
@property(nonatomic) UIImage *croppedImage;
@property(nonatomic) UIImage *docDetect_InputImage;
@property(nonatomic) UIImage *realness_InputFullImage;
@property(nonatomic) UIImage *realness_InputCroppedImage;
@property(nonatomic) UIImage *focus_InputImage;

@property(nonatomic) CGRect documentLocation;
@property(nonatomic) float confidence;
@property(nonatomic) CGRect mrzLocation;
@property(nonatomic) float confidenceMRZ;
@property(nonatomic) CGRect pdf417Location;
@property(nonatomic) float confidencePDF417;
@property(nonatomic) CGRect primaryFaceLocation;
@property(nonatomic) float confidencePrimaryFace;
@property(nonatomic) CGRect secondaryFaceLocation;
@property(nonatomic) float confidenceSecondaryFace;
@property(nonatomic) CGRect documentLocationPP;
@property(nonatomic) float confidencePP;
@property(nonatomic) float confidenceGlare;

@property(nonatomic) float photoCopyScore;
@property(nonatomic) float realScore;
@property(nonatomic) float screenScore;
@property(nonatomic) float focus;

@property(nonatomic) float widthRatio;
@property(nonatomic) float realAverage;

@property(nonatomic) NSString *timeStamp;
@property(nonatomic) CGRect leftRotated_documentLocation;

-(id)initWithData:(float)confidence documentLocation:(CGRect)documentLocation focus:(float)focus glare:(float)glare;
-(id)initWithData:(float)confidence confidencePP:(float)confidencePP confidenceMRZ:(float)confidenceMRZ documentLocation:(CGRect)documentLocation documentLocationPP:(CGRect)documentLocationPP mrzLocation:(CGRect)mrzLocation focus:(float)focus glare:(float)glare;

// Getter-Setter Methods For OriginalImage & CroppedImage
-(UIImage *)getOriginalImage;
-(void)setOriginalImage:(UIImage *)original_image;
-(UIImage *)getCroppedImage;
-(void)setCroppedImage:(UIImage *)cropped_image;

// Getter-Setter Methods For Model Input Image
-(UIImage *)getInputImage_ForDocDetectModel;
-(void)setInputImage_ForDocDetectModel:(UIImage *)input_image;

-(UIImage *)getInputImage_ForFocusModel;
-(void)setInputImage_ForFocusModel:(UIImage *)input_image;

-(UIImage *)getInputFullImage_ForRealnessModel;
-(void)setInputFullImage_ForRealnessModel:(UIImage *)input_image;

-(UIImage *)getInputCroppedImage_ForRealnessModel;
-(void)setInputCroppedImage_ForRealnessModel:(UIImage *)input_image;

// 0 : Document Location From Doc-Detect Model
-(CGRect)getDocumentLocation;
-(void)setDocumentLocation:(CGRect)documetRect;
-(float)getConfidence;

// 1 : MRZ Location From Doc-Detect Model
-(CGRect)getMRZLocation;
-(void)setMRZLocation:(CGRect)mrzRect;
-(float)getConfidenceMRZ;

// 2 : PDF417 Location From Doc-Detect Model
-(CGRect)getPDF417Location;
-(void)setPDF417Location:(CGRect)pdf417Rect;
-(float)getConfidencePDF417;

// 3 : PrimaryFace Location From Doc-Detect Model
-(CGRect)getPrimaryFaceLocation;
-(void)setPrimaryFaceLocation:(CGRect)primaryFaceRect;
-(float)getConfidencePrimaryFace;

// 4 : SecondaryFace Location From Doc-Detect Model
-(CGRect)getSecondaryFaceLocation;
-(void)setSecondaryFaceLocation:(CGRect)secondaryFaceRect;
-(float)getConfidenceSecondaryFace;

// 5 : Glare Value From Doc-Detect Model
-(float)getGlareConfidence;

// 7 : Two Page Passport Location From Doc-Detect Model
-(CGRect)getDocumentLocationPP;
-(void)setDocumentLocationPP:(CGRect)passportRect;
-(float)getConfidencePP;

// Getter Methods
-(float)getPhotoCopyScore;
-(float)getRealScore;
-(float)getScreenScore;
-(float)getFocus;

// Getter-Setter Methods For Width-Ration
-(float)getWidthRatio;
-(void)setWidthRatio:(float) widthRatio;

// Getter-Setter Methods For Real-Average
-(float)getRealAverage;
-(void)setRealAverage:(float)real_Avg;

// Getter-Setter Methods For Time-Stamp
-(NSString*)getTimeStamp;
-(void)setTimeStamp:(NSString*)time_stamp;

-(NSMutableDictionary *)toJSON;
-(NSMutableDictionary *)toJSON_withRotatedLeftRect;
-(NSMutableDictionary *)getBoundingBox:(CGRect )frame;
@end

