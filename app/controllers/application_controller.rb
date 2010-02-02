# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
#require_dependency 'login_system'

class ApplicationController < ActionController::Base  
   include Spelling
   
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '051292610481c0699540df094adf0f36'
  
  def spellchecker 
      language, words, method = params[:params][0], params[:params][1], params[:method] unless params[:params].blank?
      return render :nothing => true if language.blank? || words.blank? || method.blank?
      headers["Content-Type"] = "text/plain"
      headers["charset"] = "utf-8"
      suggestions = check_spelling(words, method, language)
      results = {"id" => nil, "result" => suggestions, "error" => nil}
      render :json => results
  end  
end