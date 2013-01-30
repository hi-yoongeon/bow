class AddNicknameToUser < ActiveRecord::Migration
  def change
    add_column :users, :nickname, :string
    remove_column :users, :screen_name
  end
end
