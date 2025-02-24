module ProcessIiif
  def self.populate(from_picture_id)
    all = from_picture_id.nil? ? Picture.all.order(:id) : Picture.where('id >= ?', from_picture_id).order(:id)
    all.each do |p|
      next if !p.iiif_image.nil?
      shanti_image = ShantiImage.from_mms(p.id)
      if shanti_image.nil? || !shanti_image.instance_of?(ShantiImage)
        puts "Picture #{p.id} not found in shanti."
      else
        uri = URI(shanti_image.url_iiif_s)
        response = Net::HTTP.get(uri)
        begin
          json = JSON.parse(response)
          p.create_iiif_image(uid: shanti_image.uid, shanti_url: shanti_image.url_html, api_url: json['@id'])
          puts "Processed picture #{p.id}"
        rescue Exception => e
          puts "Picture #{p.id} failed."
        end
      end
    end
  end
  
  def self.remove(from_picture_id)
    all = from_picture_id.nil? ? IiifImage.all.order(:picture_id) : IiifImage.where('picture_id >= ?', from_picture_id).order(:picture_id)
    all.each do |i|
      p = i.picture
      image = p.image
      next if image.nil?
      image.destroy      
      puts "Deleted pictures for #{p.id}"
    end
  end
end