platform :ios, ‘9.0’
inhibit_all_warnings!

def required_pods   
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
    pod 'Firebase/MLVision', '~> 6.28.0'
    pod 'Firebase/MLModelInterpreter', '~> 6.28.0'
    pod 'Firebase/MLVisionTextModel', '~> 6.28.0'
    pod 'Firebase/MLVisionFaceModel', '~> 6.28.0'
    
end

target 'appit-ios' do
    required_pods
end

target 'appit-iosTests' do
    required_pods
end

workspace 'appit-ios'
#link_with 'appit-ios', 'appit-iosTests'
