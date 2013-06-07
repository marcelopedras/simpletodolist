class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title, :null=>false, :default=>""
      t.text :description, :null=>false, :default=>""
      t.boolean :completed, :null=>false, :default=>false
      t.datetime :finished_at
      t.integer :order, :unsigned => true, :null=>false, :default => 0

      t.timestamps

      t.references :list, :null=>false
    end
  end
end
