$:.unshift File::dirname(__FILE__)
$:.unshift "#{File::dirname(__FILE__)}/lib"
$:.unshift "#{File::dirname(__FILE__)}/app"
$:.unshift "#{File::dirname(__FILE__)}/config"

require_relative 'bootstrap'
require 'app/app'

map '/' do
  use L10n::Application
  run Sinatra::Base
end

map '/hooks' do
   use L10n::Hooks
  run Sinatra::Base
end
