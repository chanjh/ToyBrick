
Pod::Spec.new do |s|
  s.name             = 'ToyBrick'
  s.version          = '0.0.1'
  s.summary          = 'ToyBrick: BeeHive swift implementation.'

  s.description      = <<-DESC
TobBrick is a iOS Project Modular Framework written by Swift, which is based on [Alibaba/BeeHive](https://github.com/alibaba/BeeHive).
                       DESC

  s.homepage         = 'https://github.com/chanjh/ToyBrick'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'UgCode' => 'jiahao0408@gmail.com' }
  s.source           = { :git => 'https://github.com/chanjh/ToyBrick.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'ToyBrick/Classes/**/*'
  s.resource = 'ToyBrick/*.bundle'
  
end
