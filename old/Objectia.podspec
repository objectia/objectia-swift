Pod::Spec.new do |s|
    s.name                 = 'Objectia'
    s.version              = '0.9.1'
    s.cocoapods_version    = '>= 1.1.0'
    s.authors              = { 'Objectia' => 'hello@objectia.com' }
    s.license              = { :type => 'MIT', :file => 'LICENSE' }
    s.homepage             = 'https://github.com/objectia/objectia-swift'
    s.source               = { :git => 'https://github.com/objectia/objectia-swift.git',
                               :tag => "v#{s.version}" }
    s.summary              = 'Swift client for Objectia API'
    s.description          = <<-DESC
                                This is the Swift client library for Objectia API. To use it you\'ll need a Objectia account. 
                                Sign up for free at https://objectia.com
                             DESC
    s.documentation_url    = 'https://docs.objectia.com/guide/swift.html'
   
    s.platform             = :osx
   
    s.default_subspec      = 'Core'
    s.subspec 'Core' do |ss|
        ss.framework       = 'Foundation'
        ss.source_files    = 'Sources/*.swift', 'Sources/**/*.swift'
    end
   
end