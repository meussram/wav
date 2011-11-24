# myapp.rb
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require './lib/waveform.rb'

get '/' do
  erb :upload
end

get '/upload' do
  erb :upload
end

post '/upload' do
  
  File.open('sounds/' + params['sound'][:filename], "w") do |f|
    f.write(params['sound'][:tempfile].read)
  end
 
  file = 'sounds/' + params['sound'][:filename]
  file_name = file.split('/').last
  #return file
  conf = YAML::load(File.open('./conf/conf_plot_points.yml'))
  tarace = Waveform.new('./conf/conf_plot_points.yml', file)
  
  plots = tarace.generate_plot_points(tarace.file)
  
  plots_hash = {"data" => plots}
  
  write = tarace.write_graph_plots_to_json("#{conf['data']}#{tarace.file_name.split('/').last}.#{tarace.number_of_points}.json", plots_hash)
  
  redirect '/wave/'+file_name
end

get '/wave/*' do
  erb :index
end

