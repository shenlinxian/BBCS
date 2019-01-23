class RelationshipsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
  private
    # 确保用户已登录
    def logged_in_user
      unless logged_in?
        # store_location 方法中，把请求的地址存储在 session[:forwarding_url] 中
        # 当用户登录后再跳转到登录前要访问的页面
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end