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
end
