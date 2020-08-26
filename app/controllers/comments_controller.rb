class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authorize, only: [:edit, :update, :destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.post_id = params[:post_id]

    if @comment.save
      redirect_to post_path(@comment.post), notice: 'Comment successfully created.'
    else
      @post = @comment.post
      render 'post/show', alert: 'Please check your errors.'
    end
  end

  def edit
    @post = Post.find(params[:post_id])
  end

  def update
    @post = Post.find(params[:post_id])
    
    if @comment.update(comment_params)
      redirect_to post_path(@comment.post), notice: 'Comment successfully updated.'
    else
      render :edit, alert: 'Please check your errors.'
    end
  end

  def destroy
    @post = @comment.post
    @comment.destroy

    redirect_to post_path(@post), notice: 'Comment successfully deleted.'
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end

    def authorize
      unless current_user == @comment.author
        redirect_to post_path(@comment.post), alert: 'You cannot do that.'
      end
    end
end
