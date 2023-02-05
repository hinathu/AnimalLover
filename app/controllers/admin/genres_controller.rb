class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!

# ジャンル一覧、追加
  def index
    @newgenre = Genre.new
    @genres = Genre.all
  end

# ジャンル登録
  def create
    @newgenre = Genre.new(genre_params)

    if @newgenre.save
      redirect_to admin_genres_path
    else
      flash[:genre_created_error] = "ジャンル名を入力してください。"
      redirect_to
    end
  end

# ジャンル編集
  def edit
    @genre = Genre.find(params[:id])
  end

# ジャンル更新
  def update
    genre = Genre.find(params[:id])
    if genre.update(genre_params)
      redirect_to admin_genres_path
    else
      flash[:genre_created_error] = "ジャンル名を入力してください。"
      redirect_to edit_admin_genre_path(genre)
    end
  end

# ジャンル削除
  def destroy
    genre = Genre.find(params[:id])
    genre.destroy
    redirect_to admin_genres_path
  end

# 登録データのストロングパラメータ
  private

  def genre_params
    params.require(:genre).permit(:name)
  end
  
end
