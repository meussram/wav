require 'rubygems'
#require 'stringio'

module WavfileProcessor
	
	def WavfileProcessor.read_fmt(file)
		while !file.eof?

		if file.read(3) == 'fmt'
			file.read(5)
			fmt = file.read(2).unpack('s').first
			num_chan = file.read(2).unpack('s').first		
			sample_rate = file.read(4).unpack('l').first		
			byte_rate = file.read(4).unpack('l').first	
			file.read(2)
			bits_per_sample = file.read(2).unpack('s').first
			return fmt, num_chan, sample_rate, byte_rate, bits_per_sample
		end
	 end
	end
	
	
	
	def WavfileProcessor.read_data(file, bits_per_sample)
		plots = []
		while !file.eof?
			if file.read(4) == 'data'
				data_length = file.read(4).unpack('l').first	
		    wavedata = StringIO.new file.read(data_length)
		    while !wavedata.eof?
			    if bits_per_sample == 24
					  ch1 = ("\x00" + wavedata.read(3)).unpack('l').first
						ch2 = ("\x00" + wavedata.read(3)).unpack('l').first
					elsif bits_per_sample == 16
						ch1, ch2 = wavedata.read(4).unpack('ss')
					end
					plots << ch1+ch2
		    end
	    end
	  end
		return plots, data_length
  end


end