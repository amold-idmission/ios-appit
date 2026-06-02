
#import <UIKit/UIKit.h>


@protocol onDraggedFinishedProtocol <NSObject>
@required
-(void)onDraggedFinishedProtocol:(bool) isFromTapped isFomExpandCorner:(bool)isFomExpandCorner viewTagValue:(int)viewTagValue;
@end

@interface MMSCropImageView : UIImageView <UIGestureRecognizerDelegate>

//-(UIImage*)crop;
@property (nonatomic) CGSize defaultSize;
@property (nonatomic) CGPoint defaultOrigin;
@property (nonatomic) CGSize mainScreendefaultSize;
@property (nonatomic) UIImage *passedImage;
@property(nonatomic,assign)id delegate;
-(CGRect)crop;
-(void) settingCropViewFrame:(CGRect *)cgRectframe;
-(void)rectTopAndBtmCornerButtonClicked:(UIPanGestureRecognizer*)gesture  constantPoint:(CGPoint)constantPoint viewTagValue:(int)viewTagValue;
-(void)setHiddenCropView;
-(void)showCropView;

@end
