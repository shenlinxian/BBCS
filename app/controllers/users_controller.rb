class UsersController < ApplicationController

  # 对指定的请求要求用户已登录
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  # 只能对自己的账号进行操作
  before_action :correct_user,   only: [:edit, :update]
  # 限制只有管理员才能访问 destroy 动作。我们要定义一个名为 admin_user 的事前过滤器
  before_action :admin_user,     only: [:destroy, :index,:search]

  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def search
    @name = params[:search]
    @users = User.paginate_by_sql("select * from users where name like '"+ @name +"%'", page: params[:page])
    render "index"
  end


  def show
    # params[:id] 会返回用户的 ID
    @user = User.find(params[:id])

    @articals=Artical.paginate_by_sql("select * from articals where user="+params[:id], page: params[:page])



    # 可以在控制台进入debug模式
    #debugger
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # 注册成功，直接登录用户
      log_in @user
      # 处理注册成功的情况, 显示注册成功
      flash[:success] = "Welcome to the Sample App!"
      # 重定向到 user_url(@user)
      redirect_to @user
    else
      render 'new'
    end
  end

  # 编辑个人资料
  def edit
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # 处理更新成功的情况
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  # 关注功能
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    # 健壮参数
    # 只允许通过请求传入可安全编辑的属性
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :picture)
  end

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

  # 确保是正确的用户
  def correct_user
    @user = User.find(params[:id])
    # 使用user_helper里的方法，判断已登录用户和要操作的用户是否一致
    # redirect_to(root_url) unless current_user?(@user)
  end

  # 确保是管理员
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
