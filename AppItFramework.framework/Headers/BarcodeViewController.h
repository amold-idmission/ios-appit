
//#import <ZXingObjC/ZXingObjC.h>
//#import <GoogleMobileVision/GoogleMobileVision.h>
#import "CommonImporter.h"
//#import "ZXingObjC.h"
#import <ZXingObjC/ZXingObjC.h>


@protocol barcodeScanningResponse <NSObject>
@required
-(void)barcodeScanningResponse : (NSMutableDictionary*) result instance:(id)instance;
@end

@interface BarcodeViewController : UIViewController <ZXCaptureDelegate>

@property(nonatomic,assign)id delegate;
@property(nonatomic, strong) NSString *barcodeImageData;
@property(nonatomic, strong) NSString *defaultBarcodeImageStringData;
@property(nonatomic, strong) NSString *barcodeContentData;
@property(nonatomic, strong) NSString *barcodeFormatType;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property(nonatomic) NSString *barcodeScanStringData;
@property(nonatomic) bool portraitBarcodeScan;
@property(nonatomic) bool isFromEvolvApp;

+(NSString *)getBarcodeNode;

//+(NSString *)getBarcodeContent;
+(void)setBarcodeContent:(NSString*)barcodeContentData;

//+(NSString *)getBarcodeType;
+(void)setBarcodeType:(NSString*)barcodeTypeData;

//+(NSString *)getBarcodeImage;
+(void)setBarcodeImage:(NSString*)barcodeImageData;

@end
