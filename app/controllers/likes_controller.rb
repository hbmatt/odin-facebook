class LikesController < ApplicationController
  before_action :set_post
  before_action :set_like, only: [:destroy]
  before_action :authenticate_user!
  before_action :authorize

  def create
    if already_liked?
      
    else  
      @post.likes.create(like_params)
    end

    redirect_to post_path(@post)
  end

  def destroy
    if !already_liked?
      
    else  
      @like.destroy
    end
    
    redirect_to post_path(@post)
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_like
      @like = @post.likes.where(user: current_user)
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
