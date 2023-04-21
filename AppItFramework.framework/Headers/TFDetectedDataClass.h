//
//  TFDetectedDataClass.h
//  AppItFramework
//
//  Created by Sanket Garde on 28/08/20.
//  Copyright © 2020 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFDetectedDataClass : NSObject

@property(nonatomic) float confidence;
@property(nonatomic) CGRect documentLocation;
@property(nonatomic) float focus;
@property(nonatomic) float widthRatio;
@property(nonatomic) CGRect leftRotated_documentLocation;

//@property(nonatomic) float cardPrinterScore;
@property(nonatomic) float photoCopyScore;
@property(nonatomic) float realScore;
//@property(nonatomic) float realSmudgedScore;
@property(nonatomic) float screenScore;
@property (nonatomic) NSString *timeStamp;

-(id)initWithData:(float)confidence documentLocation:(CGRect)documentLocation focus:(float)focus;
-(CGRect)getDocumentLocation;
-(float)getConfidence;
-(float)getFocus;

-(float)getPhotoCopyScore;
-(float)getRealScore;
-(float)getScreenScore;

-(float)getWidthRatio;
-(void)setWidthRatio:(float) widthRatio;

-(NSString*)getTimeStamp;
-(void)setTimeStamp:(NSString*)time_stamp;

-(NSMutableDictionary *)toJSON;
-(NSMutableDictionary *)toJSON_withRotatedLeftRect;
-(NSMutableDictionary *)getBoundingBox:(CGRect )frame;
@end

