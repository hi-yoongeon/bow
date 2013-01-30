class RoomController < ApplicationController

  before_filter :authorize, :only => ['create']

  def create
    
  end

end
