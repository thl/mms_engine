# ForkedNotifier
# Relies on a method called log_suffix
module ForkedNotifier
  include FileUtils
  
  protected
  
  def background_process(do_forking=true, do_detach=true)
    if RUBY_PLATFORM =~ /(:?mswin|mingw)/ || !do_forking
      Thread.new { yield }
    else
      # This will avoid mysql connection from dropping
      dbconfig = ActiveRecord::Base.remove_connection
      pid = fork do
        begin
          ActiveRecord::Base.establish_connection(dbconfig)
          yield
        ensure
          ActiveRecord::Base.remove_connection
          exit!
        end
      end
      ActiveRecord::Base.establish_connection(dbconfig)
      # avoids the process becoming a zombie
      Process.detach(pid) if do_detach
    end
  end
  
  def register_active_process(pid=nil)
    File.open(active_filename, "w") do |log|
      if RUBY_PLATFORM =~ /(:?mswin|mingw)/
        log.puts(Time.now.to_s)
      else
        pid = Process.pid if pid.nil?
        log.puts(pid)
      end
    end
  end
  
  def start_log(message)
    register_active_process
    File.open(log_filename, "w") { |log| log.puts("#{Time.now.to_s}: #{message}") }
  end
  
  def finish_log(message, user_id = current_user.id)
    write_to_log(message, user_id)
    rm_f(active_filename(user_id))
  end
  
  def users_with_active_forks
    users = Array.new
    Dir.glob(Rails.root.join('log', "active_*_#{log_suffix}.log")) do |log|
      tag, user_id, rest = File.basename(log).split('_')
      users << AuthenticatedSystem::User.find(user_id)
    end
    users
  end
  
  def users_with_forks
    users = Array.new
    Dir.glob(Rails.root.join('log', "*_#{log_suffix}.log")) do |log|
      tag = File.basename(log).split('_').first
      next if tag=='active'
      users << AuthenticatedSystem::User.find(tag)
    end
    users
  end
  
  def fork_done?(user_id = current_user.id)
    filename = active_filename(user_id)
    if File.exists?(filename)
      if RUBY_PLATFORM =~ /(:?mswin|mingw)/
        return true
      else
        file = File.new(filename)
        status = file.gets.strip
        file.close
        puts status
        sys_status = `ps -x | grep '^ *#{status}'`
        if sys_status.blank?
          finish_log('Process was abruptly terminated.', user_id)
          return true
        else
          return false
        end
      end
    else
      return true
    end
  end
  
  def write_to_log(message, user_id = current_user.id)
    File.open(log_filename(user_id), "a") { |log| log.puts("#{Time.now.to_s}: #{message}") }
  end
  
  def get_log_messages(user_id = current_user.id)
    filename = log_filename(user_id)
    return ['No log information available.'] unless File.exists?(filename)
    return IO.readlines(filename)
  end
  
  def delete_log(user_id = current_user.id)
    filename = log_filename(user_id)
    messages = IO.readlines(filename)
    size = messages.size
    if size>8
      new_messages = messages[0..4] + ["...\n"] + messages[size-2...size]
      File.open(log_filename(user_id), "w") { |log| log.print(new_messages.join) }
    end
  end
  
  private
  
  def log_filename(user_id = current_user.id)
    File.expand_path(Rails.root.join('log', "#{user_id}_#{log_suffix}.log"))
  end

  def active_filename(user_id = current_user.id)
    File.expand_path(Rails.root.join('log', "active_#{user_id}_#{log_suffix}.log"))
  end
end