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
-(void)initializeSDKResponse : (NSMutableDictionary*) result;
-(void)captureImageResponse : (NSMutableDictionary*) result;
-(void)processImageResponse : (NSMutableDictionary*) result;
-(void)faceDetectionResponse : (NSMutableDictionary*) result;
-(void)cardDetectionResponse : (NSMutableDictionary*) result;
-(void)proofOfAddressDetectionResponse : (NSMutableDictionary*) result;
-(void)bankStatementDetectionResponse : (NSMutableDictionary*) result;
-(void)birthCertificateDetectionResponse : (NSMutableDictionary*) result;
-(void)genericDocumentResponse : (NSMutableDictionary*) result;
-(void)faceMatchingResponse : (NSMutableDictionary*) result;
-(void)processImageAndFaceMatchingResponse : (NSMutableDictionary*) result;
-(void)completeOperationResponse : (NSMutableDictionary*) result;
-(void)verifyCustomerResponse : (NSMutableDictionary*) result;
-(void)fourFingerprintDetectionResponse : (NSMutableDictionary*) result;
-(void)voiceRecordingResponse : (NSMutableDictionary*) result;
-(void)videoRecordingResponse : (NSMutableDictionary*) result;
-(void)fingerprintEnrolmentResponse : (NSMutableDictionary*) result;
-(void)fingerprintVerificationResponse : (NSMutableDictionary*) result;
-(void)gpsCoordinateResponse : (NSMutableDictionary*) result;
-(void)scanBarcodeResponse : (NSMutableDictionary*) result;
-(void)captureSignatureResponse : (NSMutableDictionary*) result;
-(void)verifyPOAResponse : (NSMutableDictionary *)result;
-(void)createEmployeeResponse : (NSMutableDictionary *)result;
-(void)verifyEmployeeResponse : (NSMutableDictionary *)result;
-(void)generateTokenResponse : (NSMutableDictionary *)result;
-(void)verifyTokenResponse : (NSMutableDictionary *)result;
-(void)snippetCaptureResponse : (NSMutableDictionary *)result;
-(void)updateCustomerResponse : (NSMutableDictionary *)result;
-(void)generateOTPResponse : (NSMutableDictionary *)result;
-(void)verifyOTPResponse : (NSMutableDictionary *)result;
-(void)executeGenericResponse : (NSMutableDictionary *)result;
-(void)idValidationAndVideoMatchingResponse : (NSMutableDictionary *)result;
-(void)updateGenericResponse : (NSMutableDictionary *)result;
-(void)updateEmployeeResponse : (NSMutableDictionary *)result;
-(void)genericApiCallResponse : (NSMutableDictionary *)result;
-(void)videoConferencingResponse : (NSMutableDictionary*) result;
-(void)downloadXsltResultResponse : (NSMutableDictionary*) result;
-(void)autoFillResponse : (NSMutableDictionary*) result;
-(void)onAutoFillFieldInformationAvailable : (NSMutableDictionary*) result;
@end

@interface AppItSDK : NSObject

extern NSString const *FRONT_IMAGE, *BACK_IMAGE, *FACE_IMAGE, *CARD_IMAGE, *PROCESSED_FACE_IMAGE, *INPUT_IMAGE_FRONT, *PROCESSED_IMAGE_FRONT, *OVAL_FACE;

extern NSArray const *IGNORE_RESPONSE_NODE;

// Calls From Client Side -Start

+(void)initializeAppItSDK:(id)instance url:(NSString*)url loginId:(NSString*)loginId password:(NSString*)password merchantID:(NSString*)merchantID productID:(NSString*)productID productName:(NSString*)productName Language:(NSString*)Language;
+(void)initializeAppItSDK:(id)instance url:(NSString*)url loginId:(NSString*)loginId password:(NSString*)password merchantID:(NSString*)merchantID productID:(NSString*)productID productName:(NSString*)productName Language:(NSString*)Language EnableDebug:(bool)EnableDebug;
+(void)initializeAppItSDK:(id)instance url:(NSString*)url loginId:(NSString*)loginId password:(NSString*)password merchantID:(NSString*)merchantID productID:(NSString*)productID productName:(NSString*)productName Language:(NSString*)Language EnableDebug:(bool)EnableDebug enableGPS:(bool)enableGPS;

+(void)initializeLabels:(NSMutableDictionary*)englishLabels spanishLabels:(NSMutableDictionary*)spanishLabels;

+(void)executeGenericRequest:(id)instance customProductDefination:(NSMutableDictionary*)customProductDefination additionalDictionary:(NSMutableDictionary*)additionalDictionary employeeDictionary:(NSMutableDictionary*)employeeDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey;

+(void)captureFrontImage:(id)instance;
+(void)captureFrontImage:(id)instance capturePortrait:(bool)capturePortrait;
+(void)captureFrontImage:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth;
+(void)captureFrontImage:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedIdOutlineColor:(NSString*)detectedIdOutlineColor detectedIdOutlineTransparency:(int)detectedIdOutlineTransparency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency;
+(void)captureFrontImage:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedIdOutlineColor:(NSString*)detectedIdOutlineColor detectedIdOutlineTransparency:(int)detectedIdOutlineTransparency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage*)titleImage;
+(void)captureFrontImage:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedIdOutlineColor:(NSString*)detectedIdOutlineColor detectedIdOutlineTransparency:(int)detectedIdOutlineTransparency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage*)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage*)instructionimage;
+(void)captureFrontImage:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedIdOutlineColor:(NSString*)detectedIdOutlineColor detectedIdOutlineTransparency:(int)detectedIdOutlineTransparency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage isCaptureEnable:(bool)isCaptureEnable;
+(void)captureFrontImage:(id)instance ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth capturePortrait:(bool)capturePortrait  isCaptureEnable:(bool)isCaptureEnable EnableCaptureButtonTime:(int)EnableCaptureButtonTime  showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage;
+(void)captureFrontImage:(id)instance ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth capturePortrait:(bool)capturePortrait  isCaptureEnable:(bool)isCaptureEnable EnableCaptureButtonTime:(int)EnableCaptureButtonTime  showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedIdOutlineColor:(NSString*)detectedIdOutlineColor detectedIdOutlineTransparency:(int)detectedIdOutlineTransparency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage;
+(void)captureFrontImage:(NSString*)id_capture_type instance:(id)instance titleImage:(UIImage *)titleImage additionalDictionary:(NSMutableDictionary*)additionalDictionary instructionimage:(UIImage*)instructionimage fieldName:(NSString*)fieldName uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;
+(void)captureFrontImage:(id)instance additionalDictionary:(NSMutableDictionary*)additionalDictionary uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;

+(void)captureSecondaryFrontImage:(id)instance additionalDictionary:(NSMutableDictionary*)additionalDictionary uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;

+(void)captureBackImage:(id)instance;
+(void)captureBackImage:(id)instance capturePortrait:(bool)capturePortrait;
+(void)captureBackImage:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth;
+(void)captureBackImage:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedIdOutlineColor:(NSString*)detectedIdOutlineColor detectedIdOutlineTransparency:(int)detectedIdOutlineTransparency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency;
+(void)captureBackImage:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedIdOutlineColor:(NSString*)detectedIdOutlineColor detectedIdOutlineTransparency:(int)detectedIdOutlineTransparency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage*)titleImage;
+(void)captureBackImage:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedIdOutlineColor:(NSString*)detectedIdOutlineColor detectedIdOutlineTransparency:(int)detectedIdOutlineTransparency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage*)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage*)instructionimage;
+(void)captureBackImage:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedIdOutlineColor:(NSString*)detectedIdOutlineColor detectedIdOutlineTransparency:(int)detectedIdOutlineTransparency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage isCaptureEnable:(bool)isCaptureEnable;
+(void)captureBackImage:(id)instance ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth capturePortrait:(bool)capturePortrait  isCaptureEnable:(bool)isCaptureEnable EnableCaptureButtonTime:(int)EnableCaptureButtonTime  showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage;
+(void)captureBackImage:(id)instance ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth capturePortrait:(bool)capturePortrait  isCaptureEnable:(bool)isCaptureEnable EnableCaptureButtonTime:(int)EnableCaptureButtonTime  showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedIdOutlineColor:(NSString*)detectedIdOutlineColor detectedIdOutlineTransparency:(int)detectedIdOutlineTransparency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage;
+(void)captureBackImage:(NSString*)id_capture_type instance:(id)instance titleImage:(UIImage *)titleImage additionalDictionary:(NSMutableDictionary*)additionalDictionary instructionimage:(UIImage*)instructionimage fieldName:(NSString*)fieldName uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;
+(void)captureBackImage:(id)instance additionalDictionary:(NSMutableDictionary*)additionalDictionary uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;

+(void)captureSecondaryBackImage:(id)instance additionalDictionary:(NSMutableDictionary*)additionalDictionary uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;

+(void)processImage:(id)instance countryCode:(NSString*)countryCode stateCode:(NSString*)stateCode idType:(NSString*)idType;
+(void)processImage:(id)instance countryCode:(NSString*)countryCode stateCode:(NSString*)stateCode idType:(NSString*)idType additionalDictionary:(NSMutableDictionary*)additionalDictionary;
+(void)processImage:(id)instance countryCode:(NSString*)countryCode stateCode:(NSString*)stateCode idType:(NSString*)idType additionalDictionary:(NSMutableDictionary*)additionalDictionary finalSubmit:(bool)finalSubmit;
+(void)processImage:(id)instance countryCode:(NSString*)countryCode stateCode:(NSString*)stateCode idType:(NSString*)idType additionalDictionary:(NSMutableDictionary*)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey;
+(void)processImage:(id)instance countryCode:(NSString*)countryCode stateCode:(NSString*)stateCode idType:(NSString*)idType additionalDictionary:(NSMutableDictionary*)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey employeeDictionary:(NSMutableDictionary*)employeeDictionary;

+(void)detectFace:(id)instance;
+(void)detectFace:(id)instance lowLightThreshold:(int)lowLightThreshold focusPercentage:(int)focusPercentage faceDetectionPercentage:(int)faceDetectionPercentage ImageSize:(int)ImageSize setFrontCameraDefault:(bool)setFrontCameraDefault;
+(void)detectFace:(id)instance lowLightThreshold:(int)lowLightThreshold focusPercentage:(int)focusPercentage faceDetectionPercentage:(int)faceDetectionPercentage ImageSize:(int)ImageSize setFrontCameraDefault:(bool)setFrontCameraDefault showPreviewScreen:(bool)showPreviewScreen;
+(void)detectFace:(id)instance lowLightThreshold:(int)lowLightThreshold focusPercentage:(int)focusPercentage faceDetectionPercentage:(int)faceDetectionPercentage ImageSize:(int)ImageSize setFrontCameraDefault:(bool)setFrontCameraDefault showPreviewScreen:(bool)showPreviewScreen faceOutlineColor:(NSString*)faceOutlineColor faceOutlineTransparency:(int)faceOutlineTransparency detectedFaceOutlineColor:(NSString*)detectedFaceOutlineColor detectedFaceOutlineTransparency:(int)detectedFaceOutlineTransparency outsideFaceOutlineColor:(NSString*)outsideFaceOutlineColor outsideFaceOutlineTransparency:(int)outsideFaceOutlineTransparency;
+(void)detectFace:(id)instance lowLightThreshold:(int)lowLightThreshold focusPercentage:(int)focusPercentage faceDetectionPercentage:(int)faceDetectionPercentage ImageSize:(int)ImageSize setFrontCameraDefault:(bool)setFrontCameraDefault showPreviewScreen:(bool)showPreviewScreen faceOutlineColor:(NSString*)faceOutlineColor faceOutlineTransparency:(int)faceOutlineTransparency detectedFaceOutlineColor:(NSString*)detectedFaceOutlineColor detectedFaceOutlineTransparency:(int)detectedFaceOutlineTransparency outsideFaceOutlineColor:(NSString*)outsideFaceOutlineColor outsideFaceOutlineTransparency:(int)outsideFaceOutlineTransparency detectedOutsideFaceOutlineColor :(NSString*)detectedOutsideFaceOutlineColor detectedOutsideFaceOutlineColorTrans:(int)detectedOutsideFaceOutlineColorTrans titleImageFace:(UIImage*)titleImageFace;
+(void)detectFace:(id)instance lowLightThreshold:(int)lowLightThreshold focusPercentage:(int)focusPercentage faceDetectionPercentage:(int)faceDetectionPercentage ImageSize:(int)ImageSize setFrontCameraDefault:(bool)setFrontCameraDefault showPreviewScreen:(bool)showPreviewScreen faceOutlineColor:(NSString*)faceOutlineColor faceOutlineTransparency:(int)faceOutlineTransparency detectedFaceOutlineColor:(NSString*)detectedFaceOutlineColor detectedFaceOutlineTransparency:(int)detectedFaceOutlineTransparency outsideFaceOutlineColor:(NSString*)outsideFaceOutlineColor outsideFaceOutlineTransparency:(int)outsideFaceOutlineTransparency detectedOutsideFaceOutlineColor :(NSString*)detectedOutsideFaceOutlineColor detectedOutsideFaceOutlineColorTrans:(int)detectedOutsideFaceOutlineColorTrans titleImageFace:(UIImage*)titleImageFace showInstruction:(bool)showInstruction instructionimage:(UIImage*)instructionimage;
+(void)detectFace:(id)instance lowLightThreshold:(int)lowLightThreshold focusPercentage:(int)focusPercentage faceDetectionPercentage:(int)faceDetectionPercentage ImageSize:(int)ImageSize setFrontCameraDefault:(bool)setFrontCameraDefault showPreviewScreen:(bool)showPreviewScreen faceOutlineColor:(NSString*)faceOutlineColor faceOutlineTransparency:(int)faceOutlineTransparency detectedFaceOutlineColor:(NSString*)detectedFaceOutlineColor detectedFaceOutlineTransparency:(int)detectedFaceOutlineTransparency outsideFaceOutlineColor:(NSString*)outsideFaceOutlineColor outsideFaceOutlineTransparency:(int)outsideFaceOutlineTransparency detectedOutsideFaceOutlineColor :(NSString*)detectedOutsideFaceOutlineColor detectedOutsideFaceOutlineColorTrans:(int)detectedOutsideFaceOutlineColorTrans titleImageFace:(UIImage*)titleImageFace showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage toggleCamera:(bool)toggleCamera;
+(void)detectFace:(id)instance setFrontCameraDefault:(bool)setFrontCameraDefault toggleCamera:(bool)toggleCamera showPreviewScreen:(bool)showPreviewScreen showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage;
+(void)detectFace:(id)instance setFrontCameraDefault:(bool)setFrontCameraDefault toggleCamera:(bool)toggleCamera showPreviewScreen:(bool)showPreviewScreen showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage faceOutlineColor:(NSString*)faceOutlineColor faceOutlineTransparency:(int)faceOutlineTransparency detectedFaceOutlineColor:(NSString*)detectedFaceOutlineColor detectedFaceOutlineTransparency:(int)detectedFaceOutlineTransparency outsideFaceOutlineColor:(NSString*)outsideFaceOutlineColor outsideFaceOutlineTransparency:(int)outsideFaceOutlineTransparency detectedOutsideFaceOutlineColor :(NSString*)detectedOutsideFaceOutlineColor detectedOutsideFaceOutlineColorTrans:(int)detectedOutsideFaceOutlineColorTrans titleImageFace:(UIImage*)titleImageFace;
+(void)detectFace:(id)instance titleImageFace:(UIImage*)titleImageFace instructionimage:(UIImage *)instructionimage uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;
+(void)detectFace:(id)instance faceCaptureConfig:(NSMutableDictionary*)faceCaptureConfig;
+(void)detectFace:(id)instance faceCaptureConfig:(NSMutableDictionary*)faceCaptureConfig uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;

+(void)matchFaceImage:(id)instance faceImageType:(NSString*)faceImageType idImageType:(NSString*)idImageType;
+(void)matchFaceImage:(id)instance faceImageType:(NSString*)faceImageType idImageType:(NSString*)idImageType additionalDictionary:(NSMutableDictionary*)additionalDictionary;
+(void)matchFaceImage:(id)instance faceImageType:(NSString*)faceImageType idImageType:(NSString*)idImageType additionalDictionary:(NSMutableDictionary*)additionalDictionary finalSubmit:(bool)finalSubmit;
+(void)matchFaceImage:(id)instance faceImageType:(NSString*)faceImageType idImageType:(NSString*)idImageType additionalDictionary:(NSMutableDictionary*)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey;
+(void)matchFaceImage:(id)instance faceImageType:(NSString*)faceImageType idImageType:(NSString*)idImageType additionalDictionary:(NSMutableDictionary*)additionalDictionary clearFormKey:(bool)clearFormKey employeeDictionary:(NSMutableDictionary*)employeeDictionary;

+(void)verifyCustomer:(id)instance biometricType:(NSString*)biometricType;
+(void)verifyCustomer:(id)instance biometricType:(NSString*)biometricType additionalDictionary:(NSMutableDictionary*)additionalDictionary;
+(void)verifyCustomer:(id)instance biometricType:(NSString*)biometricType additionalDictionary:(NSMutableDictionary*)additionalDictionary clearFormKey:(bool)clearFormKey;

+(void)updateCustomer:(id)instance additionalDictionary:(NSMutableDictionary*)additionalDictionary;
+(void)updateCustomer:(id)instance faceImageType:(NSString*)faceImageType additionalDictionary:(NSMutableDictionary*)additionalDictionary;

+(void)captureAddressProof:(id)instance;
+(void)captureAddressProof:(id)instance capturePortrait:(bool)capturePortrait;
+(void)captureAddressProof:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth;
+(void)captureAddressProof:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary;
+(void)captureAddressProof:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency;
+(void)captureAddressProof:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage*)titleImage;
+(void)captureAddressProof:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage*)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage*)instructionimage;
+(void)captureAddressProof:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage isCaptureEnabled:(bool)isCaptureEnabled;
+(void)captureAddressProof:(NSString*)id_capture_type instance:(id)instance titleImage:(UIImage *)titleImage additionalDictionary:(NSMutableDictionary*)additionalDictionary instructionimage:(UIImage*)instructionimage fieldName:(NSString*)fieldName uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary ;

+(void)captureBankStatement:(id)instance;
+(void)captureBankStatement:(id)instance capturePortrait:(bool)capturePortrait;
+(void)captureBankStatement:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth;
+(void)captureBankStatement:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary;
+(void)captureBankStatement:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency;
+(void)captureBankStatement:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage*)titleImage;
+(void)captureBankStatement:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage*)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage*)instructionimage;
+(void)captureBankStatement:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary *)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage isCaptureEnable:(bool)isCaptureEnable;
+(void)captureBankStatement:(NSString*)id_capture_type instance:(id)instance titleImage:(UIImage *)titleImage additionalDictionary:(NSMutableDictionary*)additionalDictionary instructionimage:(UIImage*)instructionimage fieldName:(NSString*)fieldName uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;

+(void)captureBirthCertificate:(id)instance;
+(void)captureBirthCertificate:(id)instance capturePortrait:(bool)capturePortrait;
+(void)captureBirthCertificate:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth;
+(void)captureBirthCertificate:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary;
+(void)captureBirthCertificate:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency;
+(void)captureBirthCertificate:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage*)titleImage;
+(void)captureBirthCertificate:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary*)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage*)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage*)instructionimage;
+(void)captureBirthCertificate:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary *)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage isCaptureEnable:(bool)isCaptureEnable;
+(void)captureBirthCertificate:(NSString*)id_capture_type instance:(id)instance titleImage:(UIImage *)titleImage additionalDictionary:(NSMutableDictionary*)additionalDictionary instructionimage:(UIImage*)instructionimage fieldName:(NSString*)fieldName uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;

+(void)captureGenericDocument:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary *)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage genericFieldName:(NSString*)genericFieldName;
+(void)captureGenericDocument:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth additionalDictionary:(NSMutableDictionary *)additionalDictionary idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedPOAOutlineColor:(NSString*)detectedPOAOutlineColor detectedPOAColorOutlineTransperency:(int)detectedPOAColorOutlineTransperency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage genericFieldName:(NSString*)genericFieldName isCaptureEnable:(bool)isCaptureEnable;
+(void)captureGenericDocument:(NSString*)id_capture_type instance:(id)instance titleImage:(UIImage *)titleImage additionalDictionary:(NSMutableDictionary*)additionalDictionary instructionimage:(UIImage*)instructionimage fieldName:(NSString*)fieldName uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;

+(void)captureGenericDocument:(id)instance additionalDictionary:(NSMutableDictionary*)additionalDictionary uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary fieldName:(NSString*)fieldName;

//+(void)captureFourFingerprint:(id)instance focusThreshold:(int)focusThreshold;
+(void)captureFourFingerprint:(id)instance focusThreshold:(int)focusThreshold uiConfigDict:(NSMutableDictionary*)uiConfigDict;
+(void)captureFourFingerprint:(id)instance cameraFingerCaptureConfig:(NSMutableDictionary*)cameraFingerCaptureConfig;
//Voice Recording
+(void)startVoiceRecording:(id)instance recordingTime:(int)recordingTime additionalDictionary:(NSMutableDictionary*)additionalDictionary;

//Video Recording
+(void)startVideoRecording:(UIViewController*)instance recordingTime:(int)recordingTime additionalDictionary:(NSMutableDictionary*)additionalDictionary textDatatoScrolled:(NSString*)textDatatoScrolled;

//FingerPrint Enrollment
+(void)enrollFingerprint:(id)instance additionalDictionary:(NSMutableDictionary*)additionalDictionary clearFormKey:(bool)clearFormKey;
//verifyFingerprint
+(void)verifyFingerprint:(id)instance additionalDictionary:(NSMutableDictionary*)additionalDictionary clearFormKey:(bool)clearFormKey;
//clear all fingerprint
+(void)clearAllFingerprints:(id)instance;
//clear selected figerprint
+(void)clearSelectedFingerPrint:(id)instance selectedFinger:(NSString *)selectedFinger;

+(void)processImageAndMatchFace:(id)instance countryCode:(NSString*)countryCode stateCode:(NSString*)stateCode idType:(NSString*)idType faceImageType:(NSString*)faceImageType;
+(void)processImageAndMatchFace:(id)instance countryCode:(NSString*)countryCode stateCode:(NSString*)stateCode idType:(NSString*)idType faceImageType:(NSString*)faceImageType  additionalDictionary:(NSMutableDictionary*)additionalDictionary;
+(void)processImageAndMatchFace:(id)instance countryCode:(NSString*)countryCode stateCode:(NSString*)stateCode idType:(NSString*)idType faceImageType:(NSString*)faceImageType  additionalDictionary:(NSMutableDictionary*)additionalDictionary finalSubmit:(bool)finalSubmit;
+(void)processImageAndMatchFace:(id)instance countryCode:(NSString*)countryCode stateCode:(NSString*)stateCode idType:(NSString*)idType faceImageType:(NSString*)faceImageType  additionalDictionary:(NSMutableDictionary*)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey;
+(void)processImageAndMatchFace:(id)instance countryCode:(NSString*)countryCode stateCode:(NSString*)stateCode idType:(NSString*)idType faceImageType:(NSString*)faceImageType  additionalDictionary:(NSMutableDictionary*)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey employeeDictionary:(NSMutableDictionary*)employeeDictionary;

//IDValidationWithVideoMatch
+(void)idValidationAndMatchVideo:(id)instance countryCode:(NSString*)countryCode stateCode:(NSString*)stateCode idType:(NSString*)idType additionalDictionary:(NSMutableDictionary*)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey employeeDictionary:(NSMutableDictionary*)employeeDictionary;

+(void)detectCard:(id)instance;
+(void)detectCard:(id)instance additionalDictionary:(NSMutableDictionary*)additionalDictionary;

+(void)setImages:(NSMutableDictionary*)images;

+(void)getGPSCoordinate:(id)instance;

+(void)completeOperation:(id)instance;

//Customize User Interface Call
//+(void)customizeUserInterface:(id)instance faceTitleOnTop:(bool)faceTitleOnTop faceHintMessageOnTop:(bool)faceHintMessageOnTop faceHintIconOnTop:(bool)faceHintIconOnTop faceTitleImageOnTop:(bool)faceTitleImageOnTop;
+(void)customizeUserInterface:(id)instance faceTitleOnTop:(bool)faceTitleOnTop hideFaceTitle:(bool)hideFaceTitle faceHintMessageOnTop:(bool)faceHintMessageOnTop hideFacehintMsg:(bool)hideFacehintMsg faceHintIconOnTop:(bool)faceHintIconOnTop hideFacehintIcon:(bool)hideFacehintIcon faceTitleImageOnTop:(bool)faceTitleImageOnTop hideFacetitleImage:(bool)hideFacetitleImage idCaptureTitleAlignment:(NSString*)idCaptureTitleAlignment hideIDCaptureTitle:(bool)hideIDCaptureTitle idCaptureHintMsgAlignment:(NSString*)idCaptureHintMsgAlignment hideIDCapturehintMsg:(bool)hideIDCapturehintMsg idCaptureTitleImgAlignment:(NSString*)idCaptureTitleImgAlignment hideIDCapturetitleImg:(bool)hideIDCapturetitleImg;
//+(void)customizeUserInterface:(NSString*)uiconfigurationString;
+(void)customizeUserInterface:(NSMutableDictionary*)uiconfiguration;

+(void)changeLanguageBundle:(NSString*)language;
+(NSString*)getLanguageBundle;
+(void)scanBarcode:(id)instance;
+(void)scanBarcode:(id)instance showPortraitBarcodeScreen:(bool)showPortraitBarcodeScreen barcodeScanText:(NSString*)barcodeScanText;
+(void)scanBarcode:(id)instance uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;
+(void)captureSignature:(id)instance;
+(void)captureSignature:(id)instance uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;
+(void)verifyAddress:(id)instance addressJSONDictionary:(NSMutableDictionary*)addressJSONDictionary additionalDictionary:(NSMutableDictionary*)additionalDictionary doExtract:(bool)doExtract doVerify:(bool)doVerify finalSubmit:(bool)finalSubmit;
+(void)createEmployee:(id)instance employeeDictionary:(NSMutableDictionary*)employeeDictionary additionalDictionary:(NSMutableDictionary*)additionalDictionary finalSubmit:(bool)finalSubmit;
+(void)verifyEmployee:(id)instance employeeCode:(NSString*)employeeCode additionalDictionary:(NSMutableDictionary*)additionalDictionary finalSubmit:(bool)finalSubmit clearFormKey:(bool)clearFormKey;
+(void)generateToken:(id)instance;
+(void)verifyToken:(id)instance;

+(void)snippetCapture:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedIdOutlineColor:(NSString*)detectedIdOutlineColor detectedIdOutlineTransparency:(int)detectedIdOutlineTransparency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage snippetFieldsDictionary:(NSMutableDictionary*)snippetFieldsDictionary;

+(void)snippetCapture:(id)instance capturePortrait:(bool)capturePortrait minimumLightThreshold:(int)minimumLightThreshold minimumFocusThreshold:(int)minimumFocusThreshold GlarePercentage:(int)GlarePercentage EnableCaptureButtonTime:(int)EnableCaptureButtonTime ImageSize:(int)ImageSize ImageHeight:(int)ImageHeight ImageWidth:(int)ImageWidth idOutlineColor:(NSString*)idOutlineColor idOutlineColorTransparency:(int)idOutlineColorTransparency detectedIdOutlineColor:(NSString*)detectedIdOutlineColor detectedIdOutlineTransparency:(int)detectedIdOutlineTransparency idOutsideOutlineColor:(NSString*)idOutsideOutlineColor idOutsideOutlineColorTransparency:(int)idOutsideOutlineColorTransparency detectedColorOutsideOutline:(NSString*)detectedColorOutsideOutline detectedColorOutsideOutlineTransparency:(int)detectedColorOutsideOutlineTransparency titleImage:(UIImage *)titleImage showInstruction:(bool)showInstruction instructionimage:(UIImage *)instructionimage snippetFieldsDictionary:(NSMutableDictionary*)snippetFieldsDictionary isCaptureEnable:(bool)isCaptureEnable;

+(void)snippetCapture:(NSString*)id_capture_type instance:(id)instance titleImage:(UIImage *)titleImage additionalDictionary:(NSMutableDictionary*)additionalDictionary instructionimage:(UIImage*)instructionimage fieldName:(NSString*)fieldName uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;

+(void)snippetCapture:(id)instance additionalDictionary:(NSMutableDictionary*)additionalDictionary uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary snippetFieldsDictionary:(NSMutableDictionary*)snippetFieldsDictionary isIdCaptureCall:(bool)isIdCaptureCall;

+(void)generateOTP:(id)instance additionalDictionary:(NSMutableDictionary*)additionalDictionary emailId:(NSString*)emailId mobileNumber:(NSString*)mobileNumber notificationType:(NSString*)notificationType;
+(void)verifyOTP:(id)instance additionalDictionary:(NSMutableDictionary*)additionalDictionary receivedOTP:(NSString*)receivedOTP;

//GenericApiCall
+(void)genericApiCall:(id)instance genericDataDictionary:(NSMutableDictionary *)genericDataDictionary;

+(void)startVideoConferencing:(id)instance videoConferenceData:(NSMutableDictionary*)videoConferenceData;

//Slant capture
+(void)captureSlantImage:(id)instance additionalDictionary:(NSMutableDictionary*)additionalDictionary uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;

// Calls From Client Side -End

// Internal calls -Start
+(void)sendRequestAlreadyRunningResponse:(id)instance requetType:(int)requetType;
// Internal calls -End

//**********Parameter to Initialize SDK -Start
+(NSString *)getURL;
+(void)setURL:(NSString*)url;

+(NSString *)getChunkNumber;
+(void)setChunkNumber : (NSString*)chunkNumber;

+(NSString *)getTotalChunkNumber;
+(void)setTotalChunkNumber : (NSString*)totalChunkNumber;

+(NSString *)getDownloadedChunkCount;
+(void)setDownloadedChunkCount : (NSString*)downloadedChunkCount;

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

+(int)getMinimumFocusThreshold;
+(void)setMinimumFocusThreshold:(int)minImageFocusScore;

+(bool)getCapturePortrait;
+(void)setCapturePortrait:(bool)CapturePortrait;

+(bool)getCaptureEnable;
+(void)setCaptureEnable : (bool)CaptureEnable;

+(NSString *)getFieldName;
+(void)setFieldName : (NSString*)fieldName;

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

+(NSURL*)getVideoRecordingURL;
+(void)setVideoRecordingURL:(NSURL*)_videoecordingURL;

+(void)presentIdCaptureViewController:(id)instance id_capture_type:(NSString*)id_capture_type;

+(void)presentFaceViewController:(id)instance isPassiveFD:(BOOL)isPassiveFD;

+(void)presentFPViewController:(id)instance finger_type:(NSString*)finger_type;

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

+(NSString *)getDeduplicationRequired;
+(void)setDeduplicationRequired:(NSString *)_deduplication_required;

+(NSString *)getNeedImmediateResponse;
+(void)setNeedImmediateResponse:(NSString *)_need_Immediate_response;

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

+(bool)cfc_keep_middle_finger;
+(void)setcfc_keep_middle_finger:(bool)_cfc_keep_middle_finger;

+(bool)getcfc_keep_ring_finger;
+(void)setcfc_keep_ring_finger:(bool)_cfc_keep_ring_finger;

+(bool)getcfc_keep_baby_finger;
+(void)setcfc_keep_baby_finger:(bool)_cfc_keep_baby_finger;

+(void)extraAdditionalData:(NSMutableDictionary *)dataDictionary;

+(void)startVoiceRecording:(id)instance voiceRecordingConfig:(NSMutableDictionary *)voiceRecordingConfig;

+(void)stopVoiceRecording;

+(NSString *)getRecordedFilePath;

+(void)setVideoRecordingTimeSec:(int) videoRecIneconds;

+(int)getVideoRecordingInSec;

+(NSString *)htmlEntityDecode:(NSString *)string;

+(void)setSampleRateHertz:(float)sampleRateHertz;

+(float)getSampleRateHertz;

+(void)setRecordedAudioDuration:(NSString*)recordedTimeDuration;

+(NSString *)getRecordedAudioDuration;

//For AppITSDK
+(bool)getIsSDKForAppIT;

//IsBarcodeScan
+(bool)getBarcodeScan;
+(void)setBarcodeScan:(bool)is_Barcode_Scan;

+(NSMutableDictionary *)getBarcodeScanDataDictionary;
+(void)setBarcodeScanDataDictionary:(NSMutableDictionary*)barcodeScanData;

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

+(void)setFaceModelName:(NSString*)faceModelPath;
+(NSString*)getFaceModelName;

+(void)setUniqueKey:(NSString*)uniqueKeyId;
+(NSString *)getUniqueKey;

+(void)setPublicKey:(NSString*)publicKeyId;
+(NSString *)getPublicKey;

+(bool)getIsFace_ZipUploadData;
+(void)setIsFace_ZipUploadData:(bool)isFaceUploadZipData;

+(int)getMrzScanMaxLimit;
+(void)setMrzScanMaxLimit : (int)mrz_Scan_Max_Limit;

+(int)getMrzAndBarcodeScanMaxLimit;
+(void)setMrzAndBarcodeScanMaxLimit : (int)mrz_and_barcode_Scan_Max_Limit;

//
+(void) autoFill:(id)instance idCaptureConfig:(NSMutableDictionary *)idCaptureConfig additionalDictionary:(NSMutableDictionary *)additionalDictionary;

+(void)getAutoFillFieldInformation:(id)instance uiConfigDictionary:(NSMutableDictionary*)uiConfigDictionary;


@end
