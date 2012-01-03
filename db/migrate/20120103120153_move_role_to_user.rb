class MoveRoleToUser < ActiveRecord::Migration
  class MyPerson < ActiveRecord::Base
    set_table_name 'people'
  end
  
  class MyUser < ActiveRecord::Base
    set_table_name 'users'
  end

  def self.up
    add_column :users, :role, :string

    MyPerson.find_each do |person|
      next if person.user_id.blank?
      user = MyUser.find_by_id(person.user_id)
      next if user.nil?
      user.update_attributes!(:role => person.role)
    end

    remove_column :people, :role
  end

  def self.down
    add_column :people, :role, :string

    MyUser.find_each do |user|
      person = MyPerson.find_by_user_id(user.id)
      next if person.nil?
      person.update_attributes!(:role => user.role)
    end

    remove_column :users, :role
  end
end
