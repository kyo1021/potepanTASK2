class RoomsController < ApplicationController
  before_action :set_room, only: [:edit, :update, :show, :destroy]

  def posts
    @rooms = Room.all
    @reservation = Reservation.all
  end
  
  def index
    @rooms = Room.all
  end

  def new
    @room = Room.new
  end
  
  def create
    @room = Room.new(room_params)
    
    if @room.save
      flash[:notice_success] = "ルームを新規登録しました"
      redirect_to "/rooms/posts"
    else
       flash[:notice_failure] = "ルームを新規登録できませんでした"
      render "new"
    end
  end
  
  def show
    @room = Room.find(params[:id])
    @reservation = Reservation.new
    @reservations = Reservation.where(room_id: @room.id)
  end
  
  def edit
  end
  
  def update
    if @room.update(room_params)
      flash[:notice] = "情報更新しました"
      redirect_to "/rooms/posts"
    else
      render "edit"
    end
  end
  
  def destroy
    @room.destroy
    flash[:notice_success] = "部屋情報を削除しました"
    redirect_to "/rooms/posts" 
  end
end

private

 def room_params #ストロングパラメータ
    params.require(:room).permit(:name, :introduction, :price, :address, :image)
 end

 def set_room
   @room = Room.find(params[:id])
 end
 