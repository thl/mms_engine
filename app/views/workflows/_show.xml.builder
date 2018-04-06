xml.workflow do
  xml.id(workflow.id, type: 'integer')
  xml.original_filename(workflow.original_filename)
  xml.original_medium_id(workflow.original_medium_id)
  xml.other_id(workflow.other_id)
  xml.notes(workflow.notes)
  xml.sequence_order(workflow.sequence_order, type: 'integer')
  metadata_source = workflow.metadata_source
  xml.metadata_source(id: metadata_source.id, filename: metadata_source.filename) if !metadata_source.nil?
  xml.original_path(workflow.original_path)
end