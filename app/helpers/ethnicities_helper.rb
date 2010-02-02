module EthnicitiesHelper
  def new_element_path(options={})
    new_ethnicity_path(options)
  end
  
  def element_path(child)
    ethnicity_path(child)
  end
  
  def elements_path
    ethnicities_path 
  end  
  
  def edit_element_path(child)
    edit_ethnicity_path(child)
  end
  
  def hash_for_new_element_path
    hash_for_new_ethnicity_path 
  end
  
  def hash_for_edit_element_path
    hash_for_edit_ethnicity_path
  end
  
  def hash_for_element_path(options={})
    hash_for_ethnicity_path(options)
  end  
end