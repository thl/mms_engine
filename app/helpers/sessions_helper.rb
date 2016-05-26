module SessionsHelper
  def options_for_filters
    selected_key = current_filter.blank? ? Session::FILTERS_HASH.keys.first : current_filter
    selected = sessions_filter_by_path(selected_key)
    options_for_select(Session::FILTERS_HASH.to_a.collect{|a| [a[1], sessions_filter_by_path(a[0])] }, selected)
  end
  
  def current_filter
    session[:filter]
  end
end
