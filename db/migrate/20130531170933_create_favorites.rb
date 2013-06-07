class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|

      t.timestamps

      t.references :user, :null=>false
      t.references :list, :null=>false
    end
    add_index :favorites, [:user_id, :list_id], :unique => true
  end
end
