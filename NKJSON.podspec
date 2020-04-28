Pod::Spec.new do |s|
    s.name = 'NKJSON'
    s.version = '6.0.0'
    s.license = 'MIT'
    s.summary = 'The Swift class you were missing for those pesky JSON chunks of data'
    s.homepage = 'https://github.com/nakkoservices/nkjson'
    s.social_media_url = 'https://twitter.com/nakko'
    s.authors = { 'Mihai Fratu' => 'zeusent@msn.com' }
    s.source = { :git => 'https://github.com/nakkoservices/nkjson.git', :tag => s.version }

    s.ios.deployment_target = '8.0'
    s.tvos.deployment_target = '9.0'
    s.watchos.deployment_target = '2.0'
    s.osx.deployment_target = '10.9'

    s.source_files = 'Sources/NKJSON/NKJSON.swift'

    s.requires_arc = true

end
