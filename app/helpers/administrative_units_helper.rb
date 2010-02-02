module AdministrativeUnitsHelper
  def new_element_path(options={})
    new_country_administrative_unit_path(@country, options)
  end
  
  def element_path(child)
    country_administrative_unit_path(@country, child)
  end
  
  def elements_path
    country_administrative_units_path(@country)
  end  
  
  def edit_element_path(child)
    edit_country_administrative_unit_path(@country, child)
  end
  
  def expand_element_path(child, options = {})
    expand_country_administrative_unit_path(@country, child, options)
  end

  def contract_element_path(child, options = {})
    contract_country_administrative_unit_path(@country, child, options)
  end
  
  def hash_for_new_element_path
    hash_for_new_country_administrative_unit_path 
  end
  
  def hash_for_edit_element_path
    hash_for_edit_country_administrative_unit_path
  end
  
  def hash_for_element_path(options={})
    hash_for_country_administrative_unit_path(options)
  end
end