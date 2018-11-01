# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'porter' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for porter
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'GooglePlacePicker'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'SideMenu'
  pod 'ImageSlideshow'
  pod 'Alamofire', '~> 4.7'
  pod 'SDWebImage', '~> 4.0'
  pod 'Fabric', '~> 1.7.7'
  pod 'Crashlytics', '~> 3.10.2'
  pod 'PopupDialog', '~> 0.7'
  #pod 'Gallery'
  pod 'Gallery', :git => 'https://github.com/hyperoslo/Gallery.git', :branch => 'master'
  pod 'CardIO'
  pod 'Stripe'
  pod 'JGProgressHUD'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Messaging'
  pod 'Firebase/Storage'
  pod 'FirebaseUI/Storage'
  pod 'EasyTipView', '~> 2.0.0'
  pod 'SwiftyJSON', '~> 4.0'
end
post_install do |installer|
	installer.pods_project.targets.each do |target|
		if target.name == 'Gallery'
			target.build_configurations.each do |config|
				config.build_settings['SWIFT_VERSION'] = '4.2'
			end
		end
	end
end
