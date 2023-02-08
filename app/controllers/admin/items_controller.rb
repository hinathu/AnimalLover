class Admin::ItemsController < ApplicationController
  
  # 全ての投稿一覧
  def index
    @items = Item.page(params[:page]).per(8)
    @genres = Genre.all
    # ジャンル検索機能
    if params[:genre_id].present?
      #presentメソッドでparams[:category_id]に値が含まれているか確認 => trueの場合下記を実行
      @genre = Genre.find(params[:genre_id])
      @items = @genre.items.page(params[:page]).per(8)
    end
  end

  # 投稿詳細
  def show
    @item = Item.find(params[:id])
    @customer = @item.customer
  end
  
   # キーワード検索機能
  def search
    @items = Item.search(params[:keyword]).order(created_at: :desc).page(params[:page]).per(8)
    @keyword = params[:keyword]
  end
  
  # 投稿削除
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to admin_items_path
  end
  
  # 登録データのストロングパラメータ
  private
  def item_params
    params.require(:item).permit(:customer_id, :genre_id, :image, :name, :category, :body)
  end
  
end
