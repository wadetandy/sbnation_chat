require 'sinatra/base'
require 'haml'

class ChatHost < Sinatra::Base
  get '/' do
    haml :index
  end
end
