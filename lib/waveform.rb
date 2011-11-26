require 'rubygems'
#require 'chunky_png'
require 'yaml'
require 'json'
require './lib/wavfile_processor.rb'


class Waveform
	#require 'wavfile_processor'
	include WavfileProcessor
	
	attr_accessor(:number_of_points, :file, :file_name)
	
	def initialize(density, wav_file_name)
		@number_of_points = density
		@file = File.open(wav_file_name, 'rb')
		@file_name = wav_file_name 
	end
	
	
	def write_graph_plots_to_json(file_name, plot_points_hash)
		File.open(file_name, 'w') do |f|
			f.write plot_points_hash.to_json
		end
	end
	
	
	def write_graph_plots_to_png(file_name, plot_points, img_width=800, img_heigth=200, background_color=':white', line_color=':black')		
		png = ChunkyPNG::Canvas.new(img_width, img_height, background_color)
		
		max = 0
		plot_points_array.each do |p|
			if p.abs > max
				max = p.abs
			end
		end
		
		coeff = (img_height - img_height*0.58).to_f/max.to_f
		x0 = 0 
		plot_points_array.each_index do |i|
			unless i == 0
				png.line_xiaolin_wu(x0, (plot_points[i-1] * coeff).to_i + img_height/2, x0+1, (plot_points[i].to_i * coeff).to_i + img_height/2, line_color, inclusive = true)
			end	
			x0+=1
		end		
		png.save("file_name", :interlace => true)
	end
	
	
	def generate_plot_points(file)
		
		plots = [] 
		indexes = []
		avg = []
		
		fmt, num_chan, sample_rate, byte_rate, bits_per_sample = WavfileProcessor.read_fmt(file)
		
		plots, data_length = WavfileProcessor.read_data(file, bits_per_sample)
		num_samples = (data_length / bits_per_sample / num_chan) * 8
		divisor = (num_samples.to_f / @number_of_points.to_f).round
		
		plots.each_index do |i|
			if i % divisor == 0
				indexes << i
			end
		end

		indexes.each_index do |k|
			unless k == 0
				temp = 0
			 	for j in indexes[k - 1] .. indexes[k] do
			 		temp = plots[j] + temp
			 	end
			 	avg << (temp / divisor)
			end
	  end
		return avg
	end

end



