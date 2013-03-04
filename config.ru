require 'bundler'
Bundler.setup :default
require 'sprockets'
require './app'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'javascripts'
  environment.append_path 'stylesheets'

  bootstrap = Gem::Specification.find_by_name('sass-twitter-bootstrap')
  Dir[bootstrap.gem_dir + '/vendor/assets/*/'].each do |dir|
    environment.append_path dir
  end

  run environment
end

map '/' do
  run ChatHost
end
