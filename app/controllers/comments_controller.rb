class CommentsController < ApplicationController
  # コメントを保存、投稿するためのアクション。dive15で追記したよ
  def create
    # ログインユーザーに紐付けてインスタンス生成するため、buildメソッドを使用使用します。
    @comment = current_user.comments.build(comment_params)
    @blog = @comment.blog
    @notification = @comment.notifications.build(user_id: @blog.user.id)
    
    # クライアント要求に応じて、フォーマットを変更します。
    respond_to do |format|
      if @comment.save
        # dive19_2コメント機能ですよ。
        unless @comment.blog.user_id == current_user.id
          Pusher.trigger("user_#{@comment.blog.user_id}_channel", 'comment_created', { message: 'あなたの作成したブログにコメントが付きました。' })
        end
        Pusher.trigger("user_#{@comment.blog.user_id}_channel", 'notification_created', {
          uncreated_count: Notification.where(user_id: @comment.blog.user.id).count
          })
        format.html { redirect_to blog_path(@blog), notice: 'コメントを投稿しました'}
        format.json { render :show, status: :created, location: @comment }
        # js形式でレスポンスを返します。
        format.js { render :index }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        # js形式でレスポンスを返します。
        format.js { render :index }
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
