class AddFacebookIdScreenNameTokenToFacebookUserInfo < ActiveRecord::Migration
  def change
    add_column :facebook_user_infos, :facebook_id, :string
    add_column :facebook_user_infos, :screen_name, :string
    add_column :facebook_user_infos, :token, :string
  end
end
