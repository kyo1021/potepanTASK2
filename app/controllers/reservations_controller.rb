class ReservationsController < ApplicationController
  before_action :login_required, only: %i[new create created posts]

  def new
    # レンダリング時に画面の描画に必要なインスタンス変数の設定
    room_id = params[:reservation][:room_id]
    @room = Room.find_by(id: room_id)
    @user = @room.user
    @reservation = Reservation.new(reservation_params)
    render 'rooms/reserve' and return if validate_params_for_sereserve == false

    # /serervation/new画面で必要なインスタンス変数の設定
    @days_of_use = (params[:reservation][:end_date].to_date - params[:reservation][:start_date].to_date).to_i + 1
    @reservation[:sum_of_fee] = calculate_sum_of_fee(
      room_id: @room.id,
      start_date: params[:reservation][:start_date],
      end_date: params[:reservation][:end_date]
    )
  end

  def create
    params[:reservation][:sum_of_fee] = calculate_sum_of_fee(
      room_id: params[:reservation][:room_id],
      start_date: params[:reservation][:start_date],
      end_date: params[:reservation][:end_date]
    )
    params[:reservation][:user_id] = current_user.id
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      flash.notice = 'Reservation was successfully created.'
      redirect_to created_reservation_path(@reservation.id)
    else
      # レンダリング時に画面の描画に必要なインスタンス変数の設定
      @room = Room.find_by(id: @reservation.room_id)
      @days_of_use = (@reservation.end_date.to_date - @reservation.start_date.to_date).to_i + 1
      render :new
    end
  end

  def created
    @reservation = Reservation.find_by(id: params[:id])
    @room = @reservation.room
  end
  
  def index
    @reservations = Reservation.all
  end

  def posts
    @reservations = current_user.reservations
    # @rooms = @reservations.rooms
  end

  private

  def validate_params_for_sereserve
    @reservation = Reservation.new(reservation_params)
    @reservation.user_id = current_user.id
    @reservation.valid?
  end

  def calculate_sum_of_fee(room_id:, start_date:, end_date:)
    days_of_use = (end_date.to_date - start_date.to_date).to_i + 1
    room = Room.find_by(id: room_id)
    fee_per_a_day = room.fee
    days_of_use * fee_per_a_day
  end

  def reservation_params
    params.required(:reservation).permit(:start_date, :end_date, :num_of_people, :user_id, :room_id, :sum_of_fee)
  end
end
