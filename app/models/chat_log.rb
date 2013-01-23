class ChatLog < ActiveRecord::Base
  attr_accessible :log, :room_id, :user_id
end
