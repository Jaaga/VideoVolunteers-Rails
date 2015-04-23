class AddNewExtensions < ActiveRecord::Migration
  def change
  	execute "create extension pg_trgm"
    execute "create extension fuzzystrmatch"
  end
end
