class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:edit, :update, :destroy, :show]
  before_action :check_if_friends, only: [:show]
  before_action :authorize, only: [:edit, :update, :destroy]
  
  def index
    @posts = Post.where(author: current_user).or(Post.where(author: current_user.active_friends)).order("created_at DESC")
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
    @comment = current_user.comments.build
    @like = current_user.likes.build
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to post_path(@post), notice: 'Post succesfully created.'
    else
      render :new, alert: 'Please check your errors.'
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: 'Post succesfully updated.'
    else
      render :edit, alert: 'Please check your errors.'
    end
  end

  def destroy
    @post.destroy

    redirect_to posts_path, notice: 'Post succesfully deleted.'
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:content)
    end

    def authorize
      unless current_user == @post.author
        redirect_to posts_path, alert: 'You cannot do that.'
      end
    end

    def check_if_friends
      unless current_user.active_friends.include?(@post.author) || current_user == @post.author
        redirect_to posts_path, alert: 'You cannot do that.'
      end
    end
end
