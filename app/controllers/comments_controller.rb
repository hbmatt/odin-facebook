class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, only: [:edit, :update, :destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.post_id = params[:post_id]

    if @comment.save
      redirect_to post_path(@comment.post)
    else
      @post = @comment.post
      render 'post/show'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @post = Post.find(params[:post_id])
  end

  def update
    @comment = Comment.find(params[:id])
    @post = Post.find(params[:post_id])
    
    if @comment.update(comment_params)
      redirect_to post_path(@comment.post)
    else
      render :edit
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @comment.destroy

    redirect_to post_path(@post)
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end

    def authorize
      @comment = Comment.find(params[:id])
      unless current_user == @comment.author
        redirect_to post_path(@comment.post), alert: 'You cannot do that.'
      end
    end
end
