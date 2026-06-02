//
//  CommonImporter.h
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 21/10/16.
//  Copyright © 2016 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AesGcmNoPadding/AesGcmNoPadding-Swift.h>
#import "AppItSDK.h"
#import "NSStringUtils.h"
#import "NSLogUtils.h"
#import "UIColor+fromHex.h"
#import "RequestQueue.h"
#import "LanguageUtils.h"
#import "ResultData.h"
#import "BundleLocalization.h"
#import "VerifyPOAClass.h"
#import "StringLabels.h"
#import "UIConfigurationManager.h"
#import "DownloadTemplateData.h"
#import "GetTemplateInfoTask.h"
#import "TBXML.h"
#import "TBXMLParser.h"
#import "NSData+GZIP.h"

#import "ProcessImageViewController.h"
#import "ProcessAndMatchViewController.h"
#import "CompleteOperationViewController.h"

#import "VerifyCredentialsController.h"
#import "InstructionViewController.h"
#import "PassiveFaceDetectionViewController.h"

#import "MatchFaceViewController.h"
#import "FingerprintEnrolmentTask.h"
#import "FingerPrintVerificationTask.h"

#if FULL_SDK || ID_FACE_CARDIO_SDK
#import "CardViewController.h"
#import "CardDetectionViewController.h"
#endif

#if FULL_SDK || ID_FACE_WITHOUT_CARDIO_SDK
#import "FingerDetectionViewController.h"
#import "VideoConferencingViewController.h"
#import "VoiceRecordingVC.h"
#endif

#if FULL_SDK || ID_FACE_WITHOUT_CARDIO_SDK || ID_FACE_CARDIO_SDK
#import "OpenCvViewController.h"
#import "VideoIDViewController.h"
#endif

#if FULL_SDK || ID_FACE_WITHOUT_CARDIO_SDK || ID_FACE_CARDIO_SDK || ID_FACE_SDK || ID_FACE_WITHOUT_MODELS_SDK
#import "IDCaptureModelController.h"
#import "CaptureSignatureController.h"
#import "DocumentUploadController.h"
#import "VideoRecordingController.h"
#import "BarcodeViewController.h"
#import "FillFastModelController.h"
#import "MlKitBarcodeScanViewController.h"
#import "SnippetCaptureController.h"
#endif

#import "GPSManager.h"
#import "CreateEmployeeControllerViewController.h"
#import "VerifyEmployeeController.h"
#import "UpdateEmployeeViewController.h"

#import "VerifyCustomerViewController.h"
#import "UpdateCustomerViewController.h"

#import "CreateTokenControllerViewController.h"
#import "VerifyTokenController.h"

#import "GenerateOTPController.h"
#import "VerifyOTPController.h"

#import "ImagePreviewViewController.h"
#import "IdValidationAndVideoMatchingController.h"
#import "GenericServiceCallViewController.h"
#import "ExecuteGenericRequestViewController.h"

@interface CommonImporter : NSObject

@end
