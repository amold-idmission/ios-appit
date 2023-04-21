//
//  CommonImporter.h
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 21/10/16.
//  Copyright © 2016 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppItSDK.h"
#import "NSStringUtils.h"
#import "NSLogUtils.h"
#import "UIColor+fromHex.h"
#import "RequestQueue.h"
#import "LanguageUtils.h"
#import "ResultData.h"
#import "RequestResponseVController.h"
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

#import "OpenCvViewController.h"              /* Need To Delete For Face+ID Flavour */
#import "CardViewController.h"                /* Need To Delete For Face+ID Flavour */
#import "CardDetectionViewController.h"       /* Need To Delete For Face+ID Flavour */
#import "FingerDetectionViewController.h"     /* Need To Delete For Face+ID Flavour */
#import "VideoConferencingViewController.h"   /* Need To Delete For Face+ID Flavour */

#import "MatchFaceViewController.h"
#import "IDCaptureModelController.h"
#import "SnippetCaptureController.h"
#import "DocumentUploadController.h"
#import "FillFastModelController.h"
#import "FingerprintEnrolmentTask.h"
#import "FingerPrintVerificationTask.h"
#import "MlKitBarcodeScanViewController.h"
#import "BarcodeViewController.h"
#import "CaptureSignatureController.h"
#import "GPSManager.h"
#import "VoiceRecordingVC.h"
#import "VideoRecordingController.h"

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
