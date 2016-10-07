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
        format.json { render :show, status: :created, location: @comment }
        # js形式でレスポンスを返します。
        format.js { render :index }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    render :index
  end
  
  private
    # ストロングパラメーター
    def comment_params
      params.require(:comment).permit(:blog_id, :content, :id)
    end
end
