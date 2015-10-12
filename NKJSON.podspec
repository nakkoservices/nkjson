Pod::Spec.new do |s|
    s.name = 'NKJSON'
    s.version = '1.0.7'
    s.license = 'MIT'
    s.summary = 'The Swift class you were missing for those pesky JSON chunks of data'
    s.homepage = 'https://github.com/nakkoservices/nkjson'
    s.social_media_url = 'https://twitter.com/PyBaig'
    s.authors = { 'Mihai Fratu' => 'zeusent@msn.com' }
    s.source = { :git => 'https://github.com/nakkoservices/nkjson.git', :tag => s.version }

    s.ios.deployment_target = '8.0'

    s.source_files = 'NKJSON/NKJSON.swift'

    s.requires_arc = true
end
