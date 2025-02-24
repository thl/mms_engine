if image.instance_of String
  xml.image(:url => image)
else
  xml.image(:url => "#{server}#{image.public_filename}", :thumbnail => image.thumbnail, :width => image.width, :height => image.height, :size => image.size)
end