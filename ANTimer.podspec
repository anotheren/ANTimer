Pod::Spec.new do |s|
    s.name = 'ANTimer'
    s.version = '1.1.1'
    s.license = 'MIT'
    s.summary = 'ANTimer'
    s.homepage = 'https://github.com/anotheren/ANTimer'
    s.authors = {
        'anotheren' => 'liudong.edward@gmail.com',
    }
    s.source = { :git => 'https://github.com/anotheren/ANTimer.git', :tag => s.version }
    s.ios.deployment_target = '10.0'
    s.swift_versions = ['5.0', '5.1']
    s.source_files = 'Sources/**/*.swift'
    s.frameworks = 'Foundation'
  end
