platform :ios, ‘11.0’
inhibit_all_warnings!

def required_pods
use_frameworks!   
    pod 'WebRTC'
    pod 'CocoaLumberjack'
    pod 'SocketRocket'
    pod 'IdmEncryption'

    pod 'TensorFlowLiteObjC'
    pod 'GoogleMLKit/TextRecognition'
    pod 'GoogleMLKit/FaceDetection'

    pod 'Firebase/Crashlytics'
    pod 'Firebase/Analytics'
    
end

target 'appit-ios' do
    required_pods
end

target 'appit-iosTests' do
    required_pods
end

workspace 'appit-ios'
#link_with 'appit-ios', 'appit-iosTests'
