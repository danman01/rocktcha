class RootController < ApplicationController
  def splash
    # user can submit to this url to enter a rockTCHA challenge based on their session
    @receivedsesh = ReceivedSession.find_or_create_by(:session_id=>request.session_options[:id],:ip=>request.remote_ip)
    # their session is then attached to a random song
    size = Song.all.size
    first_id = Song.first.id
    # assuming there's no gaps in song ids...
    num = rand(first_id..((first_id-1) + size))
    song = Song.find(num)

    @rocksesh = song.rock_sessions.create(:received_session_id=>@receivedsesh.id)
    # the user submits a form (rock answer) that must match the name of the song.
    @rockanswer = @rocksesh.received_answers.build()
    # if the user reloads the page with the same session, a new rocksesh is generated for that session
  end

  def not_passed
    @song = Song.find_by(id: params[:song_id])
  end

  def passed
    @song = Song.find_by(id: params[:song_id])    
    @tickets = params[:tickets]
  end

  def incoming_challenge
    # user can submit to this url to enter a rockTCHA challenge based on their session
    @receivedsesh = ReceivedSession.find_or_create_by(:session_id=>params[:session_id],:ip=>request.remote_ip)
    # their session is then attached to a random song
    size = Song.all.size
    first_id = Song.first.id
    # assuming there's no gaps in song ids...
    num = rand(first_id..((first_id-1) + size))
    song = Song.find(num)

    @rocksesh = song.rock_sessions.create(:received_session_id=>@receivedsesh.id)
    # the user submits a form (rock answer) that must match the name of the song.
    @rockanswer = @rocksesh.received_answers.build()
    # if the user reloads the page with the same session, a new rocksesh is generated for that session
  end

  def incoming_answer
    # user can submit to this url to enter a rockTCHA challenge based on their session
    @receivedsesh = ReceivedSession.find_by(:session_id=>params[:session_id],:ip=>request.remote_ip)
    @rocksesh = @receivedsesh.rock_sessions.last
    @received_answer = ReceivedAnswer.new(:rock_session_id=>@rocksesh.id,:answer=>params[:answer])
    if @received_answer.answer.downcase == @rocksesh.song.name.downcase
      @received_answer.passed = true
    else
      @received_answer.passed = false
    end
    @received_answer.passed ? @response = 1 : @response = 0
    #respond_to do |format|
    #  if @received_answer.save
    #    if @received_answer.passed
    #      # took out &tickets=#{params[:tickets]}
    #      format.html { redirect_to "/remote_passed?song_id=#{@rocksesh.song.id}", notice: "You passed! Continue with your purchase" }
    #    else
    #      format.html { redirect_to "/remote_not_passed?song_id=#{@rocksesh.song.id}", notice: "You did not pass. Maybe you shouldn't be here" }
    #    end
    #  else
    #    format.html { render action: 'new' }
    #    format.json { render json: @received_answer.errors, status: :unprocessable_entity }
    #  end
    #end

  end

  def remote_passed
    @response = 1
  end

  def remote_not_passed
    @response = 0
  end
end
