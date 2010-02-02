# KnowledgeMapsDeployer
require 'config/environment'

module Local
  class Collection < ActiveRecord::Base
    acts_as_tree :order => 'title'
    belongs_to :registered_theme
  end  
  class Subject < ActiveRecord::Base
    acts_as_tree :order => '`order`, title'
  end
end

module KnowledgeMapsDeployer
  def self.do_deployment
    # Collections deployment
    self.deploy_category(Local::Collection, Collection.root)
    self.deploy_category(Local::Subject, Subject.find(3793))
  end
  
  private
  
  def self.deploy_category(local_model, remote)
    local_model.find(:all, :conditions => {:parent_id => nil}).each{ |local| self.deploy_category_tree(local, remote) }
  end
  
  def self.deploy_category_tree(local, remote_parent)
    remote = remote_parent.class.create(:title => local.title, :description => local.description, :parent_id => remote_parent.id)
    TranslatedTitle.create(:category_id => remote.id, :language_id => 3, :title => local.title_dz) if !local.title_dz.blank?
    self.switch_dependencies_with_new_id(local, remote)
    local.children.each { |child| self.deploy_category_tree(child, remote) }
  end
  
  # do all local substitutions of local for remote
  def self.switch_dependencies_with_new_id(local, remote)
    remote_class = remote.class
    if remote_class==Collection
      associations = MediaCollectionAssociation.find(:all, :conditions => {:collection_id => local.id})
    elsif remote_class==Subject
      associations = MediaSubjectAssociation.find(:all, :conditions => {:subject_id => local.id})
    end  
    associations.each { |a| MediaCategoryAssociation.create(:category => remote, :medium => a.medium, :root => remote_class.root) }
  end
end
