class Public::ItemsController < ApplicationController
  
  before_action :authenticate_customer!
  
  # 新規投稿
  def new
    @newitem = Item.new
  end

  # 新規投稿保存
  def create
    @newitem = Item.new(item_params)
    @newitem.customer = current_customer
    if @newitem.save
        flash[:item_create] = "保存しました！"
        redirect_to item_path(@newitem)
    else
      flash[:item_created_error] = "保存できませんでした。入力内容をご確認のうえ再度お試しください。"
      render :new
    end
  end

  # 投稿詳細
  def show
    @item = Item.find(params[:id])
    @customer = @item.customer
    @comment = Comment.new
  end

  # 全ての投稿一覧
  def index
    @items = Item.where(is_draft: 'true').page(params[:page]).per(8)
    @genres = Genre.all
    # ジャンル検索機能
    if params[:genre_id].present?
      #presentメソッドでparams[:category_id]に値が含まれているか確認 => trueの場合下記を実行
      @genre = Genre.find(params[:genre_id])
      @items = @genre.items.page(params[:page]).per(8)
    end
  end
  
   # キーワード検索機能
  def search
    @items = Item.search(params[:keyword]).order(created_at: :desc).page(params[:page]).per(8)
    @keyword = params[:keyword]
  end

  # 投稿データ編集
  def edit
    @item = Item.find(params[:id])
  end
  
  # 編集データ更新
  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      flash[:item_update] = "更新しました！"
      redirect_to item_path(@item)
    else
      flash[:item_updated_error] = "更新できませんでした。入力内容をご確認のうえ再度お試しください。"
      render :edit
    end
  end
  
  # 投稿削除
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to items_path
  end
  
  
  # 登録データのストロングパラメータ
  private

  def item_params
    params.require(:item).permit(:customer_id, :genre_id, :image, :name, :category, :body, :is_draft)
  end
  
end