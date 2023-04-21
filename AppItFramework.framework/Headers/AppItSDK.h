//
//  AppItSDK.h
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 20/10/16.
//  Copyright © 2016 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonImporter.h"
#import "GlobalGetterSetter.h"

//Delegate that need to be implemented in caller app
//Below methods will be called when result will be available
@protocol AppItSDKResponse <NSObject>

@optional
-(void)initializeSDKResponse : (NSMutableDictionary* _Nonnull) result;
-(void)modelDownloadResponse : (NSMutableDictionary* _Nonnull) result;
-(void)faceDetectionResponse : (NSMutableDictionary* _Nonnull) result;
-(void)captureImageResponse : (NSMutableDictionary* _Nonnull) result;
-(void)captureSignatureResponse : (NSMutableDictionary* _Nonnull) result;
-(void)genericDocumentResponse : (NSMutableDictionary* _Nonnull) result;
-(void)voiceRecordingResponse : (NSMutableDictionary* _Nonnull) result;
-(void)videoRecordingResponse : (NSMutableDictionary* _Nonnull) result;
-(void)videoConferencingResponse : (NSMutableDictionary* _Nonnull) result;
-(void)fourFingerprintDetectionResponse : (NSMutableDictionary* _Nonnull) result;
-(void)fingerprintEnrolmentResponse : (NSMutableDictionary* _Nonnull) result;
-(void)fingerprintVerificationResponse : (NSMutableDictionary* _Nonnull) result;
-(void)cardDetectionResponse : (NSMutableDictionary* _Nonnull) result;
-(void)snippetCaptureResponse : (NSMutableDictionary * _Nonnull)result;
-(void)scanBarcodeResponse : (NSMutableDictionary* _Nonnull) result;
-(void)gpsCoordinateResponse : (NSMutableDictionary* _Nonnull) result;
-(void)downloadXsltResultResponse : (NSMutableDictionary* _Nonnull) result;
-(void)proofOfAddressDetectionResponse : (NSMutableDictionary* _Nonnull) result;
-(void)bankStatementDetectionResponse : (NSMutableDictionary* _Nonnull) result;
-(void)birthCertificateDetectionResponse : (NSMutableDictionary* _Nonnull) result;
-(void)autoFillResponse : (NSMutableDictionary* _Nonnull) result;
-(void)onAutoFillFieldInformationAvailable : (NSMutableDictionary* _Nonnull) result;
-(void)onDownloadCountryResultAvailable : (NSMutableDictionary* _Nonnull) result;
-(void)onDownloadStateResultAvailable : (NSMutableDictionary* _Nonnull) result;

-(void)processImageResponse : (NSMutableDictionary* _Nonnull) result;
-(void)faceMatchingResponse : (NSMutableDictionary* _Nonnull) result;
-(void)processImageAndFaceMatchingResponse : (NSMutableDictionary* _Nonnull) result;

-(void)verifyCustomerResponse : (NSMutableDictionary* _Nonnull) result;
-(void)updateCustomerResponse : (NSMutableDictionary * _Nonnull)result;

-(void)createEmployeeResponse : (NSMutableDictionary * _Nonnull)result;
-(void)verifyEmployeeResponse : (NSMutableDictionary * _Nonnull)result;
-(void)updateEmployeeResponse : (NSMutableDictionary * _Nonnull)result;

-(void)generateTokenResponse : (NSMutableDictionary * _Nonnull)result;
-(void)verifyTokenResponse : (NSMutableDictionary * _Nonnull)result;

-(void)generateOTPResponse : (NSMutableDictionary * _Nonnull)result;
-(void)verifyOTPResponse : (NSMutableDictionary * _Nonnull)result;

-(void)executeGenericResponse : (NSMutableDictionary * _Nonnull)result;
-(void)updateGenericResponse : (NSMutableDictionary * _Nonnull)result;
-(void)genericApiCallResponse : (NSMutableDictionary * _Nonnull)result;

-(void)completeOperationResponse : (NSMutableDictionary* _Nonnull) result;
-(void)verifyPOAResponse : (NSMutableDictionary* _Nonnull)result;
-(void)idValidationAndVideoMatchingResponse : (NSMutableDictionary * _Nonnull)result;

@end

@class AVCaptureDevice;

@interface AppItSDK : NSObject

extern NSString const *FRONT_IMAGE, *BACK_IMAGE, *FACE_IMAGE, *CARD_IMAGE, *PROCESSED_FACE_IMAGE, *INPUT_IMAGE_FRONT, *PROCESSED_IMAGE_FRONT, *OVAL_FACE;

extern NSArray const *IGNORE_RESPONSE_NODE;

enum SDKLanguage{
     SDKLanguage_EN=1,
     SDKLanguage_ES=2,
     SDKLanguage_MY=3,
     SDKLanguage_AR=4,
     SDKLanguage_FR=5
};

enum SDKIDType{
    SDKIDType_PASSPORT = 1,
    SDKIDType_NATIONAL_ID = 2,
    SDKIDType_RESIDENCE_CARD = 3,
    SDKIDType_DRIVERS_LICENSE = 4,
    SDKIDType_PHOTO_ID_CARD = 5,
    SDKIDType_VOTER_ID_CARD = 6,
    SDKIDType_TAX_ID_CARD = 7,
    SDKIDType_WORK_VISA_PERMIT = 8,
    SDKIDType_STUDENT_VISA_PERMIT = 9,
    SDKIDType_MILITARY_POLICE_GOVERNMENT_ID = 10,
    SDKIDType_BOAT_SHIP_ID_CARD = 11,
    SDKIDType_IDM = 12,
    SDKIDType_UTILITY_BILL = 13,
    SDKIDType_OTHERS = 14
};

//MARK: - Initialize SDK API
+(void)initializeAppItSDK:(id _Nonnull)instance url:(NSString* _Nonnull)url loginId:(NSString* _Nonnull)loginId password:(NSString* _Nonnull)password merchantID:(NSString* _Nonnull)merchantID productID:(NSString* _Nonnull)productID productName:(NSString* _Nonnull)productName Language:(NSString* _Nonnull)Language;
+(void)initializeAppItSDK:(id _Nonnull)instance url:(NSString* _Nonnull)url loginId:(NSString* _Nonnull)loginId password:(NSString* _Nonnull)password merchantID:(NSString* _Nonnull)merchantID productID:(NSString* _Nonnull)productID productName:(NSString* _Nonnull)productName Language:(NSString* _Nonnull)Language enableGPS:(bool)enableGPS;
+(void)initializeAppItSDK:(id _Nonnull)instance url:(NSString* _Nonnull)url loginId:(NSString* _Nonnull)loginId password:(NSString* _Nonnull)password merchantID:(NSString* _Nonnull)merchantID productID:(NSString* _Nonnull)productID productName:(NSString* _Nonnull)productName language:(enum SDKLanguage)language enableGPS:(bool)enableGPS;
+(void)initializeAppItSDK:(id _Nonnull)instance url:(NSString* _Nonnull)url loginId:(NSString* _Nonnull)loginId password:(NSString* _Nonnull)password merchantID:(NSString* _Nonnull)merchantID productID:(NSString* _Nonnull)productID productName:(NSString* _Nonnull)productName Language:(NSString* _Nonnull)Language EnableDebug:(bool)EnableDebug enableGPS:(bool)enableGPS;
+(void)initializeLabels:(NSMutableDictionary*)englishLabels spanishLabels:(NSMutableDictionary*)spanishLabels;

//MARK: - Download Country & State List API
+(void)downloadCountryList:(id)instance isProgressVisible:(bool)isProgressViewVisisble;
+(void)downloadStateList:(UIViewController*)instance countryIDCode:(NSString*)countryCode isProgressVisible:(bool)isProgressViewVisisble;

//MARK: - Autofill API
+(void)autoFill:(id)instance idCaptureConfig:(NSMutableDictionary *)idCaptureConfig additionalDictionary:(NSMutableDictionary *)additionalDictionary;
+(void)getAutoFillFieldInformation:(id)instance uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;

//MARK: - Generic API
+(void)executeGenericRequest:(id)instance customProductDefination:(NSMutableDictionary*)customProductDefination additionalDictionary:(NSMutableDictionary*)additionalDictionary employeeDictionary:(NSMutableDictionary*)employeeDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey;

//MARK: - Capture-ID API
+(void)captureFrontImage:(id _Nonnull)instance additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary uiConfigDictionary:(NSMutableDictionary* _Nullable)uiConfigDictionary;
+(void)captureBackImage:(id _Nonnull)instance additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary uiConfigDictionary:(NSMutableDictionary* _Nullable)uiConfigDictionary;

//MARK: - Capture Secondary-ID API
+(void)captureSecondaryFrontImage:(id _Nonnull)instance additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary uiConfigDictionary:(NSMutableDictionary* _Nullable)uiConfigDictionary;
+(void)captureSecondaryBackImage:(id _Nonnull)instance additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary uiConfigDictionary:(NSMutableDictionary* _Nullable)uiConfigDictionary;

//MARK: - ProcessImage API
+(void)processImage:(id _Nonnull)instance countryCode:(NSString* _Nullable)countryCode stateCode:(NSString* _Nullable)stateCode idType:(NSString* _Nullable)idType;
+(void)processImage:(id _Nonnull)instance countryCode:(NSString* _Nullable)countryCode stateCode:(NSString* _Nullable)stateCode idType:(NSString* _Nullable)idType additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary;
+(void)processImage:(id _Nonnull)instance countryCode:(NSString* _Nullable)countryCode stateCode:(NSString* _Nullable)stateCode idType:(NSString* _Nullable)idType additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary finalSubmit:(bool)finalSubmit;
+(void)processImage:(id _Nonnull)instance countryCode:(NSString* _Nullable)countryCode stateCode:(NSString* _Nullable)stateCode idType:(NSString* _Nullable)idType additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey;
+(void)processImage:(id _Nonnull)instance countryCode:(NSString* _Nullable)countryCode stateCode:(NSString* _Nullable)stateCode id_Type:(enum SDKIDType)id_Type additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey employeeDictionary:(NSMutableDictionary* _Nullable)employeeDictionary;
+(void)processImage:(id _Nonnull)instance countryCode:(NSString* _Nullable)countryCode stateCode:(NSString* _Nullable)stateCode idType:(NSString* _Nullable)idType additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey employeeDictionary:(NSMutableDictionary* _Nullable)employeeDictionary;

//MARK: - Detect Face API
+(void)detectFace:(id _Nonnull)instance faceCaptureConfig:(NSMutableDictionary* _Nullable)faceCaptureConfig;
+(void)detectFace:(id _Nonnull)instance faceCaptureConfig:(NSMutableDictionary* _Nullable)faceCaptureConfig uiConfigDictionary:(NSMutableDictionary* _Nullable)uiConfigDictionary;

//MARK: - Match Face API
+(void)matchFaceImage:(id _Nonnull)instance faceImageType:(NSString* _Nullable)faceImageType idImageType:(NSString* _Nullable)idImageType;
+(void)matchFaceImage:(id _Nonnull)instance faceImageType:(NSString* _Nullable)faceImageType idImageType:(NSString* _Nullable)idImageType additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary;
+(void)matchFaceImage:(id _Nonnull)instance faceImageType:(NSString* _Nullable)faceImageType idImageType:(NSString* _Nullable)idImageType additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary finalSubmit:(bool)finalSubmit;
+(void)matchFaceImage:(id _Nonnull)instance faceImageType:(NSString* _Nullable)faceImageType idImageType:(NSString* _Nullable)idImageType additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey;
+(void)matchFaceImage:(id _Nonnull)instance faceImageType:(NSString* _Nullable)faceImageType idImageType:(NSString* _Nullable)idImageType additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary clearFormKey:(bool)clearFormKey employeeDictionary:(NSMutableDictionary* _Nullable)employeeDictionary;

//MARK: - Verify Customer API
+(void)verifyCustomer:(id _Nonnull)instance biometricType:(NSString* _Nullable)biometricType;
+(void)verifyCustomer:(id _Nonnull)instance biometricType:(NSString* _Nullable)biometricType additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary;
+(void)verifyCustomer:(id _Nonnull)instance biometricType:(NSString* _Nullable)biometricType additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary clearFormKey:(bool)clearFormKey;

//MARK: - Update Customer API
+(void)updateCustomer:(id _Nonnull)instance additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary;
+(void)updateCustomer:(id _Nonnull)instance faceImageType:(NSString* _Nullable)faceImageType additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary;

//MARK: - Capture Address Proof API
+(void)captureAddressProof:(id)instance;
+(void)captureAddressProof:(id)instance capturePortrait:(bool)capturePortrait;
+(void)captureAddressProof:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth;
+(void)captureAddressProof:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary;
+(void)captureAddressProof:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency;
+(void)captureAddressProof:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage*)titleImage;
+(void)captureAddressProof:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage*)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage*)instructionimage;
+(void)captureAddressProof:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage isCaptureEnabled:(bool)isCaptureEnabled;
+(void)captureAddressProof:(NSString*)id_capture_type instance:(id)instance titleImage:(UIImage *)titleImage additionalDictionary:(NSMutableDictionary*)additionalDictionary instructionimage:(UIImage*)instructionimage fieldName:(NSString*)fieldName uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary ;

//MARK: - Capture Bank-Statement API
+(void)captureBankStatement:(id)instance;
+(void)captureBankStatement:(id)instance capturePortrait:(bool)capturePortrait;
+(void)captureBankStatement:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth;
+(void)captureBankStatement:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary;
+(void)captureBankStatement:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency;
+(void)captureBankStatement:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage*)titleImage;
+(void)captureBankStatement:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage*)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage*)instructionimage;
+(void)captureBankStatement:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary *)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage isCaptureEnable:(bool)isCaptureEnable;
+(void)captureBankStatement:(NSString*)id_capture_type instance:(id)instance titleImage:(UIImage *)titleImage additionalDictionary:(NSMutableDictionary*)additionalDictionary instructionimage:(UIImage*)instructionimage fieldName:(NSString*)fieldName uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;

//MARK: - Capture Birth Certificate API
+(void)captureBirthCertificate:(id)instance;
+(void)captureBirthCertificate:(id)instance capturePortrait:(bool)capturePortrait;
+(void)captureBirthCertificate:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth;
+(void)captureBirthCertificate:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary;
+(void)captureBirthCertificate:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency;
+(void)captureBirthCertificate:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage*)titleImage;
+(void)captureBirthCertificate:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage*)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage*)instructionimage;
+(void)captureBirthCertificate:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary *)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage isCaptureEnable:(bool)isCaptureEnable;
+(void)captureBirthCertificate:(NSString*)id_capture_type instance:(id)instance titleImage:(UIImage *)titleImage additionalDictionary:(NSMutableDictionary*)additionalDictionary instructionimage:(UIImage*)instructionimage fieldName:(NSString*)fieldName uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;

//MARK: - Capture Generic Document API
+(void)captureGenericDocument:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary *)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage genericFieldName:(NSString*)genericFieldName;
+(void)captureGenericDocument:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary *)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage genericFieldName:(NSString*)genericFieldName isCaptureEnable:(bool)isCaptureEnable;
+(void)captureGenericDocument:(NSString*)id_capture_type instance:(id)instance titleImage:(UIImage *)titleImage additionalDictionary:(NSMutableDictionary*)additionalDictionary instructionimage:(UIImage*)instructionimage fieldName:(NSString*)fieldName uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;
+(void)captureGenericDocument:(id _Nonnull)instance additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary uiConfigDictionary:(NSMutableDictionary* _Nullable)uiConfigDictionary fieldName:(NSString* _Nonnull)fieldName;

//MARK: - Capture Four-FingerPrint API
+(void)captureFourFingerprint:(id _Nonnull)instance cameraFingerCaptureConfig:(NSMutableDictionary* _Nullable)cameraFingerCaptureConfig;

//MARK: - Capture Voice Recording API

+(void)startVoiceRecording:(id)instance recordingTime:(int)recordingTime additionalDictionary:(NSMutableDictionary*)additionalDictionary;
+(void)startVoiceRecording:(id _Nonnull)instance voiceRecordingConfig:(NSMutableDictionary* _Nullable)voiceRecordingConfig additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary;

//MARK: - Capture Video Recording API
+(void)startVideoRecording:(UIViewController*)instance recordingTime:(int)recordingTime additionalDictionary:(NSMutableDictionary*)additionalDictionary textDatatoScrolled:(NSString*)textDatatoScrolled;
+(void)startVideoRecording:(UIViewController*)instance recordingTime:(int)recordingTime additionalDictionary:(NSMutableDictionary*)additionalDictionary textDatatoScrolled:(NSString*)textDatatoScrolled isEnableBgVideoRecording:(BOOL)isEnableBgVideoRecording;
+(void)startVideoRecording:(UIViewController*)instance recordingTime:(int)recordingTime minrecordingTime:(int)minRecordingTime additionalDictionary:(NSMutableDictionary*)additionalDictionary textDatatoScrolled:(NSString*)textDatatoScrolled;

//MARK: - FingerPrint Enrollment API
+(void)enrollFingerprint:(id _Nonnull)instance additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary clearFormKey:(bool)clearFormKey;

//MARK: - VerifyFingerprint API
+(void)verifyFingerprint:(id _Nonnull)instance additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary clearFormKey:(bool)clearFormKey;

//MARK: - Clear Fingerprint API
+(void)clearAllFingerprints:(id _Nonnull)instance;
+(void)clearSelectedFingerPrint:(id _Nonnull)instance selectedFinger:(NSString * _Nullable)selectedFinger;

//MARK: - ProcessImage & MatchFace API
+(void)processImageAndMatchFace:(id _Nonnull)instance countryCode:(NSString* _Nullable)countryCode stateCode:(NSString* _Nullable)stateCode idType:(NSString* _Nullable)idType faceImageType:(NSString* _Nullable)faceImageType;
+(void)processImageAndMatchFace:(id _Nonnull)instance countryCode:(NSString* _Nullable)countryCode stateCode:(NSString* _Nullable)stateCode idType:(NSString* _Nullable)idType faceImageType:(NSString* _Nullable)faceImageType  additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary;
+(void)processImageAndMatchFace:(id _Nonnull)instance countryCode:(NSString* _Nullable)countryCode stateCode:(NSString* _Nullable)stateCode idType:(NSString* _Nullable)idType faceImageType:(NSString* _Nullable)faceImageType  additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary finalSubmit:(bool)finalSubmit;
+(void)processImageAndMatchFace:(id _Nonnull)instance countryCode:(NSString* _Nullable)countryCode stateCode:(NSString* _Nullable)stateCode idType:(NSString* _Nullable)idType faceImageType:(NSString* _Nullable)faceImageType  additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey;
+(void)processImageAndMatchFace:(id _Nonnull)instance countryCode:(NSString* _Nullable)countryCode stateCode:(NSString* _Nullable)stateCode id_Type:(enum SDKIDType)id_Type faceImageType:(NSString* _Nullable)faceImageType  additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey employeeDictionary:(NSMutableDictionary* _Nullable)employeeDictionary;
+(void)processImageAndMatchFace:(id _Nonnull)instance countryCode:(NSString* _Nullable)countryCode stateCode:(NSString* _Nullable)stateCode idType:(NSString* _Nullable)idType faceImageType:(NSString* _Nullable)faceImageType  additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey employeeDictionary:(NSMutableDictionary* _Nullable)employeeDictionary;

//MARK: - IDValidation With Video Match API
+(void)idValidationAndMatchVideo:(id _Nonnull)instance countryCode:(NSString* _Nullable)countryCode stateCode:(NSString* _Nullable)stateCode id_Type:(enum SDKIDType)id_Type additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey employeeDictionary:(NSMutableDictionary* _Nullable)employeeDictionary;
+(void)idValidationAndMatchVideo:(id _Nonnull)instance countryCode:(NSString* _Nullable)countryCode stateCode:(NSString* _Nullable)stateCode idType:(NSString* _Nullable)idType additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey employeeDictionary:(NSMutableDictionary* _Nullable)employeeDictionary;

//MARK: - Detect Card
+(void)detectCard:(id _Nonnull)instance;
+(void)detectCard:(id _Nonnull)instance additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary;

//MARK: - Scan Barcode
+(void)scanBarcode:(id _Nonnull)instance;
+(void)scanBarcode:(id _Nonnull)instance showPortraitBarcodeScreen:(bool)showPortraitBarcodeScreen barcodeScanText:(NSString*)barcodeScanText;
+(void)scanBarcode:(id _Nonnull)instance uiConfigDictionary:(NSMutableDictionary* _Nullable)uiConfigDictionary;

//MARK: - Capture Signature
+(void)captureSignature:(id _Nonnull)instance;
+(void)captureSignature:(id _Nonnull)instance uiConfigDictionary:(NSMutableDictionary* _Nullable)uiConfigDictionary;

//MARK: - Snippet Capture
+(void)snippetCapture:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedIdOutlineColor:(NSString*)detectedIdOutlineColor detectedIdOutlineTransparency:(int)detectedIdOutlineTransparency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage snippetFieldsDictionary:(NSMutableDictionary*)snippetFieldsDictionary;
+(void)snippetCapture:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedIdOutlineColor:(NSString*)detectedIdOutlineColor detectedIdOutlineTransparency:(int)detectedIdOutlineTransparency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage snippetFieldsDictionary:(NSMutableDictionary*)snippetFieldsDictionary isCaptureEnable:(bool)isCaptureEnable;
+(void)snippetCapture:(NSString*)id_capture_type instance:(id)instance titleImage:(UIImage *)titleImage additionalDictionary:(NSMutableDictionary*)additionalDictionary instructionimage:(UIImage*)instructionimage fieldName:(NSString*)fieldName uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;
+(void)snippetCapture:(id _Nonnull)instance additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary uiConfigDictionary:(NSMutableDictionary* _Nullable)uiConfigDictionary snippetFieldsDictionary:(NSMutableDictionary* _Nullable)snippetFieldsDictionary isIdCaptureCall:(bool)isIdCaptureCall;

//MARK: - Slant capture
//+(void)captureSlantImage:(id)instance additionalDictionary:(NSMutableDictionary*)additionalDictionary uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;

//MARK: - Video Conferencing API Call
+(void)startVideoConferencing:(id _Nonnull)instance videoConferenceData:(NSMutableDictionary* _Nullable)videoConferenceData;

//MARK: - Generic API Call
+(void)genericApiCall:(id _Nonnull)instance genericDataDictionary:(NSMutableDictionary * _Nullable)genericDataDictionary;


+(void)setImages:(NSMutableDictionary* _Nullable)images;
+(void)getGPSCoordinate:(id _Nonnull)instance;
+(void)completeOperation:(id _Nonnull)instance;
//Customize User Interface Call
+(void)customizeUserInterface:(id)instance faceTitleOnTop:(bool)faceTitleOnTop hideFaceTitle:(bool)hideFaceTitle faceHintMessageOnTop:(bool)faceHintMessageOnTop hideFacehintMsg:(bool)hideFacehintMsg faceHintIconOnTop:(bool)faceHintIconOnTop hideFacehintIcon:(bool)hideFacehintIcon faceTitleImageOnTop:(bool)faceTitleImageOnTop hideFacetitleImage:(bool)hideFacetitleImage idCaptureTitleAlignment:(NSString*)idCaptureTitleAlignment hideIDCaptureTitle:(bool)hideIDCaptureTitle idCaptureHintMsgAlignment:(NSString*)idCaptureHintMsgAlignment hideIDCapturehintMsg:(bool)hideIDCapturehintMsg idCaptureTitleImgAlignment:(NSString*)idCaptureTitleImgAlignment hideIDCapturetitleImg:(bool)hideIDCapturetitleImg;
+(void)customizeUserInterface:(NSMutableDictionary* _Nonnull)uiconfiguration;
+(void)changeLanguageBundle:(NSString*)language;
+(NSString*)getLanguageBundle;
+(void)generateOTP:(id _Nonnull)instance additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary emailId:(NSString* _Nullable)emailId mobileNumber:(NSString* _Nullable)mobileNumber notificationType:(NSString* _Nullable)notificationType;
+(void)verifyOTP:(id _Nonnull)instance additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary receivedOTP:(NSString* _Nonnull)receivedOTP;
+(void)verifyAddress:(id _Nonnull)instance addressJSONDictionary:(NSMutableDictionary* _Nullable)addressJSONDictionary additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary doExtract:(bool)doExtract doVerify:(bool)doVerify finalSubmit:(bool)finalSubmit;
+(void)createEmployee:(id _Nonnull)instance employeeDictionary:(NSMutableDictionary* _Nullable)employeeDictionary additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary finalSubmit:(bool)finalSubmit;
+(void)verifyEmployee:(id _Nonnull)instance employeeCode:(NSString* _Nullable)employeeCode additionalDictionary:(NSMutableDictionary* _Nullable)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey;
+(void)generateToken:(id _Nonnull)instance;
+(void)verifyToken:(id _Nonnull)instance;

// Calls From Client Side -End

// Internal calls -Start
+(void)sendRequestAlreadyRunningResponse:(id)instance requetType:(int)requetType;
// Internal calls -End

//**********Parameter to Initialize SDK -Start
+(NSString *)getURL;
+(void)setURL:(NSString*)url;

+(NSString *)getLoginID;
+(void)setLoginID:(NSString*)loginId;

+(NSString *)getProductName;
+(void)setProductName:(NSString*)ProductNAME;

+(NSString *)getProductID;
+(void)setProductID:(NSString*)productID;

+(NSString *)getPassword;
+(void)setPassword:(NSString*)password;

+(NSString *)getMerchantID;
+(void)setMerchantID:(NSString*)merchantID;

+(NSString *)getCompanyID;
+(void)setCompanyID : (NSString*)companyID;

+(NSString *)getCompanyName;
+(void)setCompanyName : (NSString*)companyname;

+(int)getIdFocusThreshold;
+(void)setIdFocusThreshold : (int)idFocusThreshold;

+(int)getMinimumFocusThreshold;
+(void)setMinimumFocusThreshold:(int)minImageFocusScore;

+(bool)getCapturePortrait;
+(void)setCapturePortrait:(bool)CapturePortrait;

+(bool)getDisableDetectedRect_ID;
+(void)setDisableDetectedRect_ID : (bool)isDisableDetectedRectangle;

+(bool)getCaptureEnable;
+(void)setCaptureEnable : (bool)CaptureEnable;

//+(NSString *)getFieldName;
//+(void)setFieldName : (NSString*)fieldName;

+(int)getMinimumLightThreshold;
+(void)setMinimumLightThreshold:(int)minImageIntensity;

+(int)getImageHeight;
+(void)setImageHeight:(int)ImageHeight;

+(int)getImageWidth;
+(void)setImageWidth:(int)ImageWidth;

+(int)getImageSize;
+(void)setImageSize:(int)ImageSize;

+(NSString *)getLanguage;
+(void)setLanguage:(NSString*)Language;
+(void)updateLanguage:(NSString*)Language;
    
+(bool)isDebugEnable;
+(void)setDebugEnable:(bool)DebugEnable;

+(NSString *)getIdOutlineColor;
+(void)setIdOutlineColor:(NSString*)OutlineColor;

+(int)getIdOutlineColorAlpha;
+(void)setIdOutlineColorAlpha:(int)OutlineColorAlpha;

+(NSString *)getIdOutsideOutlineColor;
+(void)setIdOutsideOutlineColor:(NSString*)OutsideOutlineColor;

+(int)getIdOutsideOutlineAlpha;
+(void)setIdOutsideOutlineAlpha:(int)OutsideOutlineAlpha;

+(NSString *)getDetectedIdOutLineColor;
+(void)setDetectedIdOutLineColor:(NSString*)DetectedIdOutlineColor;

+(int)getDetectedIdOutlineAlpha;
+(void)setDetectedIdOutlineAlpha:(int)DetectedIdOutlineAlpha;

+(UIImage*)getIdCaptureTitleImage;
+(void)setIdCaptureTitleImage:(UIImage*)IdCaptureTitleImage;

+(NSString *)getDetectedIdPOAOutsideOutlineColor;
+(void)setDetectedIdPOAOutsideOutlineColor:(NSString*)detectedOutsideOutlineColor;

+(int)getDetectedIdPOAOutsideOutlineAlpha;
+(void)setDetectedIdPOAOutsideOutlineAlpha:(int)detectedOutsideOutlineAlpha;

+(NSMutableDictionary *)getSnippetFieldDict;
+(void)setSnippetFieldDict:(NSMutableDictionary*)snippetFieldDict;

+(int)getFPFocusThreshold;
+(void)setFPFocusThreshold:(int)focusThreshold;
//**********Parameter to Initialize SDK -Start

//**********Request Parameters -Start

//Additional data
+(NSMutableDictionary *)getAdditionalDataDictionary;
+(void)setAdditionalDataDictionary:(NSMutableDictionary*)additionalDataDictionary;

//User defined labels
+(NSMutableDictionary *)getEnglishLabelsDictionary;
+(void)setEnglishLabelsDictionary:(NSMutableDictionary*)englishLabelsDataDictionary;

+(NSMutableDictionary *)getSpanishLabelsDictionary;
+(void)setSpanishLabelsDictionary:(NSMutableDictionary*)spanishLabelsDataDictionary;

//Image Type
+(NSString *)getFrontInputImage;
+(void)setFrontInputImage:(NSString*)frontInputImage;

+(NSString *)getSecondaryFrontInputImage;
+(void)setSecondaryFrontInputImage:(NSString*)frontInputimage;

+(NSString *)getBackInputImage;
+(void)setBackInputImage:(NSString*)backInputImage;

+(NSString *)getSecondaryBackInputImage;
+(void)setSecondaryBackInputImage:(NSString*)backInputimage;

+(NSString *)getAutofillFrontInputImage;
+(void)setAutofillFrontInputImage:(NSString*)frontInputimage;

+(NSString *)getFaceImage;
+(void)setFaceImage:(NSString*)faceImage;

+(NSString *)getCroppedFaceImage;
+(void)setCroppedFaceImage:(NSString*)croppedFaceImage;

+(NSString *)getOvalFaceImage;
+(void)setOvalFaceImage:(NSString*)ovalFaceImage;


//Filter Type
+(NSString *)getCountryCodeFilter;
+(void)setCountryCodeFilter:(NSString*)countryCodeFilter;

+(NSString *)getStateCodeFilter;
+(void)setStateCodeFilter:(NSString*)stateCodeFilter;

+(NSString *)getImageTypeFilter;
+(void)setImageTypeFilter:(NSString*)imageTypeFilter;

//Face Matching Document Type
+(NSString *)getFaceMatchingDocumentType;
+(void)setFaceMatchingDocumentType:(NSString*)faceMatchingDocumentType;

+(NSString *)getFaceImageType;
+(void)setFaceImageType:(NSString*)faceImagetype;

+(NSString *)getBiometricType;
+(void)setBiometricType:(NSString*)biometrictype;

+(int)getGlarePercentageThreshold;
+(void)setGlarePercentageThreshold : (int)GlarePercentageThreshold;

+(int)getEnableCaptureButtonTime;
+(void)setEnableCaptureButtonTime : (int)EnableCaptureButtonTime;

+(int)getBarcodeScanMaxLimit;
+(void)setBarcodeScanMaxLimit : (int)barcodeScanMaxLimit;

+(NSString *)getCardImage;
+(void)setCardImage:(NSString*)cardImage;

+(NSString *)getProofOfAddressImage;
+(void)setProofOfAddressImage:(NSString*)poaImage;

+(NSString *)getBankStatementImage;
+(void)setBankStatementImage:(NSString*)bankStmtImage;

+(NSString *)getBirthCertificateImage;
+(void)setBirthCertificateImage:(NSString*)birthCertiImage;

+(NSString *)getGenericDocumentImage;
+(void)setGenericDocumentImage:(NSString*)genericDocument;

+(NSString *)getSnippetDocumentImage;
+(void)setSnippetDocumentImage:(NSString*)snippetDocument;

+(NSString *)getGenericFieldName;
+(void)setGenericfieldName:(NSString*)genericField;

/// Get Genric document name as stored in files
+(NSString *)getGenericDocumentName;

/// Set Genric document name as stored in files
/// @param name actual name e.g. sample.pdf
+(void)setGenericDocumentName:(NSString*)name;

+(NSString *)getGenericFieldFormatType;
+(void)setGenericFieldFormatType:(NSString*)genFieldFormatType;

+(NSString *)getConferenceID;
+(void)setConferenceID:(NSString*)confId;

+(NSString *)getVideoConferenceID;
+(void)setVideoConferenceID:(NSString*)confId;

+(bool)getFinalSubmit;
+(void)setFinalSubmit:(bool)finalSubmit;

+(bool)getClearFormKey;
+(void)setClearFormKey:(bool)clearFormKey;

//**********Request Parameters -End


//Form Key Param
+(NSString *)getFormKey;//Generate unique form key...return same value next time if value already exist
+(NSString*)getFormID:(NSDictionary *)dictionary;
+(void)clearFormKey; //Clear current formkey value
+(NSString *)currentFormKey;

//UUID Param
+(NSString *)getUUID;
+(void)setUUID:(NSString*)UUID;

//For updating complete operation request timestamp and getting it
+(void)updateCompleteOperationReqTimeStamp;
+(NSString *)getCompleteOperationReqTimeStamp;

//Call for deleting all data
+(void)deleteData;


//**********Parameters from Response -Start

+(NSString *)getFrontProcessedImage;
+(void)setFrontProcessedImage:(NSString*)frontProcessedImage;

//**********Parameters From Response -End

//For checking if SDK is initailized or not
+(BOOL)isSDKInitialized;

//For setting images
+(BOOL)addImage :(NSString*)imageType imageData:(NSString*)imageData;
+(BOOL)addImage :(NSString*)imageType imageData:(NSString*)imageData imageName:(NSString*)imageName;

//Get request URL to call server
+(NSMutableURLRequest*)getRequestURL:(NSString*)url updateCompleteOperationReqTimeStamp:(BOOL)updateCompleteOperationReqTimeStamp;

+(NSString*)getAdditionalDataXMLString:(NSMutableDictionary*)dict;
+(NSString*)getAdditionalDataXMLString:(NSMutableDictionary*)dict customProductDef:(NSMutableDictionary*)customProductDef;
+(NSString*)getLabelForKey:(NSString*)labelKey;
+(NSString*)generateXMLFromDictionary:(NSMutableDictionary*)dict;
+(NSString*)generateXMLFromDictionary:(NSMutableDictionary*)dict customProductDef:(NSMutableDictionary*)customProductDef;

+(NSString*)generateGenericXML:(NSMutableDictionary*)generic;
+(NSString*)getPredefinedValue:(NSString*)key;

//Set/Check : if image upload is running in background-Start
+(BOOL)isPoaUploadInProgress;
+(void)setPoaUploadInProgress:(BOOL)POAuploadInProgress;

+(BOOL)isBankStatementUploadInProgress;
+(void)setBankStatementUploadInProgress:(BOOL)BankStatementUploadInProgress;

+(BOOL)isBirthCertificateUploadInProgress;
+(void)setBirthCertificateUploadInProgress:(BOOL)BirthCertificateUploadInProgress;

+(BOOL)isGenericDocumentCaptureInProgress;
+(void)setGenericDocumentUploadInProgress:(BOOL)genericDocumentUploadInProgress;

+(BOOL)isCardUploadInProgress;
+(void)setCardUploadInProgress:(BOOL)CardUploadInProgress;

+(float)getAlpha:(int)transparency;

//Customize User Interface

+(bool)getFaceTitleOnTop;
+(void)setFaceTitleOnTop:(bool)FaceTitleOnTop;

+(bool)getFaceHintMessageOnTop;
+(void)setFaceHintMessageOnTop:(bool)FaceHintMessageOnTop;

+(bool)getFaceHintIconOnTop;
+(void)setFaceHintIconOnTop:(bool)FaceHintIconOnTop;

+(bool)getFaceTitleImageOnTop;
+(void)setFaceTitleImageOnTop:(bool)FaceTitleImageOnTop;

///////////////

+(bool)getHideFaceTitle;

+(void)setHideFaceTitle:(bool)HideFaceTitle;

+(bool)getHideFacehintMsg;

+(void)setHideFacehintMsg:(bool)HideFacehintMsg;

+(bool)getHideFacehintIcon;

+(void)setHideFacehintIcon:(bool)HideFacehintIcon;

+(bool)getHideFacetitleImage;

+(void)setHideFacetitleImage:(bool)HideFacetitleImage;

+(NSString *)getIdCaptureTitleAlignment;
+(void)setIdCaptureTitleAlignment:(NSString*)IdCaptureTitleAlignment;

+(NSString *)getIdCaptureHintMsgAlignment;
+(void)setIdCaptureHintMsgAlignment:(NSString*)IdCaptureHintMsgAlignment;

+(NSString *)getIdCaptureTitleImgAlignment;
+(void)setIdCaptureTitleImgAlignment:(NSString*)IdCaptureTitleImgAlignment;

+(bool)getHideIDCaptureTitle;

+(void)setHideIDCaptureTitle:(bool)HideIDCaptureTitle;

+(bool)getHideIDCapturehintMsg;

+(void)setHideIDCapturehintMsg:(bool)HideIDCapturehintMsg ;

+(bool)getHideIDCapturetitleImg;

+(void)setHideIDCapturetitleImg:(bool)HideIDCapturetitleImg;

//Face config
+(int)getFace_light_threshold;
+(void)setFace_light_threshold:(int)faceLight_threshold;

+(int)getFace_focus_threshold;
+(void)setFace_focus_threshold:(int)faceFocus_threshold;

+(bool)getLaunch_front_camera;
+(void)setLaunch_front_camera:(bool)launchFront_camera;

+(bool)getAllow_both_camera;
+(void)setAllow_both_camera:(bool)allowboth_camera;

+(int)getFace_smile_width_percentage_threshold;
+(void)setFace_smile_width_percentage_threshold:(int)smile_width_percentage_threshold;

+(bool)getFace_showPreviewScreen;
+(void)setFace_showPreviewScreen:(bool)faceShowPreviewScreen;

+(NSString *)getFace_outline_color;
+(void)setFace_outline_color:(NSString*)faceOutline_color;

+(int)getFace_outline_color_alpha;
+(void)setFace_outline_color_alpha:(int)faceOutline_color_alpha;

+(NSString *)getDetected_face_outline_color;
+(void)setDetected_face_outline_color:(NSString*)detectedFace_outline_color;

+(int)getDetected_face_outline_color_alpha;
+(void)setDetected_face_outline_color_alpha:(int)detectedFace_outline_color_alpha;

+(NSString *)getOutside_face_outline_color;
+(void)setOutside_face_outline_color:(NSString*)outsideFace_outline_color;

+(int)getOutside_face_outline_color_alpha;
+(void)setOutside_face_outline_color_alpha:(int)outsideFace_outline_color_alpha;

+(NSString *)getPassiveOutside_face_outline_color;
+(void)setPassiveOutside_face_outline_color:(NSString*)outsideFace_outline_color;

+(int)getPassiveOutside_face_outline_color_alpha;
+(void)setPassiveOutside_face_outline_color_alpha:(int)outsideFace_outline_color_alpha;


+(NSString *)getDetected_outside_face_outline_color;
+(void)setDetected_outside_face_outline_color:(NSString*)detectedOutside_face_outline_color;

+(int)getDetected_outside_face_outline_color_alpha;
+(void)setDetected_outside_face_outline_color_alpha:(int)detectedOutside_face_outline_color_alpha;

+(UIImage*)getTitleImageFace;
+(void)setTitleImageFace:(UIImage*)titleimageFace;

+(bool)getIsFireBaseAppConfigure;
+(void)setIsFireBaseAppConfigure : (bool)isFireAppConfigure;

+(NSString *)getFaceDummyImageColor;
+(void)setFaceDummyImageColor:(NSString*)face_dummy_image_color;

+(int)getFaceDummyImageColorAlpha;
+(void)setFaceDummyImageColorAlpha:(int)face_dummy_image_color_alpha;

+(NSString *)getFacePreviewScreen;
+(void)setFacePreviewScreen:(NSString *)face_preview_screen;

+(NSString *)getIdPreviewScreen;
+(void)setIdPreviewScreen:(NSString *)id_preview_screen;

//ID Capture config
+(NSString *)getTextFontStyle;
+(void)setTextFontStyle:(NSString*)text_font_style;

+(NSString *)getTextColor;
+(void)setTextColor:(NSString*)text_color;

+(int)getTextColorAlpha;
+(void)setTextColorAlpha:(int)text_color_alpha;

+(NSString *)getBackButtonColor;
+(void)setBackButtonColor:(NSString*)back_button_color;

+(int)getBackButtonColorAlpha;
+(void)setBackButtonColorAlpha:(int)back_button_color_alpha;

+(NSString *)getRetryButtonColor;
+(void)setRetryButtonColor:(NSString*)retry_button_color;

+(int)getRetryButtonColorAlpha;
+(void)setRetryButtonColorAlpha:(int)retry_button_color_alpha;

+(NSString *)getRetryButtonBorderColor;
+(void)setRetryButtonBorderColor:(NSString*)retry_button_border_color;

+(int)getRetryButtonBorderColorAlpha;
+(void)setRetryButtonBorderColorAlpha:(int)retry_button_border_color_alpha;

+(NSString *)getConfirmButtonColor;
+(void)setConfirmButtonColor:(NSString*)confirm_button_color;

+(int)getConfirmButtonColorAlpha;
+(void)setConfirmButtonColorAlpha:(int)confirm_button_color_alpha;

+(NSString *)getConfirmButtonStyle;
+(void)setConfirmButtonStyle:(NSString*)confirm_button_style;

+(int)getConfirmButtonStyleAlpha;
+(void)setConfirmButtonStyleAlpha:(int)confirm_button_style_alpha;

+(NSString *)getInstructionContinueButtonColor;
+(void)setInstructionContinueButtonColor:(NSString*)continue_button_color;

+(int)getInstructionContinueButtonColorAlpha;
+(void)setInstructionContinueButtonColorAlpha:(int)continue_button_color_alpha;

+(NSString *)getInstructionContinueButtonTextColor;
+(void)setInstructionContinueButtonTextColor:(NSString*)continue_button_text_color;

+(int)getInstructionContinueButtonTextColorAlpha;
+(void)setInstructionContinueButtonTextColorAlpha:(int)continue_button_color_text_alpha;

+(void)setIDCaptureBackgroundColor:(NSString*)id_capture_back_color;
+(NSString *)getIDCaptureBackgroundColor;

+(int)getIDCaptureBackgroundColorAlpha;
+(void)setIDCaptureBackgroundColorAlpha:(int)id_capture_back_color_trans;

+(void)setIDCaptureSuccessMessageColor:(NSString*)id_capture_success_msg_color;
+(NSString *)getIDCaptureSuccessMessageColor;

+(int)getIDCaptureSuccessMessageColorAlpha;
+(void)setIDCaptureSuccessMessageColorAlpha:(int)id_capture_success_msg_color_alpha;

+(NSMutableDictionary *)getUiIdConfigDict;
+(void)setUiIdConfigDict:(NSMutableDictionary*)uiIdConfigDictionary;

+(NSString *)getHeaderTextFontStyle;
+(void)setHeaderTextFontStyle:(NSString*)_headerFontStyle;

+(NSString *)getHeaderTextColor;
+(void)setHeaderTextColor:(NSString*)_headerTextColor;

+(int)getHeaderTextColorAlpha;
+(void)setHeaderTextColorAlpha:(int)_headerTextColorTrans;

+(NSString *)getHeaderTextSize;
+(void)setHeaderTextSize:(NSString*)_textHeaderSize;

+(NSString *)getTextSize;
+(void)setTextSize:(NSString*)_textSize;

+(bool)getEnableShadow;
+(void)setEnableShadow : (bool)EnableShadow;

+(NSString *)getCaptureButtonColor;
+(void)setCaptureButtonColor:(NSString*)CaptureButtonColor;

+(int)getCaptureButtonColorAlpha;
+(void)setCaptureButtonColorAlpha:(int)CaptureButtonColorAlpha;

//FP UI config
+(NSString *)getFPTextFontStyle;
+(void)setFPTextFontStyle:(NSString*)_fontStyleFP;

+(NSString *)getFPTextColor;
+(void)setFPTextColor:(NSString*)_textColorFP;

+(int)getFPTextColorAlpha;
+(void)setFPTextColorAlpha:(int)_textColorTransFP;

+(int)getFPInstructionContinueButtonTextColorAlpha;
+(void)setFPInstructionContinueButtonTextColorAlpha:(int)_instContinueButtonTransTextFP;

+(NSString *)getFPInstructionContinueButtonTextColor;
+(void)setFPInstructionContinueButtonTextColor:(NSString*)_instContinueButtonTextFP;

+(NSString *)getFPInstructionContinueButtonColor;
+(void)setFPInstructionContinueButtonColor:(NSString*)_instContinueButtonFP;

+(int)getFPInstructionContinueButtonColorAlpha;
+(void)setFPInstructionContinueButtonColorAlpha:(int)_instContinueButtonTransFP;

+(NSMutableDictionary *)getFPUiIdConfigDict;
+(void)setFPUiIdConfigDict:(NSMutableDictionary*)UiIdConfigDictionary;

// For FingerPrint Configuration
+(NSString *)getInstFPOutsideOutlineColor;
+(void)setInstFPOutsideOutlineColor:(NSString*)OutsideOutlineColor;

+(int)getInstFPOutsideOutlineAlpha;
+(void)setInstFPOutsideOutlineAlpha:(int)OutsideOutlineAlpha;

+(NSString *)getFPOutsideOutlineColor;
+(void)setFPOutsideOutlineColor:(NSString*)OutsideOutlineColor;

+(int)getFPOutsideOutlineAlpha;
+(void)setFPOutsideOutlineAlpha:(int)OutsideOutlineAlpha;

+(NSString *)getBackButtonColorFinger;
+(void)setBackButtonColorFinger:(NSString*)back_button_color_finger;

+(int)getBackButtonColorAlphaFinger;
+(void)setBackButtonColorAlphaFinger:(int)back_button_color_alpha_finger;

///////////////

//Face UI Config
+(NSString *)getHeaderTextFontStyleFace;
+(void)setHeaderTextFontStyleFace:(NSString*)_headerFontStyleFace;

+(NSString *)getHeaderTextColorFace;
+(void)setHeaderTextColorFace:(NSString*)_headerTextColorFace;

+(int)getHeaderTextColorAlphaFace;
+(void)setHeaderTextColorAlphaFace:(int)_headerTextColorTransFace;

+(NSString *)getHeaderTextSizeFace;
+(void)setHeaderTextSizeFace:(NSString*)_textHeaderSizeFace;

+(NSString *)getTextSizeFace;
+(void)setTextSizeFace:(NSString*)_textSizeFace;

+(NSString *)getIdCaptureBorderType;
+(void)setIdCaptureBorderType:(NSString*)_idCaptureBorderType;

+(NSString *)getTextFontStyleFace;
+(void)setTextFontStyleFace:(NSString*)text_font_style_face;

+(NSString *)getTextColorFace;
+(void)setTextColorFace:(NSString*)text_color_face;

+(int)getTextColorAlphaFace;
+(void)setTextColorAlphaFace:(int)text_color_alpha_face;

+(NSString *)getBackButtonColorFace;
+(void)setBackButtonColorFace:(NSString*)back_button_color_face;

+(int)getBackButtonColorAlphaFace;
+(void)setBackButtonColorAlphaFace:(int)back_button_color_alpha_face;

+(NSString *)getRetryButtonColorFace;
+(void)setRetryButtonColorFace:(NSString*)retry_button_color_face;

+(int)getRetryButtonColorAlphaFace;
+(void)setRetryButtonColorAlphaFace:(int)retry_button_color_alpha_face;

+(NSString *)getRetryButtonBorderColorFace;
+(void)setRetryButtonBorderColorFace:(NSString*)retry_button_border_color_face;

+(int)getRetryButtonBorderColorAlphaFace;
+(void)setRetryButtonBorderColorAlphaFace:(int)retry_button_border_color_alpha_face;

+(NSString *)getConfirmButtonColorFace;
+(void)setConfirmButtonColorFace:(NSString*)confirm_button_color_face;

+(int)getConfirmButtonColorAlphaFace;
+(void)setConfirmButtonColorAlphaFace:(int)confirm_button_color_alpha_face;

+(NSString *)getConfirmButtonStyleFace;
+(void)setConfirmButtonStyleFace:(NSString*)confirm_button_style_face;

+(int)getConfirmButtonStyleAlphaFace;
+(void)setConfirmButtonStyleAlphaFace:(int)confirm_button_style_alpha_face;

+(NSString *)getInstructionContinueButtonColorFace;
+(void)setInstructionContinueButtonColorFace:(NSString*)continue_button_color_face;

+(int)getInstructionContinueButtonColorAlphaFace;
+(void)setInstructionContinueButtonColorAlphaFace:(int)continue_button_color_alpha_face;

+(NSString *)getInstructionContinueButtonTextColorFace;
+(void)setInstructionContinueButtonTextColorFace:(NSString*)continue_button_text_color_face;

+(int)getInstructionContinueButtonTextColorAlphaFace;
+(void)setInstructionContinueButtonTextColorAlphaFace:(int)continue_button_color_text_alpha_face;

+(NSString *)getCaptureButtonColorFace;
+(void)setCaptureButtonColorFace:(NSString*)capture_button_color_face;

+(int)getCaptureButtonColorAlphaFace;
+(void)setCaptureButtonColorAlphaFace:(int)capture_button_color_alpha_face;

+(NSMutableDictionary *)getFaceUIConfigDict;
+(void)setFaceUIConfigDict:(NSMutableDictionary*)uiIdConfigDictionaryFace;

+(NSString *)getFaceContours;
+(void)setFaceContours:(NSString*)selfie_face_contours;

+(NSString *)getShowCustomUI;
+(void)setShowCustomUI:(NSString*)mShowCustomUI;

+(NSString *)getImageBundleID;
+(void)setImageBundleID:(NSString*)mImageBundleID;

+(NSString *)getFaceOutlineImageId;
+(void)setFaceOutlineImageId:(NSString*)mFaceOutlineImageId;

+(NSString *)getOutsideFaceOutlineImageId;
+(void)setOutsideFaceOutlineImageId:(NSString*)mOutsideFaceOutlineImageId;

+(NSString *)getFaceOutlineProgressImages;
+(void)setFaceOutlineProgressImages:(NSString*)mFaceOutlineProgressImages;

+(NSString *)getFaceOutlineProgressImagesDelay;
+(void)setFaceOutlineProgressImagesDelay:(NSString*)mFaceOutlineProgressImagesDelay;

+(NSString *)getFaceTurnArrowList;
+(void)setFaceTurnArrowList:(NSString*)mFaceTurnArrowList;

+(NSString *)getToggleCameraIcon;
+(void)setToggleCameraIcon:(NSString*)mToggleCameraIcon;

+(bool)getOfflineBackgroundCall;
+(void)setOfflineBackgroundCall:(bool)_isOfflineBackgroundCall;

+(NSString *)getAppCode;

+(NSString*)getServiceID;
+(void)setServiceID:(NSString*)_serviceId;

+(void)updateEmployee:(id)instance employeeDictionary:(NSMutableDictionary*)employeeDictionary additionalDictionary:(NSMutableDictionary*)additionalDictionary finalSubmit:(bool)finalSubmit;
+(void)updateEmployee:(id)instance faceImageType:(NSString*)faceImageType employeeDictionary:(NSMutableDictionary*)employeeDictionary additionalDictionary:(NSMutableDictionary*)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey;

+(NSURL*)getVoiceRecordingURL;
+(void)setVoiceRecordingURL:(NSURL*)_voicercordingURL;

+(NSURL*)getVideoRecordingURL;
+(void)setVideoRecordingURL:(NSURL*)_videoecordingURL;

+(void)presentIdCaptureViewController:(id)instance id_capture_type:(NSString*)id_capture_type instructionScreenDelegate:(id)instruction_Screen_Delegate;
+(void)presentFaceViewController:(id)instance instructionScreenDelegate:(id)instruction_Screen_Delegate;;

//Initialize Service ID Seprate API call
+(void)setCallExecutionParameter:(NSMutableDictionary *) additionalDictionary;
+(NSString *)getInitServiceID;
+(void)setInitServiceID:(NSString *)_serviceId;

+(NSString *)getManualReviewRequired;
+(void)setManualReviewRequired:(NSString *)_manual_review_required;

+(NSString *)getBypassAgeValidation;
+(void)setBypassAgeValidation:(NSString *)_bypas_age_validation;

+(NSString *)getBypassNameMatching;
+(void)setBypassNameMatching:(NSString *)_bypass_name_matching;

+(NSString *)getVerifyDataWithHost;
+(void)setVerifyDataWithHost:(NSString *)_verify_data_with_host;

+(NSString *)getDeduplicationRequired;
+(void)setDeduplicationRequired:(NSString *)_deduplication_required;

+(NSString*)getDeduplicationManualReviewRequired ;
+(void)setDeduplicationManualReviewRequired:(NSString*)_deduplication_manual_review_required;

+(NSString*)getIDBackImageRequired;
+(void)setIDBackImageRequired:(NSString*)_id_back_image_required;

+(NSString*)getPostDataAPIReq;
+(void)setPostDataAPIReq:(NSString*)_post_data_api_required;

+(NSString *)getNeedImmediateResponse;
+(void)setNeedImmediateResponse:(NSString *)_need_Immediate_response;

+(NSString*)getSendInputImagesPOST;
+(void)setSendInputImagesPOST:(NSString*)_send_input_images_post;

+(NSString*)getSendProcessedImagesPOST;
+(void)setSendProcessedImagesPOST:(NSString*)_send_processed_images_post;

+(NSString*)getStripSpecialCharacters;
+(void)setStripSpecialCharacters:(NSString*)_strip_special_characters;

+(int)getcfc_indexfinger_min_threshold;
+(void)setcfc_indexfinger_min_threshold:(int)_cfc_indexfinger_min_threshold;

+(int)getcfc_middlefinger_min_threshold;
+(void)setcfc_middlefinger_min_threshold:(int)_cfc_middlefinger_min_threshold;

+(int)getcfc_ringfinger_min_threshold;
+(void)setcfc_ringfinger_min_threshold:(int)_cfc_ringfinger_min_threshold;

+(int)getcfc_babyfinger_min_threshold;
+(void)setcfc_babyfinger_min_threshold:(int)_cfc_babyfinger_min_threshold;

+(int)getcfc_indexfinger_threshold;
+(void)setcfc_indexfinger_threshold:(int)_cfc_indexfinger_threshold;

+(int)getcfc_middlefinger_threshold;
+(void)setcfc_middlefinger_threshold:(int)_cfc_middlefinger_threshold;

+(int)getcfc_ringfinger_threshold;
+(void)setcfc_ringfinger_threshold:(int)_cfc_ringfinger_threshold;

+(int)getcfc_babyfinger_threshold;
+(void)setcfc_babyfinger_threshold:(int)_cfc_babyfinger_threshold;

+(float)getcfc_zoom_camera;
+(void)setcfc_zoom_camera:(float)_cfc_zoom_camera;

+(bool)getcfc_keep_index_finger;
+(void)setcfc_keep_index_finger:(bool)_cfc_keep_index_finger;

+(bool)getcfc_keep_middle_finger;
+(void)setcfc_keep_middle_finger:(bool)_cfc_keep_middle_finger;

+(bool)getcfc_keep_ring_finger;
+(void)setcfc_keep_ring_finger:(bool)_cfc_keep_ring_finger;

+(bool)getcfc_keep_baby_finger;
+(void)setcfc_keep_baby_finger:(bool)_cfc_keep_baby_finger;

+(bool)getcfc_process_indexfinger;
+(void)setcfc_process_indexfinger:(bool)_cfc_process_indexfinger;

+(bool)getcfc_process_middlefinger;
+(void)setcfc_process_middlefinger:(bool)_cfc_process_middlefinger;

+(bool)getcfc_process_ringfinger;
+(void)setcfc_process_ringfinger:(bool)_cfc_process_ringfinger;

+(bool)getcfc_process_babyfinger;
+(void)setcfc_process_babyfinger:(bool)_cfc_process_babyfinger;

+(void)setVideoRecordingTimeSec:(int) videoRecIneconds;

+(int)getVideoRecordingInSec;

+(NSString *)htmlEntityDecode:(NSString *)string;

+(void)setSampleRateHertz:(float)sampleRateHertz;

+(float)getSampleRateHertz;

+(void)setRecordedAudioDuration:(NSString*)recordedTimeDuration;

+(NSString *)getRecordedAudioDuration;

//For AppITSDK
+(bool)getIsSDKForAppIT;
+(void)setIsSDKForAppIT:(bool) is_SDK_For_Appit;

//IsBarcodeScan
+(bool)getBarcodeScan;
+(void)setBarcodeScan:(bool)is_Barcode_Scan;

+(NSMutableDictionary *)getBarcodeScanDataDictionary;
+(void)setBarcodeScanDataDictionary:(NSMutableDictionary*)barcodeScanData;

+(NSMutableDictionary *)getMRZScanDataDictionary;
+(void)setMRZScanDataDictionary:(NSMutableDictionary*)mrz_Scan_Data;

//Get Version Information
+(NSMutableDictionary *)getSDKInfo;

//Download XSLT
+(void)downloadXslt:(id)instance downloadCredentials:(NSMutableDictionary *)downloadCredentials;

+(bool)getFaceEnableShadow;
+(void)setFaceEnableShadow:(bool)EnableShadow;

+(bool)getCaptureLeftHand;
+(void)setCaptureLeftHand:(bool)CaptureLeftHand;

+(int)getEyes_Open_percentage_threshold;
+(void)setEyes_Open_percentage_threshold:(int)eyesOpen_facedetection_threshold;

+(int)getFace_Spoof_Detection_threshold;
+(void)setFace_Spoof_Detection_threshold:(int)faceSpoof_detection_threshold;

+(NSString *)getInstPreview_outline_color;
+(void)setInstPreview_outline_color:(NSString*)InstPreviewOutline_color;

+(int)getInstPreview_outline_color_alpha;
+(void)setInstPreview_outline_color_alpha:(int)InstPreviewOutline_color_alpha;



//Getter-Setter For All Model Path
+(void)setFaceModelName:(NSString*)faceModelPath;
+(NSString*)getFaceModelName;

+(void)setFaceMaskModelName:(NSString*)faceMaskModelPath;
+(NSString*)getFaceMaskModelName;

+(void)setIdDocDetectModelName:(NSString*)idDocDetectModelPath;
+(NSString*)getIdDocDetectModelName;

+(void)setIdRealnessModelName:(NSString*)idRealnessModelPath;
+(NSString*)getIdRealnessModelName;

+(void)setIdFocusModelName:(NSString*)idFocusModelPath;
+(NSString*)getIdFocusModelName;

+(void)setFingerModelName:(NSString*)fingerModelPath;
+(NSString*)getFingerModelName;



//Getter-Setter For All Unique Key
+(void)setUniqueKey:(NSString*)uniqueKeyId;
+(NSString *)getUniqueKey;

+(void)setPreviousUniqueKey_FaceModel:(NSString*)prev_UniqueKeyId;
+(NSString *)getPreviousUniqueKey_FaceModel;

+(void)setPreviousUniqueKey_FaceMaskModel:(NSString*)prev_UniqueKeyId;
+(NSString *)getPreviousUniqueKey_FaceMaskModel;

+(void)setPreviousUniqueKey_IdDocDetectModel:(NSString*)prev_UniqueKeyId;
+(NSString *)getPreviousUniqueKey_IdDocDetectModel;

+(void)setPreviousUniqueKey_IdRealnessModel:(NSString*)prev_UniqueKeyId;
+(NSString *)getPreviousUniqueKey_IdRealnessModel;

+(void)setPreviousUniqueKey_IdFocusModel:(NSString*)prev_UniqueKeyId;
+(NSString *)getPreviousUniqueKey_IdFocusModel;

+(void)setPreviousUniqueKey_FingerModel:(NSString*)prev_UniqueKeyId;
+(NSString *)getPreviousUniqueKey_FingerModel;



//Getter-Setter For All Public Key
+(void)setPublicKey:(NSString*)publicKeyId;
+(NSString *)getPublicKey;

+(void)setPreviousPublicKey_FaceModel:(NSString*)prev_publicKeyId;
+(NSString *)getPreviousPublicKey_FaceModel;

+(void)setPreviousPublicKey_FaceMaskModel:(NSString*)prev_publicKeyId;
+(NSString *)getPreviousPublicKey_FaceMaskModel;

+(void)setPreviousPublicKey_IdDocDetectModel:(NSString*)prev_publicKeyId;
+(NSString *)getPreviousPublicKey_IdDocDetectModel;

+(void)setPreviousPublicKey_IdRealnessModel:(NSString*)prev_publicKeyId;
+(NSString *)getPreviousPublicKey_IdRealnessModel;

+(void)setPreviousPublicKey_IdFocusModel:(NSString*)prev_publicKeyId;
+(NSString *)getPreviousPublicKey_IdFocusModel;

+(void)setPreviousPublicKey_FingerModel:(NSString*)prev_publicKeyId;
+(NSString *)getPreviousPublicKey_FingerModel;



+(int)getMrzScanMaxLimit;
+(void)setMrzScanMaxLimit : (int)mrz_Scan_Max_Limit;

+(int)getMrzAndBarcodeScanMaxLimit;
+(void)setMrzAndBarcodeScanMaxLimit : (int)mrz_and_barcode_Scan_Max_Limit;

+(int)getMrzAndBarcodeRetryTiming;
+(void)setMrzAndBarcodeRetryTiming : (int)mrz_and_retry_timing_in_sec;

+(int)getIdfocusScoreLimit;
+(void)setIdfocusScoreLimit: (int)id_focus_score_limit;

+(NSString *)stringFromTimeInterval;

//Face Retry Capture
+(bool)getIsManualCaptureEnabled;
+(void)setIsManualCaptureEnable:(bool)manualCapture;

+(int)getEnabledManualCaptureTime;
+(void)setEnabledManualCaptureTime : (int)manualCaptureTime;

+(int)getEnabledManualCaptureCount;
+(void)setEnabledManualCaptureCount : (int)manualCaptureCount;

+(int)getPassiveActive_FaceNotDetected_count;
+(void)setPassiveActive_FaceNotDetected_count : (int)faceNotDetectedCount;

+(NSString *)getFace_AutoCapture;
+(void)setFace_AutoCapture:(NSString *)auto_capture;
//

//face preview
+(NSString *)getFaceSuccessLabelColor;
+(void)setFaceSuccessLabelColor:(NSString*)success_text_label_color;

+(int)getFaceSuccessLabelColorAlpha;
+(void)setFaceSuccessLabelColorAlpha:(int)success_text_label_color_alpha;

+(NSString *)getid_image_resolution;
+(void)setid_image_resolution:(NSString *)_id_image_resolution;

+(NSArray *)get_CaptureDeviceFormat_Array:(AVCaptureDevice *)device;

+(NSArray *)getid_camera_supported_resolution_array;
+(void)setid_camera_supported_resolution_array:(NSArray *)_id_camera_supported_resolution_array;

//+(NSString *)getid_enable_image_resize;
//+(void)setid_enable_image_resize:(NSString *)_id_enable_image_resize;

+(float)getid_zoom_camera;
+(void)setid_zoom_camera:(float)_id_zoom_camera;

+(NSString *)getSuccessMessageTextFontStyleFace;
+(void)setSuccessMessageTextFontStyleFace:(NSString*)_success_message_font_style_face;

+(NSString *)getSuccessMessageTextSizeFace;
+(void)setSuccessMessageTextSizeFace:(NSString*)_success_message_text_size_face;

//PassiveFace Hint Label Color
+(NSString *)getPassiveFaceHintLabelColor;
+(void)setPassiveFaceHinLabelColor:(NSString*)passive_face_hint_text_label_color;

+(int)getPassiveFaceHintLabelColorAlpha;
+(void)setPassiveFaceHintLabelColorAlpha:(int)passive_face_hint_text_label_color_alpha;

//IDCaptureAutoCapture
+(NSString *)getIDFront_AutoCapture;
+(void)setIDFront_AutoCapture:(NSString *)auto_capture ;

+(NSString *)getIDBack_AutoCapture;
+(void)setIDBack_AutoCapture:(NSString *)auto_capture;

//Secondary IdCapture
+(NSString *)getSecondary_IDFront_AutoCapture;
+(void)setSecondary_IDFront_AutoCapture:(NSString *)auto_capture;

+(NSString *)getSecondary_IDBack_AutoCapture;
+(void)setSecondary_IDBack_AutoCapture:(NSString *)auto_capture;

//SignatureCapture Title Label
+(void)setSignatureCaptureHeaderLabel:(NSString*)_signatureCaptureHeaderLabel;
+(NSString *)getSignatureCaptureHeaderLabel;
//

//Signature Capture Header Color
+(void)setSignatureTitleLabelColor:(NSString*)signatureTitleLabelColor;
+(NSString *)getSignatureTitleLabelColor;

+(int)getSignatureTitleLabelColorAlpha;
+(void)setSignatureTitleLabelColorAlpha:(int)signature_title_label_color_alpha;

+(bool)getIsDigitalSignatureEnabled;
+(void)setIsDigitalSignatureEnabled:(bool)IsDigitalSignaturEnabled;

//

// Face Data Upload Changes
+(NSString *)getFaceDataUploadEnvironment;
+(void)setFaceDataUploadEnvironment:(NSString*)face_data_upload_env;

+(bool)getIsFace_ZipUploadData;
+(void)setIsFace_ZipUploadData:(bool)isFaceUploadZipData;

+(int)getMinMegaPixelCameraForFace;
+(void)setMinMegaPixelCameraForFace:(int)fd_min_megaPixel_Camera;

//ID Dummy Image Color
+(NSString *)getIDDummyImageColor;
+(void)setIDDummyImageColor:(NSString*)id_dummy_image_color;

+(int)getIDDummyImageColorAlpha;
+(void)setIDDummyImageColorAlpha:(int)id_dummy_image_color_alpha;

+(bool)getIdDoNotCapture;
+(void)setIdDoNotCapture : (bool)is_IdDoNotCapture;

+(bool)getIdUploadData;
+(void)setIdUploadData : (bool)is_idUploadData;

+(bool)getClearBackImage;
+(void)setClearBackImage:(bool)clearBackImage;

+(bool)getUploadImageDocument_Check;
+(void)setUploadImageDocument_Check : (bool)isUploadImageDocument_Check;

+(bool)getEnableRealId_Check;
+(void)setEnableRealId_Check : (bool)isEnableRealId_Check;

+(bool)getEnableRealId_Check_Metadata;
+(void)setEnableRealId_Check_Metadata : (bool)isEnableRealId_Check;

+(int)getRealIdCaptureThreshold;
+(void)setRealIdCaptureThreshold : (int)id_capture_threshold;

+(int)getRealIdFrontThreshold_Metadata;
+(void)setRealIdFrontThreshold_Metadata : (int)id_capture_threshold_Front;

+(int)getRealIdBackThreshold_Metadata;
+(void)setRealIdBackThreshold_Metadata : (int)id_capture_threshold_Back;

@end
