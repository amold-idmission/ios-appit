
#import "CommonImporter.h"
#import "UIKit/UIKit.h"
#import "AVFoundation/AVFoundation.h"

@protocol barcodeScanningResponse <NSObject>
@required
-(void)barcodeScanningResponse : (NSMutableDictionary*) result instance:(id)instance;
@end

@interface BarcodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic, strong) AVCaptureSession *captureSession;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *videopreviewLayer;
@property (nonatomic, copy) NSString *sessionPreset;
@property (nonatomic, assign) int camera;
@property (nonatomic, strong, readonly) CALayer *layer;
@property (nonatomic, assign) CGRect scanRect;
@property (nonatomic, assign) CGImageRef lastScannedImage;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, assign) CGAffineTransform transform;
@property (strong, nonatomic) AVCaptureStillImageOutput *avCaptureStillImageOutput;
@property (nonatomic, readonly) AVCaptureMetadataOutput *videoOutput;
@property(nonatomic) int maxImageSize;
@property(nonatomic)IBOutlet UIColor *config_Color;

-(BOOL)startReading;
-(void)stopReading;

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

+(void)setBarcodeContent:(NSString*)barcodeContentData;
+(void)setBarcodeType:(NSString*)barcodeTypeData;
+(void)setBarcodeImage:(NSString*)barcodeImageData;

@end
