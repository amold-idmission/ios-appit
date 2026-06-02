platform :ios, ‘15.6’
inhibit_all_warnings!

def required_pods
use_frameworks!   
    pod 'WebRTC'
    pod 'CocoaLumberjack'
    pod 'SocketRocket'
    pod 'IdmEncryption'
    pod 'OpenSSL-Universal'

    pod 'TensorFlowLiteObjC', '~> 2.7.0'
    pod 'GoogleMLKit/TextRecognition', '~> 8.0.0'
    pod 'GoogleMLKit/FaceDetection', '~> 8.0.0'

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
