require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord

  def initialize(attributes={})
    attributes.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def self.table_name
    self.to_s.pluralize.downcase
  end

  def self.column_names
    table_info = DB[:conn].execute("PRAGMA table_info('#{self.table_name}')")

    column_names = []

    table_info.each do |column|
      column_names << column["name"]
    end

    column_names.compact
  end

end
