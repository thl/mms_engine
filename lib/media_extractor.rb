# MediaExtractor
# require 'config/environment'
require 'csv'

module MediaExtractor
  def self.extract_metadata(filename)
    field_names = nil
    CSV.open(filename, 'r', "\t") do |row|
      if field_names.nil?
        field_names = row
        next
      end
      fields = Hash.new
      row.each_with_index { |field, index| fields[field_names[index]] = field if !field.blank? }
      mms_id = fields['media.id']
      if mms_id.blank?
        original_filename = fields['workflows.original_filename']
        workflow = Workflow.find(:first, :conditions => ['original_filename LIKE ?', '%s.%' % original_filename])
        medium = workflow.medium
      else
        medium = Medium.find(mms_id)
      end
      model = medium.capture_device_model
      model_str = model.nil? ? "\t" : "#{model.capture_device_maker.title}\t#{model.title}"
      taken_on = medium.taken_on || medium.partial_taken_on
      puts "#{original_filename}\t#{model_str}\t#{taken_on}"
    end
  end
end
