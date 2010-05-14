require 'config/environment'
namespace :mms do
  desc "Syncronize extra files for MMS"
  task :sync do
    system "rsync -ruv --exclude '.*' vendor/plugins/mms_engine/db/migrate db"
    system "rsync -ruvK --exclude '.*' vendor/plugins/mms_engine/public ."
  end
    
  namespace :helpers do
    desc 'Converts strings to symbols in SOURCE to help with the conversion of translated messages.'
    task :str_to_sym do
      source = ENV['SOURCE']
      if source.nil?
        puts 'SOURCE argument required.'
      else
        File.foreach(source) do |line|
          next if line.nil?
          line.strip!
          next if line.blank?
          puts line.strip.parameterize.to_s.underscore
        end
      end
    end
  end  
end