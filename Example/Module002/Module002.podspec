
Pod::Spec.new do |s|
  s.name             = 'Module002'
  s.version          = '0.0.1'
  s.summary          = 'Module002: ????'

  s.description      = <<-DESC
Whaaaaaaaaaaat
                       DESC

  s.homepage         = 'https://github.com/chanjh/ToyBrick'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'UgCode' => 'jiahao0408@gmail.com' }
  s.source           = { :git => 'https://github.com/chanjh/ToyBrick.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'Classes/**/*'
  s.dependency 'ToyBrick'
end
