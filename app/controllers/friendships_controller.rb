class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize, except: [:index, :destroy]

  def index
    @user = User.find(params[:user_id])
    @friends = @user.active_friends
  end

  def pending
    @user = User.find(params[:user_id])
    @sent_requests = @user.pending_friendships
    @received_requests = @user.pending_received_friendships
  end

  def new
    @friendship = current_user.friendships.build
  end
  
  def create
    @friendship = current_user.friendships.build(friendship_params)

    if @friendship.save
      redirect_to pending_friendships_path(current_user), notice: 'Friend request sent.'
    else
      redirect_back(fallback_location: users_path, alert: 'Friend request could not be sent.')
    end
  end

  def accept
    @friendship = current_user.friendships.build(friendship_params)

    @friendship.save
    redirect_to user_friendships_path(current_user), notice: 'Friend request accepted.'
  end

  def destroy
    @friendship = Friendship.find(params[:id])

    if @friendship.is_mutual
      @friend = @friendship.friend
      @mutual_friendship = @friend.friends.find(current_user)

      @friendship.destroy
      @mutual_friendship.destroy
      flash[:alert] = "Friend deleted."
    else
      @friendship.destroy
      flash[:alert] = "Friend request deleted."
    end

    redirect_to user_friendships_path(current_user)
  end

  private
    def friendship_params
      params.require(:friendship).permit(:friend_id)
    end

    def authorize
      @user = User.find(params[:user_id])
      unless current_user == @user
        redirect_to user_friendships_path(@user), alert: 'You cannot do that.'
      end
    end
end
