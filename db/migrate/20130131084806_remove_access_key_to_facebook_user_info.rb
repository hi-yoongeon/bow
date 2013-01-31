class RemoveAccessKeyToFacebookUserInfo < ActiveRecord::Migration
  def up
    remove_column :facebook_user_infos, :access_key
  end

  def down
    add_column :facebook_user_infos, :access_key, :string
  end
end
