class Public::CommentsController < ApplicationController
  
  def create
    item = Item.find(params[:item_id])
    comment = current_customer.comments.new(comment_params)
    comment.item_id = item.id
    comment.save
    redirect_to item_path(item)
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to item_path(params[:item_id])
  end

  # 登録データのストロングパラメータ
  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
  
end
