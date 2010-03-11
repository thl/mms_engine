class SubtitlesController < AclController
  def index
    require 'xml/xslt'
    
    video_id = params[:video_id]
    video = video_id.blank? ? nil : Video.find(video_id)
    transcript = video.transcript
    language = params[:language]
    form = params[:form]
    if transcript.nil?
      render :text => ''
    else
      xslt = XML::XSLT.new
      xslt.xsl = File.join('xslts', 'transcript2timedtext.xsl')
      xslt.xml =  transcript.full_filename
      if language == 'bo'
        if form == 'transliteration'
          xslt.parameters = {'form' => "'bo-Latn'"} 
        else
          xslt.parameters = {'form' => "'bo'"}
        end
      elsif language == 'en'
        xslt.parameters = {'form' => "''", 'transl' => "'en'"}
      end
      output = xslt.serve
      render :text => output
    end
  end  
end
