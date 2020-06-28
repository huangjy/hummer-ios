
Pod::Spec.new do |s|
  s.name             = 'Hummer'
  s.version          = '0.1.0'
  s.summary          = 'Hummer'

  s.description      = <<-DESC
                        Hummer is a dynamic solution
                        for client. 
                       DESC

  s.homepage         = 'http://huangjy.io/book/dynamic/hummer_guide.html'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huangjy' => 'hjy_x@163.com' }
  s.source           = { :git => 'git@github.com:huangjy/hummer-ios.git', :tag => s.version.to_s }

  s.platform     = :ios, "8.0"

  s.source_files = 'Hummer/*.h','Hummer/Classes/**/*'
  s.exclude_files= "Hummer/Info.plist"

end
