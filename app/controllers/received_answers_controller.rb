class ReceivedAnswersController < ApplicationController
  def new
  end

  def create
    @received_answer = ReceivedAnswer.new(received_answer_params)
    @rocksesh = @received_answer.rock_session 
    if params[:received_answer][:answer].downcase == @rocksesh.song.name.downcase
      @received_answer.passed = true
    else
      @received_answer.passed = false
    end
    respond_to do |format|
      if @received_answer.save
        format.html { redirect_to root_url, notice: "Passed? #{@received_answer.passed ? true: false}!" }
        format.json { render action: 'show', status: :created, location: @received_answer }
      else
        format.html { render action: 'new' }
        format.json { render json: @received_answer.errors, status: :unprocessable_entity }
      end
    end

  end

  def show
  end

  def index
  end

  private
  def received_answer_params
    params.require(:received_answer).permit(:answer,:rock_session_id)
  end
end
