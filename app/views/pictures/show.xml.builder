xml.instruct!
xml << render(:partial => 'media/show.xml.builder', :locals => {:medium => @medium})