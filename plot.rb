#-----------------------------------------------
# Ruby script to draw a graph by gnuplot.(Ex.1)
#-----------------------------------------------
require 'gnuplot'
require 'wav-file'

def bit_per_sample(format)
  format.bitPerSample == 16 ? 's*' : 'c*'
end

def get_wav_array(data_chunk, format)
  data_chunk.data.unpack(bit_per_sample(format))
end

f = open('test.wav')
format = WavFile.readFormat(f)
data_chunk = WavFile.readDataChunk(f)
wavs = get_wav_array(data_chunk, format)

Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|
    plot.xrange "[0:#{wavs.length}]"
    plot.title  'wav plot'
    plot.xlabel 'time'
    plot.ylabel 'dB'
    plot.grid
    plot.set 'size ratio 0.25'
    plot.set 'terminal png size 1280,480'
    plot.set "output 'output.png'"
    plot.set "linestyle 1 linecolor rgbcolor 'orange' linetype 1"

    plot.data << Gnuplot::DataSet.new(wavs) do |ds|
      ds.with      = 'lines'
      ds.linewidth = 1
    end
  end
end
