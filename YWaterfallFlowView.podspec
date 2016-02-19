Pod::Spec.new do |s|
s.name     = 'YWaterfallFlowView'
s.version  = '1.0.2'
s.license  = 'MIT'
s.summary  = 'a YWaterfallFlowView.'
s.homepage = 'https://github.com/DoctorScholar/YWaterfallFlowView'
s.author   = { 'yan qingshan' => 'iosscholar@sina.cn' }
s.source   = { :git => 'https://github.com/DoctorScholar/YWaterfallFlowView.git', :tag => 'v1.0.2' }
s.platform = :ios
s.source_files = 'YWaterfallFlowView/*'
s.framework = 'UIKit'

s.requires_arc = true
end