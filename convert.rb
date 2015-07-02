require 'pry'

class Song
  attr_reader :name, :artist, :album, :length

  def initialize(name, artist, album, length)
    @name = name
    @artist = artist
    @album = album
    @length = length
  end

  def output_string
    "#{name}\t#{artist}\t\t#{album}\t\t\t\t#{length}\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n"
  end


  def self.song_for_string(string)
    fields = string.split(%Q{\"})
    name = fields[3]
    artist = fields[5]
    album = fields[7]
    unrounded_length = fields[13]
    length = (unrounded_length.to_i / 1000) if unrounded_length
    Song.new(name, artist, album, length)
  end
end

header = "Name\tArtist\tComposer\tAlbum\tGrouping\tGenre\tSize\tTime\tDisc Number\tDisc Count\tTrack Number\tTrack Count\tYear\tDate Modified\tDate Added\tBit Rate\tSample Rate\tVolume Adjustment\tKind\tEqualizer\tComments\tPlays\tLast Played\tSkips\tLast Skipped\tMy Rating\tLocation"

csv_files = Dir.glob './CSVs/*.csv'
songs = []
# csv_files = [csv_files[0]]

output_directory = './TXTs'
if !File.directory?(output_directory)
  FileUtils::mkdir_p output_directory
end

csv_files.each do |file|
  song_strings = File.readlines(file)
  song_strings.each_with_index do |line, index|
    next if index == 0
    songs << Song.song_for_string(line)
  end

  filename = file.split('.')[-2].split('/')[-1]
  File.open("./TXTs/#{filename}.txt", 'w') do |file|
    file.write(header)
    file.write("\r\n")
    songs.each do |song|
      file.write "#{song.output_string}"
    end
  end
end



