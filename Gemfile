source "https://rubygems.org"

gem "fastlane", "2.170"
gem "cocoapods"
#gem 'fastlane-plugin-discord'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
