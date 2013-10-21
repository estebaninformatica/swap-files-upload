require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require "sass"
require "thin" if development?
get('/styles.scss'){ scss :styles }


set :public_folder, File.join(File.dirname(__FILE__), 'public')
set :files, File.join(settings.public_folder, 'files')

get '/' do
	slim :home
end

get '/about' do
	slim :about
end

get '/contact' do
	slim :contact
end

get '/upload' do
	@files = Dir.entries(settings.files) - ['.', '..']
  slim :upload
end

not_found do
	slim :not_found
end

post '/upload' do
  if params[:file]
    filename = params[:file][:filename] + DateTime.now.to_s
    file = params[:file][:tempfile]

    File.open(File.join(settings.files, filename), 'wb') do |f|
      f.write file.read
  	end
		@flash = 'Upload successful'
  else
    @flash = 'You have to choose a file'
  end
    @files = Dir.entries(settings.files) - ['.', '..']
  slim :upload
end

