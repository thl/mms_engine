class ShantiImage
  include Flare::ActiveExtension
  include ActiveModel::Model
      
  KNOWN_ATTRS = [:id, :uid, :caption, :node_user, :node_lang, :node_created, :node_changed, :title, :service, :asset_type, :url_html, :url_ajax, :url_json, :url_thumb, :timestamp, :url_iiif_s]
  attr_accessor *KNOWN_ATTRS
      
  # acts_as_indexable hostname: 'asset_hostname', path: 'asset_path', uid_prefix: self.service, scope: { asset_type: 'sources', service: self.service }
  acts_as_indexable uid_prefix: 'images', scope: { asset_type: 'images' }
  
  def self.find(id)
    hash = Rails.cache.fetch("shanti_integration/image/#{id}", :expires_in => 1.day) do
      self.flare_search(id)
    end
    return nil if hash.blank?
    attrs = {}
    KNOWN_ATTRS.each{ |key| attrs[key]=hash[key.to_s] }
    return self.new(attrs)
  end
  
  def self.from_mms(id)
    uri = URI("https://images.mandala.library.virginia.edu/api/imginfo/mmsid/#{id}")
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    nid_str = json['nid']
    return nil if nid_str.nil?
    nid = nid_str.to_i
    shanti_image = self.find(nid)
    shanti_image.nil? ? nid : shanti_image
  end
end