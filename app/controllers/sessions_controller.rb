class SessionsController < ApplicationController
  def filter_by
    filter_str = params[:id]
    if !filter_str.blank?
      index = Session::FILTERS_HASH.keys.index(filter_str.to_sym)
      if index==0
        session[:filter] = nil
      elsif index>0
        session[:filter] = filter_str
      end
    end
    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
  end
end
