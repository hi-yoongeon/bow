class AddTokenSecretToTwitterUserInfo < ActiveRecord::Migration
  def up
    add_column :twitter_user_infos, :token, :string
    add_column :twitter_user_infos, :secret, :string
    add_column :twitter_user_infos, :twitter_id, :string
    add_column :twitter_user_infos, :screen_name, :string
    add_column :twitter_user_infos, :profile_image_url, :string
  end

  def down
    remove_column :twitter_user_infos, :token
    remove_column :twitter_user_infos, :secret
    remove_column :twitter_user_infos, :twitter_id
    remove_column :twitter_user_infos, :screen_name
    remove_column :twitter_user_infos, :profile_image_url
  end
end
