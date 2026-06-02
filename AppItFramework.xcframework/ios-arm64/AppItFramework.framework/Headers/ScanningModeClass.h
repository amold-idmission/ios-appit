//
//  ScanningModeClass.h
//  AppItFramework
//
//  Created by Sanket Garde on 04/03/20.
//  Copyright © 2020 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ScanningModeClass : NSObject {
    bool scanMRZPassport, scanMRZNID, scanBarcode, scanBarcodeMRZ;
    float startPoint, endPoint;
//    public int xmlTemplateWidth, xmlTemplateHeight;
    NSString *messageToDisplay;
}

-(id)initWithData:(bool)scan_MRZ_Passport scan_MRZ_NID:(bool)scan_MRZ_NID scan_Barcode:(bool)scan_Barcode scan_Barcode_MRZ:(bool)scan_Barcode_MRZ start_Point:(float)start_Point end_Point:(float)end_Point message:(NSString *)message;

-(bool) getIsScanMRZPassport;

-(bool) getIsScanMRZNID;

-(bool) getIsScanBarcode;

-(bool) getIsScanBarcodeMRZ;

-(float) getStartPoint;

-(float) getEndPoint;

-(NSString *) getMessageToDisplay ;

-(NSString *) getScanMode;

@end


