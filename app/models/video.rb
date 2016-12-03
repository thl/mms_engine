# == Schema Information
#
# Table name: media
#
#  id                       :integer          not null, primary key
#  photographer_id          :integer
#  quality_type_id          :integer
#  created_on               :datetime
#  updated_on               :datetime
#  recording_note           :text
#  private_note             :text
#  type                     :string(20)       not null
#  attachment_id            :integer
#  taken_on                 :datetime
#  recording_orientation_id :integer
#  capture_device_model_id  :integer
#  partial_taken_on         :string(255)
#  application_filter_id    :integer          not null
#  resource_type_id         :integer          not null
#  rotation                 :integer
#

require 'fileutils'

class Video < Medium  
  include Util
  include ForkedNotifier

  validates_presence_of :attachment_id
  
  acts_as_indexable uid_prefix: MmsIntegration::MediaManagementResource.service, scope: {asset_type: self.name.downcase, service: MmsIntegration::Medium.service}

  before_create  { |record| record.resource_type_id = 2687 if record.resource_type_id.nil? }
  before_destroy { |record| record.movie.destroy }
  
  belongs_to :movie, :foreign_key => 'attachment_id'
  
  def attachment
    movie
  end
  
  def thumbnail_image
    att = attachment
    return nil if att.nil?
    att.children.find_by(thumbnail: 'thumb')
  end
  
  def screen_size_image
    attachment.children.find_by(thumbnail: 'preview')
  end
  
  def screen_size_movie
    movie.children.find_by(thumbnail: 'high')
  end

  def low_res_screen_size_movie
    movie.children.find_by(thumbnail: 'low')
  end
  
  def transcript
    movie.children.find_by(thumbnail: 'transcript')
  end
  
  # Requirements: gem rvideo, ffmpeg, x264, faac.
  def process(do_forking = true)
    parent = movie
    original = parent.full_filename
    bare_name = basename(parent.filename)
    pos = original.rindex('.')
    if pos>0
      path_and_name_without_extension =  original[0...pos]
    else
      path_and_name_without_extension = original
    end
    if RUBY_PLATFORM =~ /(:?mswin|mingw)/
      inspected_movie = nil
      width = 400
      height = 300
    else
      require 'rvideo'
      inspected_movie = RVideo::Inspector.new(:file => original)
      width = inspected_movie.width
      height = inspected_movie.height
    end
    if Video.generate_thumbnails(inspected_movie, width, height, original, path_and_name_without_extension)
      Movie.create(:content_type => 'image/jpeg', :filename => "#{bare_name}_compact.jpg", :parent_id => parent.id, :thumbnail => 'compact', :size => File.size("#{path_and_name_without_extension}_compact.jpg"), :width => 96, :height => 96) if File.exists?("#{path_and_name_without_extension}_compact.jpg")
      Movie.create(:content_type => 'image/jpeg', :filename => "#{bare_name}_thumb.jpg", :parent_id => parent.id, :thumbnail => 'thumb', :size => File.size("#{path_and_name_without_extension}_thumb.jpg"), :width => 120, :height => 120) if File.exists?("#{path_and_name_without_extension}_thumb.jpg")
      Movie.create(:content_type => 'image/jpeg', :filename => "#{bare_name}_preview.jpg", :parent_id => parent.id, :thumbnail => 'preview', :size => File.size("#{path_and_name_without_extension}_preview.jpg"), :width => width, :height => height) if File.exists?("#{path_and_name_without_extension}_preview.jpg")      
      high_res_movie = Movie.create :content_type => 'video/x-flv', :filename => "#{bare_name}_high.flv", :parent_id => parent.id, :thumbnail => 'high', :size => 0, :width => width, :height => height, :status => 0
      # low_res_movie = Movie.create :content_type => 'video/x-flv', :filename => "#{bare_name}_low.flv", :parent_id => parent.id, :thumbnail => 'low', :size => 0, :width => 200, :height => 150, :status => status
      high_res_movie_id = high_res_movie.id  
      # low_res_movie_id = low_res_movie.id
      background_process(do_forking) do
        Video.convert_to_flash_format(inspected_movie, original, path_and_name_without_extension)
        high_res_movie = Movie.find(high_res_movie_id)
        # low_res_movie = Movie.find(low_res_movie_id)
        high_res_movie.size = File.size("#{path_and_name_without_extension}_high.flv") if File.exists? "#{path_and_name_without_extension}_high.flv"
        # low_res_movie.size = File.size("#{path_and_name_without_extension}_low.flv") if File.exists? "#{path_and_name_without_extension}_low.flv"
        high_res_movie.status = 1
        high_res_movie.save
        # low_res_movie.status = 1
        # low_res_movie.save
      end
    end    
  end
    
  def self.maker_title
    'Videographer'
  end
  
  def self.caption_title
    'Title'
  end
  
  def self.public_folder
    'movies'
  end
  
  private
  
  def self.generate_thumbnails(inspected_movie, width, height, original, path_and_name_without_extension)
    cropped_sizes = {:compact => '96x96', :thumb => '120x120'}
    successful = true
    if inspected_movie.nil?
      cropped_sizes.each {|key, value| `ffmpeg -y -i #{original} -f image2 -ss 5 -vframes 1 -s #{value} -an #{path_and_name_without_extension}_#{key}.jpg` }
      `ffmpeg -y -i #{original} -f image2 -ss 5 -vframes 1 -s #{width}x#{height} -an #{path_and_name_without_extension}_preview.jpg`
    else
      duration_secs = inspected_movie.duration/1000
      half_way = duration_secs/2
      transcoder = RVideo::Transcoder.new
      recipe = 'ffmpeg -y -i $input_file$ -f image2 -ss $duration$ -vframes 1 -s $resolution$ -an $output_file$'
      begin
        cropped_sizes.each {|key, value| transcoder.execute(recipe, :input_file => original, :duration => half_way.to_s, :output_file => "#{path_and_name_without_extension}_#{key}.jpg", :resolution => value)}
        transcoder.execute(recipe, :input_file => original, :duration => half_way.to_s, :output_file => "#{path_and_name_without_extension}_preview.jpg", :resolution => "#{width}x#{height}")
      rescue RVideo::TranscoderError => e
        puts "Unable to transcode file: #{e.class} - #{e.message}" 
        successful = false
      end      
    end
    successful
  end
  
  def self.convert_to_flash_format(inspected_movie, original, path_and_name_without_extension)
    # `mencoder #{original} -ofps 8 -o #{path_and_name_without_extension}_low.flv -of lavf -oac mp3lame -lameopts abr:br=24 -srate 11025 -ovc lavc -lavfopts i_certify_that_my_video_stream_does_not_use_b_frames -lavcopts vcodec=flv:keyint=100:vbitrate=10:mbd=2:mv0:trell:v4mv:cbp:last_pred=3 -vf scale=200:150`
    # `mencoder #{original} -ofps 15 -o #{path_and_name_without_extension}_high.flv -of lavf -oac mp3lame -lameopts abr:br=64 -srate 22050 -ovc lavc -lavfopts i_certify_that_my_video_stream_does_not_use_b_frames -lavcopts vcodec=flv:keyint=150:vbitrate=150:mbd=2:mv0:trell:v4mv:cbp:last_pred=3 -vf scale=400:300`    
    #`cp #{original} #{path_and_name_without_extension}_high.flv`
    do_conversion = inspected_movie.nil? || (inspected_movie.video_codec!='h264' && FilenameUtils.extension_without_dot(original).downcase != 'flv')
    if do_conversion
      if inspected_movie.nil?
        `ffmpeg -i #{original} -sameq -vcodec libx264 -acodec libfaac #{path_and_name_without_extension}_high.flv`
        `flvtool2.bat -UP #{path_and_name_without_extension}_high.flv`  if File.exists? "#{path_and_name_without_extension}_high.flv"
        # `flvtool2.bat -UP #{path_and_name_without_extension}_low.flv` if File.exists? "#{path_and_name_without_extension}_low.flv"
      else
        begin
          transcoder.execute('ffmpeg -i $input_file$ -sameq -vcodec libx264 -acodec libfaac $output_file$', :input_file => original, :output_file => "#{path_and_name_without_extension}_high.flv")
        rescue RVideo::TranscoderError => e
          puts "Unable to transcode file: #{e.class} - #{e.message}"
        end
        `flvtool2 -UP #{path_and_name_without_extension}_high.flv` if File.exists? "#{path_and_name_without_extension}_high.flv"
        # `flvtool2 -UP #{path_and_name_without_extension}_low.flv` if File.exists? "#{path_and_name_without_extension}_low.flv"
      end
    else
      FileUtils.cp(original, "#{path_and_name_without_extension}_high.flv")
    end
  end
end
