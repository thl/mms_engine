module SubjectsHelper
  def new_element_path(options={})
    new_subject_path(options)
  end
  
  def element_path(child)
    subject_path(child)
  end
  
  def elements_path
    subjects_path 
  end  
  
  def edit_element_path(child)
    edit_subject_path(child)
  end
  
  def hash_for_new_element_path
    hash_for_new_subject_path 
  end
  
  def hash_for_edit_element_path
    hash_for_edit_subject_path
  end
  
  def hash_for_element_path(options={})
    hash_for_subject_path(options)
  end  
end