class Admin::ItemsController < ApplicationController
  def index
    @items = Item.page(params[:page]).per(8)
  end

  def show
    @item = Item.find(params[:id])
    @customer = @item.customer
  end
  
  # 登録データのストロングパラメータ
  private
  def item_params
    params.require(:item).permit(:customer_id, :genre_id, :image, :name, :category, :body)
  end
  
end
