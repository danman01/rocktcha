class RootController < ApplicationController
  layout :false, :only=>[:incoming_answer,:incoming_challenge]
  protect_from_forgery :except => [:incoming_answer]

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

  # can also have a :username param after the session id. so, /challange/session_id/username (pulls from username songs) OR /challange/session_id (pulls from ALL songs)
  def incoming_challenge
    # user can submit to this url to enter a rockTCHA challenge based on their session
    @receivedsesh = ReceivedSession.find_or_create_by(:session_id=>params[:session_id],:ip=>request.remote_ip)
    # their session is then attached to a random song
    # If params :username is available, only search for songs created by that username
    if params[:username]
      user = User.find_by(username: params[:username])
    else
      user = nil
    end
    # is there a user? if so get songs by user
    user ? songs = user.songs : songs = Song.all
    #size = songs.size
    song_ids = songs.map(&:id)
    #first_id = songs.first.id rescue nil # incase no songs have been created by the user...
    unless song_ids.empty?
      # assuming there's no gaps in song ids...
      num = song_ids.sample # gets random item from array - ensures there is an id in the following find 
      song = Song.find(num)

      @rocksesh = song.rock_sessions.create(:received_session_id=>@receivedsesh.id)
      # the user submits a form (rock answer) that must match the name of the song.
      @rockanswer = @rocksesh.received_answers.build()
      # if the user reloads the page with the same session, a new rocksesh is generated for that session
    else
      puts "No songs created yet!"
      flash[:notice]="No songs created yet!"
    end
  end

  def incoming_answer
    # user can submit to this url to enter an answer to a rockTCHA challenge based on their session (user provided unique value)
    @receivedsesh = ReceivedSession.find_by(:session_id=>params[:session_id],:ip=>request.remote_ip)
    # this allows user to reload the challenge and be able to submit an answer that matches the last generated sesh
    @rocksesh = @receivedsesh.rock_sessions.last
    # build object for the answer
    @received_answer = ReceivedAnswer.new(:rock_session_id=>@rocksesh.id,:answer=>params[:answer])
    if @received_answer.answer.downcase == @rocksesh.song.name.downcase
      @received_answer.passed = true
    else
      @received_answer.passed = false
    end
    @received_answer.passed ? @response = 1 : @response = 0
  end

  def remote_passed
    @response = 1
  end

  def remote_not_passed
    @response = 0
  end
end
