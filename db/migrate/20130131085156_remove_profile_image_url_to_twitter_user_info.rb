class RemoveProfileImageUrlToTwitterUserInfo < ActiveRecord::Migration
  def up
    remove_column :twitter_user_infos, :profile_image_url
  end

  def down
    add_column :twitter_user_infos, :profile_image_url, :string
  end
end
