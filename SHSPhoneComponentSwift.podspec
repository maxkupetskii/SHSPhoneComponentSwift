Pod::Spec.new do |s|
  s.name         = "SHSPhoneComponentSwift"
  s.version      = "0.98"
  s.summary      = "UITextField and NSFormatter subclasses for formatting phone numbers. Allow different formats for different countries(patterns)"
  s.homepage     = "https://github.com/alucarders/SHSPhoneComponentSwift"
  s.license      = "MIT"
  s.author       = { "Max Kupetskii" => "maksim_kupetskii@epam.com" }
  s.platform     = :ios, "9.3"
  s.source       = { :git => "https://github.com/alucarders/SHSPhoneComponentSwift.git", :tag => s.version.to_s }
  s.source_files = "SHSPhoneComponent/Library/*.{h,swift}"
  s.requires_arc = true
end
