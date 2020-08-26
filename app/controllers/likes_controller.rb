class LikesController < ApplicationController
  before_action :set_post
  before_action :set_like, only: [:destroy]
  before_action :authenticate_user!
  before_action :authorize

  def create
    if already_liked?
      flash[:alert] = "You've already liked this!"
    else  
      @post.likes.create(like_params)
      flash[:notice] = "Post liked."
    end

    redirect_to post_path(@post)
  end

  def destroy
    if !already_liked?
      flash[:alert] = "You haven't liked this!"
    else  
      @like.destroy
      flash[:notice] = "Post unliked."
    end
    
    redirect_to post_path(@post)
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_like
      @like = Like.find(params[:id])
    end

    def like_params
      params.require(:like).permit(:user_id)
    end

    def authorize
      if current_user == @post.author
        redirect_to post_path(@post), alert: 'You cannot do that.'
      end
    end

    def already_liked?
      Like.where(user: current_user, post_id: @post.id).exists?
    end
end
