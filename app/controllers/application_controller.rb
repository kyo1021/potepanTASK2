class ApplicationController < ActionController::Base
before_action :configure_permitted_parameters, if: :devise_controller?
#before_action :authenticate_user!, only: [:room_search]
before_action :room_search

def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :image])
    devise_parameter_sanitizer.permit(:account_update, keys: [:image, :profile])
end

  def room_search
    if params[:q].present?
      @search_r = Room.ransack(params[:q])
      @search_rooms = @search_r.result
    else
      params[:q] = { sorts: 'id desc' }
      @search_r = Room.ransack(params[:q])
      @search_rooms = @search_r.result
    end
  end
  
  def search_params
    params.require(:q).permit(:sorts)
  end
  
end
