class Song < ActiveRecord::Base

  has_many :rock_sessions
  belongs_to :user
  before_save :add_content_params, :if => lambda{ |obj| obj.url_changed? }

  private

  # this grabs new info from the opengraph at the provided url
  #
  # updates self with new content params parsed from the url
  def add_content_params
    begin
      url = self.url
      content = OpenGraph.fetch(url)
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
      end # end if video blank and parsing
      #return content_params
      # trying to avoid recursion...
      #self.update_attributes(content_params)
      self.assign_attributes(content_params)
      puts.self.to_yaml
    rescue
      puts "Error parsing!"
      @song = nil
    end
      
  end
end
