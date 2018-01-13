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

  def table_name_for_insert
    self.class.table_name
  end

  def col_names_for_insert
    columns = self.class.column_names
    columns.delete("id")
    columns.join(", ")
  end

  def values_for_insert
    values = []

    self.class.column_names.each do |col_name|
      values << "'#{send(col_name)}'" unless send(col_name).nil?
    end
    values.join(", ")
  end

  def save
    sql = <<-SQL
    INSERT INTO #{self.table_name_for_insert}
    (#{self.col_names_for_insert})
    VALUES
    (#{self.values_for_insert})
    SQL
    DB[:conn].execute(sql)
    @id = DB[:conn].execute("SELECT last_insert_rowid FROM #{table_name_for_insert}")
  end

  def self.find_by_name(name)
  end

  def self.find_by(attribute, value)
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
