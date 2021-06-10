platform :ios, ‘11.0’
inhibit_all_warnings!

def required_pods
use_frameworks!   
#     pod 'ZXingObjC', '~> 3.2.2'
#    pod 'ZXingObjC'
    pod 'OpenCV', '3.0.0'
    #pod 'GoogleMobileVision/TextDetector'
    #pod 'GoogleMobileVision/FaceDetector'
#    pod 'Firebase/Core', '~> 6.10.0'
#    pod 'Firebase/MLVision', '~> 6.10.0'
#    pod 'Firebase/MLVisionFaceModel', '~> 6.10.0'
#    pod 'Firebase/MLVisionTextModel', '~> 6.10.0'

    pod 'WebRTC'
    pod 'CocoaLumberjack'
    pod 'SocketRocket'
    pod 'ZXingObjC', '~> 3.2.2'
    pod 'SSZipArchive'
    pod 'TensorFlowLiteObjC'
    pod 'GoogleMLKit/TextRecognition'
    pod 'GoogleMLKit/FaceDetection'
    
end

target 'appit-ios' do
    required_pods
end

target 'appit-iosTests' do
    required_pods
end

workspace 'appit-ios'
#link_with 'appit-ios', 'appit-iosTests'
