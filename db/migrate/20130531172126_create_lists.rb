class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :title, :null=>false, :default=>""
      t.text :description, :null=>false, :default=>""
      t.boolean :public, :null=>false, :default=>false
      t.boolean :completed, :null=>false, :default=>false
      t.datetime :finished_at

      t.timestamps
      t.references :user, :null=>false
    end
  end
end
