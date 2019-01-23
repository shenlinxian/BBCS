class RepliesController < ApplicationController
    
    before_action :set_reply, only: [:show, :edit, :update, :destroy]
    before_action :set_artical, only: [:show, :edit, :update, :destroy]
    
    def new
    @reply = Reply.new
    end

  def index
    @replies = Reply.All
  end

  def show

  end
  
  def create
    @artical = Artical.find(params[:artical_id])
    @reply = @artical.replies.new(params[:reply].permit(:content, :artical_id))
    @reply.user_id=session[:user_id]
    @reply.save
    redirect_to artical_path(@artical)
  end
  
  def update
    respond_to do |format|
      if @reply.update(reply_params)
        format.html { redirect_to @artical, notice: 'Reply was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    Reply.find(params[:id]).destroy
    flash[:success] = "Reply deleted"
    redirect_to @artical
  end
  
  private
  
    def set_reply
        @reply = Reply.find(params[:id])
    end
    
    def set_artical
      @artical = Artical.find(@reply.artical)
    end
    
    def reply_params
        params.require(:reply).permit( :content, :user)
    end
      
end
