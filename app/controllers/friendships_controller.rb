class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:show, :update, :destroy]

  # GET /friendships
  # GET /friendships.json
  def index
    @friendships = Friendship.all
  end

  # GET /friendships/1
  # GET /friendships/1.json
  def show
  end

  # POST /friendships
  # POST /friendships.json
  def create
    @friendship = Friendship.new(friendship_params)

    if @friendship.save
      render :show, status: :created, location: @friendship
    else
      render json: @friendship.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /friendships/1
  # PATCH/PUT /friendships/1.json
  def update
    if @friendship.update(friendship_params)
      render :show, status: :ok, location: @friendship
    else
      render json: @friendship.errors, status: :unprocessable_entity
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    @friendship.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friendship
      @friendship = Friendship.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def friendship_params
      params.require(:friendship).permit(:request_sender_id, :request_receiver_id)
    end
end
