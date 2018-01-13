require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'interactive_record.rb'

class Student < InteractiveRecord

    self.column_names.each do |column_name|
      if column_name == "id"
        attr_reader column_name.to_sym
      else
        attr_accessor column_name.to_sym
      end
    end


end
