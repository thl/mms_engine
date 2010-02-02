module MediaAdministrativeLocationsHelper
  def associations_path(options = {})
    media_administrative_locations_path(options)
  end
  
  def edit_association_path(element)
    edit_media_administrative_location_path(element)
  end
  
  def association_path(element)
    media_administrative_location_path(element)
  end
  
  def elements_path
    if @country.nil?
      countries_path
    else
      country_administrative_units_path(@country)
    end
  end
end
