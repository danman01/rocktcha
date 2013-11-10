json.array!(@songs) do |song|
  json.extract! song, :name, :url, :user_id
  json.url song_url(song, format: :json)
end
