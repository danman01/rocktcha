class UsersController < ApplicationController
  
  def update
    @user = User.find_by(id: params[:id])
    respond_to do |format|
    
      if @user.update(user_params)
        format.html { redirect_to "/songs/by_user/#{@user.username}", notice: "Song(s) added!"}
      
      else
        format.html { redirect_to "/songs/by_user/#{@user.username}", notice: "Problem adding songs!"}
        
      end
    end
  end

  private

    def user_params
      params.require(:user).permit({:songs_attributes=>[:id,:name,:url,:user_id,:_destroy]})
    end
end
