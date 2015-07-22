class OwnerItemsController < ApplicationController
  def index
  	@owner = User.find_by(id: params[:owner])
  	@items = Item.where(user_id: @owner.id).paginate(page: params[:page], per_page: 5)
  end
end
