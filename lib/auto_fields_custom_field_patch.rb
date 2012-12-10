# issue_patch.rb
require_dependency 'group'

module AutoFieldsCustomFieldPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)

    # Same as typing in the class 
    base.class_eval do
      has_many :auto_field, :class_name => 'AutoField', :dependent=>:delete_all
    end

  end

  module ClassMethods   
    # Methods to add to the Issue class
  end

  module InstanceMethods
    # Methods to add to specific issue objects
  end
end

