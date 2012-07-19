class ReplaceCreatorAsUserForPerson < ActiveRecord::Migration
  def self.up
    [AdministrativeUnit, Caption, Collection, Description, Ethnicity, Subject].each {|model| self.update model }
  end
  
  def self.update(model)
    for element in model.find(:all, :conditions => 'creator_id IS NOT NULL') do
      id = element.creator_id
      begin
        user = AuthenticatedSystem::User.find(id)
        person = user.person
      rescue ActiveRecord::RecordNotFound
        person = nil
      end
      element.creator = person
      element.save
    end
  end

  def self.unupdate(model)
    for element in model.find(:all, :conditions => 'creator_id IS NOT NULL') do
      id = element.creator_id
      person = AuthenticatedSystem::Person.find(id)
      element.creator = person.user
      element.save
    end
  end

  def self.down
    [AdministrativeUnit, Caption, Collection, Description, Ethnicity, Subject].each {|model| self.unupdate model }
  end
end
