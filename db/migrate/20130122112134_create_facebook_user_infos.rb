class CreateFacebookUserInfos < ActiveRecord::Migration
  def change
    create_table :facebook_user_infos do |t|
      t.string :access_key
      t.integer :user_id

      t.timestamps
    end
  end
end
