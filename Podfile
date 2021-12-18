platform :ios, '10.0'
use_frameworks!

workspace 'AEPMedia'
project 'AEPMedia.xcodeproj'

pod 'SwiftLint', '0.44.0'

target 'AEPMedia' do
  pod 'AEPCore'
  pod 'AEPServices'
  pod 'AEPIdentity'
  pod 'AEPRulesEngine'
end

target 'AEPMediaUnitTests' do
  pod 'AEPCore'
  pod 'AEPServices'
  pod 'AEPRulesEngine'
end

target 'AEPMediaFunctionalTests' do
  pod 'AEPCore'
  pod 'AEPServices'
  pod 'AEPRulesEngine'
end

target 'MediaSampleApp' do
  pod 'AEPCore'
  pod 'AEPServices'
  pod 'AEPRulesEngine'
  pod 'AEPLifecycle'
  pod 'AEPIdentity'
  pod 'AEPAnalytics'
  pod 'AEPAssurance', '~> 3.0'
end
