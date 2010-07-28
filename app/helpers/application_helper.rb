# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def side_column_links
    str = "<h3 class=\"head\">#{link_to 'All Multimedia', '#nogo', {:hreflang => 'The media management system stores, organize and display images, videos and texts.'}}</h3>\n<ul>\n" +
          "<li>#{link_to 'Home', media_path, {:hreflang => 'Browse images, videos, and texts.'}}</li>\n" +
          "<li>#{link_to 'Advanced Search', new_media_search_path, {:hreflang => 'Search images, videos, and texts.'}}</li>\n" +
          "<li>#{link_to "Collections <em class=\"browse\">Browse</em>", collections_path, {:hreflang => 'Browse images, videos, and texts by collection.'}}</li>\n" +
          "<li>#{link_to "Cultures <em class=\"browse\">Browse</em>", ethnicities_path, {:hreflang => 'Browse images, videos, and texts by socio-cultural group.'}}</li>\n" +
          "<li>#{link_to "Subjects <em class=\"browse\">Browse</em>", subjects_path, {:hreflang => 'Browse images, videos, and texts by subject.'}}</li>\n"
    authorized_only(hash_for_admin_path) { str += "<li>#{link_to 'Administration', admin_path, {:hreflang => 'Manage countries, keywords, glossaries, static pages, copyright holders, organizations, projects, sponsors, translations, people, users, roles, themes, languages, settings and media importation.'}}</li>\n" }
    str += "</ul>"
    return str
  end
  
  def stylesheet_files
    super + ['mms', 'jquery-ui-tabs']
  end
  
  def javascript_files
    super + ['jquery-ui-tabs']
  end
  
  def javascripts
    [super, include_tiny_mce_if_needed].join("\n")
  end
  
  def secondary_tabs(current_tab_id=:media)
    tabs = [
        [:home, "Home", ActionController::Base.relative_url_root],
        [:search, "Search", new_media_search_url],
        [:collections, "Collections Browse", collections_url],
        [:cultures, "Cultures Browse", ethnicities_url],
        [:subjects, "Subjects Browse", subjects_url]
      ]
    if !session[:current_medium].blank? || current_tab_id == :media
      media_path = session[:current_medium].blank? ? ActionController::Base.relative_url_root : medium_path(session[:current_medium])
      tabs << [:media, "Media", media_path]
      current_tab_index = tabs.length - 1
    end
    index = 0
    current_tab_index = 0 if current_tab_index.blank?
    # Is there a more Ruby-ish way to do this?
    tabs.each do |tab|
      current_tab_index = index if tab[0] == current_tab_id
      index += 1
    end
    tabs[current_tab_index][2] = "#media_main"
    tabs.collect!{|tab| tab[1..2]}
    current_tab_index = 1 if current_tab_index == 0
    un_secondary_tabs tabs, current_tab_index-1
  end
  
end

module ActionView
  module Helpers
    module PaginationHelper
      def pagination_links_remote(paginator, page_options={}, ajax_options={}, html_options={})
        name = page_options[:name] || DEFAULT_OPTIONS[:name]
        params = (page_options[:params] || DEFAULT_OPTIONS[:params]).clone

        pagination_links_each(paginator, page_options) do |n|
          params[name] = n
          ajax_options[:url] = params
          link_to_remote(n.to_s, ajax_options, html_options)
        end
      end
    end # PaginationHelper
  end # Helpers
end # ActionView
