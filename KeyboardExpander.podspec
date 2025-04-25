Pod::Spec.new do |s|
  s.name             = 'KeyboardExpander'
  s.module_name      = 'KeyboardExpander'
  s.version          = '1.0.3'
  s.license          = { :type => 'Copyright', :text => <<-LICENSE
									Copyright 2024
									Codemost Limited. 
									LICENSE
								}
  s.homepage         = 'http://www.codemost.co.uk/'
  s.author           = { 'Codemost Limited' => 'tolga@codemost.co.uk' }
  s.summary          = 'Automatically expands or collapses views in response to keyboard appearance, simplifying UI layout adjustments.'
  s.description     = <<-DESC
                        A lightweight utility that automatically adjusts layout constraints when the keyboard appears or disappears. KeyboardExpander simplifies keyboard-driven UI changes by observing keyboard notifications and expanding or collapsing views in response—no manual offset math required.
                       DESC

  s.source           = { :git => 'https://github.com/codemostUK/KeyboardExpander.git',
 								 :tag => s.version.to_s }
  s.source_files     = 'Sources/KeyboardExpander/*.{swift}'
  s.documentation_url = 'https://github.com/codemostUK/KeyboardExpander/blob/main/README.md'
  s.requires_arc    = true
  s.ios.deployment_target = '13.0'
  s.swift_version   = '6'
  s.frameworks = 'UIKit', 'Foundation'
end