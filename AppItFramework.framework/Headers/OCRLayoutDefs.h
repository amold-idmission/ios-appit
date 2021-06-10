//
//  OCRLayoutDefs.h
//  AppItFramework
//
//  Created by Dipen Patel on 03/03/20.
//  Copyright © 2020 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCRLayoutDefs : NSObject

@property(nonatomic, strong) NSString *Name;
@property(nonatomic, strong) NSString *MRZPresent;
@property(nonatomic, strong) NSString *CountryCode;
@property(nonatomic, strong) NSString *mrzCountryCode;
@property(nonatomic, strong) NSString *DocumentTypeCode;
@property(nonatomic, strong) NSString *Side;
@property(nonatomic, strong) NSString *state;
@property(nonatomic, strong) NSString *Component_Name;
@property(nonatomic, strong) NSString *Component_Format;
@property(nonatomic, strong) NSString *Component_PreserveSpace;

-(id)initOCRLayoutDefs:(NSString *)Name
            MRZPresent:(NSString *)MRZPresent
           CountryCode:(NSString *)CountryCode
        mrzCountryCode:(NSString *)mrzCountryCode
      DocumentTypeCode:(NSString *)DocumentTypeCode
                  Side:(NSString *)Side
                 state:(NSString *)state
        Component_Name:(NSString *)Component_Name
      Component_Format:(NSString *)Component_Format
Component_PreserveSpace:(NSString *)Component_PreserveSpace;

-(NSString *) getName;
-(NSString *) getMRZPresent;
-(NSString *) getCountryCode;
-(NSString *) getmrzCountryCode;
-(NSString *) getDocumentTypeCode;
-(NSString *) getSide;
-(NSString *) getstate;
-(NSString *) getComponent_Name;
-(NSString *) getComponent_Format;
-(NSString *) getComponent_PreserveSpace;

@end

NS_ASSUME_NONNULL_END
