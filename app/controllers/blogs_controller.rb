class BlogsController < ApplicationController
  # authenticate_user!はdive08で追記したよ。dive09でも登場した。
  before_action :authenticate_user!
  # onlyにshowアクションを追加したよ。dive15
  before_action :set_blog, only: [:show, :edit, :update, :destroy]

  # @blogs = Blog.all  記事全件を一覧表示するためよ。dive01
  def index
    @blogs = Blog.all
  end

  # showアクションを定義する。入力フォームと一覧を表示するためインスタンスを２つ生成します。
  # dive19_2でnotificationを追加したよ。
  def show
    @comment = @blog.comments.build
    @comments = @blog.comments
    Notification.find(params[:notification_id]).update(read: true) if params[:notification_id]
  end


  # if params[:back]    (name属性付きで)戻るボタン押下されて返ってきたときの挙動をif文で処理です。dive03
  # @blog = Blog.new(blogs_params)    (name属性付きなら)入力した記事をパラメータ保持で、@blogに格納するよ。dive03
  # @blog = Blog.new    こちらはまったくの新規登録導線です。
  def new
    if params[:back]
      @blog = Blog.new(blogs_params)
      @blog.user_id = current_user.id
    else
      @blog = Blog.new
    end
  end

  # render :new if @blog.invalid?    確認画面へ遷移したときのためにバリデーションを追記したよ。dive03
  #                                  バリデーションは保存したときのみ発動するので。dive03
  def confirm
    @blog = Blog.new(blogs_params)
    @blog.user_id = current_user.id
    render :new if @blog.invalid?
  end

  # Blog.create(blogs_params)
  # redirect_to blogs_path, notice: "記事を作成しました！"    一覧画面＆メッセージを表示します。
  # render action: 'new'    入力フォームを再描画します。
  # @blog.user_id = current_user.id    dive09で追記したよ。
  # NoticeMailer.sendmail_blog(@blog).deliver    dive11で追記したよ。
  def create
    @blog = Blog.new(blogs_params)
    @blog.user_id = current_user.id
    if @blog.save
      redirect_to blogs_path, notice: "記事を作成しました！"
      NoticeMailer.sendmail_blog(@blog).deliver
    else
      render action: 'new'
    end
  end

  # @blog = Blog.find(params[:id])    保存しているデータをDBから取得しているよ。dive02
  #                                   リファクタリングで省略したよ。dive02
  def edit
  end

  # @blog = Blog.find(params[:id])     # 保存しているデータをDBから取得しているよ。dive02
  # @blog.update(blogs_params)         # dive02
  # redirect_to blogs_path, notice: "記事を更新しました！"
  # @blog = Blog.find(params[:id])
  # リファクタリングで省略したよ。dive02
  def update
    if @blog.update(blogs_params)
      redirect_to blogs_path, notice: "記事を投稿(更新)しました！"
    else
      render action: 'edit'
    end
  end

  # @blog = Blog.find(params[:id])    保存しているデータをDBから取得しているよ。dive02
  # リファクタリングで省略したよ。dive02
  def destroy
    @blog.destroy
    redirect_to blog_path, notice: "記事を削除しました！"
  end


  private
    def blogs_params
      params.require(:blog).permit(:title, :content, :user_id, :name)
    end

    # idをキーとして値を取得するメソッド。リファクタリングで共通化したよ。dive02
    def set_blog
      @blog = Blog.find(params[:id])
    end

end
