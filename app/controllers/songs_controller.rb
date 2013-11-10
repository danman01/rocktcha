class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :only=>[:new,:create]

  # GET /songs
  # GET /songs.json
  def index
    @songs = Song.all
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
  end

  # GET /songs/new
  def new
    @song = Song.new
  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs
  # POST /songs.json
  def create
    begin
      new_params = parse_new_song(song_params)
      new_song_params = song_params
      new_song_params.merge!(new_params) # merge in parsed params for saving
      @song = Song.new(new_song_params)
      puts "\n Song: \n #{@song.to_yaml} \n"    
      respond_to do |format|
        if @song.save
          format.html { redirect_to @song, notice: 'Song was successfully created.' }
          format.json { render action: 'show', status: :created, location: @song }
        else
          format.html { render action: 'new' }
          format.json { render json: @song.errors, status: :unprocessable_entity }
        end
      end

    rescue
      puts "Error parsing!"
      flash[:error]="There was an error!"
      @song = nil
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to @song, notice: 'Song was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:name, :url, :user_id)
    end

  def parse_new_song(params)
    content = OpenGraph.fetch(params["url"])

    content_params = build_song_params(params,content)
    return content_params
  end

  def build_song_params(params,content)
    content_params=nil    
    if !content["video"].blank? 
      case content["site_name"].downcase
      when "soundcloud"
        # change auto play to false
        content["video"] = content["video"].gsub("auto_play=true","auto_play=false")
        content["video"] = content["video"] + "&default_width=75&default_height=90"
      when "youtube"
        # do youtube stuff
      end
      # replace query string with ?wmode=opaque for all embedded content
      video_query = content["video"].match(/[?].*/).to_s rescue "" # get query string
      vid_url_old_query = video_query.gsub("?","")
      vid_url_with_new_query=content["video"].gsub(/[?].*/,"?wmode=opaque&rel=0&") # add our own params
      # rel=0 means no related vids at the end
      # opaque allows things to show ontop of embedded flash content
      video_url = vid_url_with_new_query+vid_url_old_query # replace video url with new query string + old query string
      # setup content object params from the opengraph info
      content_params={
        height: "90",
        width: "75",
        video_url: video_url,
        url: content["url"],
        image: content["image"],
        description: content["description"],
        mime_type: content["video:type"],
        title: content["title"],
        site_name: content["site_name"]
      }
    end # end VIDEO parsing
    return content_params
  end

end
