require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'sinatra/base'

class App < Sinatra::Base
  # {{{ options
  register Sinatra::Partial
  set :partial_template_engine, :slim
  enable :partial_underscores
  # {{{ dev
  configure :development, :test do
    set :slim, pretty: true
    enable :dump_errors, :logging
  end

  # }}}
  # {{{ prod
  configure :production do
    disable :logging
    enable :dump_errors
    set :bind, '0.0.0.0'
    set :port, 80
    set :scss, style: :compressed, debug_info: false
  end

  # }}}
  # }}}
  # {{{ get '/css/:file.css' do
  get '/css/:file.css' do
    error 404 unless File.exist? "views/scss/#{params[:file]}.scss"
    time = File.stat("views/scss/#{params[:file]}.scss").ctime
    last_modified time
    file = 'scss/' + params[:file]
    scss file.to_sym
  end

  # }}}
  # {{{ get '/' do
  get '/' do
    slim :index
  end

  # }}}
end
