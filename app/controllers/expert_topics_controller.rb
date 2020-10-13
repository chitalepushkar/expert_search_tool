class ExpertTopicsController < ApplicationController
  before_action :set_expert_topic, only: [:show, :update, :destroy]
  before_action :check_expert_params, only: [:expert_search]

  # GET /expert_topics
  # GET /expert_topics.json
  def index
    @expert_topics = ExpertTopic.all
  end

  # GET /expert_topics/1
  # GET /expert_topics/1.json
  def show
  end

  # POST /expert_topics
  # POST /expert_topics.json
  def create
    @expert_topic = ExpertTopic.new(expert_topic_params)

    if @expert_topic.save
      render :show, status: :created, location: @expert_topic
    else
      render json: @expert_topic.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /expert_topics/1
  # PATCH/PUT /expert_topics/1.json
  def update
    if @expert_topic.update(expert_topic_params)
      render :show, status: :ok, location: @expert_topic
    else
      render json: @expert_topic.errors, status: :unprocessable_entity
    end
  end

  # DELETE /expert_topics/1
  # DELETE /expert_topics/1.json
  def destroy
    @expert_topic.destroy
  end

  def expert_search
    result = ExpertTopic.expert_search(params[:user_id], params[:query])
    render json: result, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expert_topic
      @expert_topic = ExpertTopic.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def expert_topic_params
      params.require(:expert_topic).permit(:user_id, :topic)
    end

    def check_expert_params
      if params[:user_id].blank? || params[:query].blank?
        render json: {message: 'Please enter user_id and search query'}, status: :bad_request
        return
      end
    end
end
