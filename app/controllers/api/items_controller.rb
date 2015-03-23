class Api::ItemsController < ApiController
  def index
    item_type_id = params[:item_type_id]

  	@items = if @@query.empty? && item_type_id == nil
      Item.all.order(change_query_order)
    elsif @@query.empty? == false
			Item.where("lower(title) LIKE ? OR 
        lower(origin_type) = ?", @@query, @@query.gsub("%", "")).order(change_query_order)
    else
      Item.where("item_type_id = ?", item_type_id).order(change_query_order)
		end

		paginate json: @items, per_page: change_per_page
  end

  def show
  	@item = Item.find(params[:id])

		render json: @item
  end
end
