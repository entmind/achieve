class CommentsController < ApplicationController
  # コメントを保存、投稿するためのアクション。dive15で追記したよ
  def create
    # ログインユーザーに紐付けてインスタンス生成するため、buildメソッドを使用使用します。
    @comment = current_user.comments.build(comment_params)
    @blog = @comment.blog
    
    # クライアント要求に応じて、フォーマットを変更します。
    respond_to do |format|
      if @comment.save
        format.html { redirect_to blog_path(@blog), notice: 'コメントを投稿しました'}
      else
        format.html { render :new }
      end
    end
  end
  
  private
    # ストロングパラメーター
    def comment_params
      params.require(:comment).permit(:blog_id, :content)
    end
end
