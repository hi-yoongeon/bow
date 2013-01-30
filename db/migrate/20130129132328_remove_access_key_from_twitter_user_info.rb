class RemoveAccessKeyFromTwitterUserInfo < ActiveRecord::Migration
  def up
    remove_column :twitter_user_infos, :access_key
  end

  def down
    add_column :twitter_user_infos, :access_key, :string
  end
end
