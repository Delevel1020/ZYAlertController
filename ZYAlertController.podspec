Pod::Spec.new do |spec|
  spec.name         = "ZYAlertController"
  spec.version      = "0.1.0"
  spec.summary      = "ZYAlertController is swift module, Modify the library based on the third-party TYAlertController"
  spec.description  = <<-DESC
                    "ZYAlertController Library"
                   DESC

  spec.homepage     = "https://github.com/Delevel1020/ZYAlertController"
  spec.license      = "MIT"
  spec.author       = { "delevel" => "delevel1020@gmail.com" }
  spec.ios.deployment_target = "10.0"
  spec.platform     = :ios
  spec.source       = { :git => "https://github.com/Delevel1020/ZYAlertController.git", :tag => spec.version }
  spec.requires_arc = true
  spec.static_framework = true
  spec.source_files  = "ZYAlertController/Source/*.{h,m}"
end
