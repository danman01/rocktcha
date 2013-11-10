class ActuallyAddSongParams < ActiveRecord::Migration
  def change
    add_column :songs, :description, :text
    add_column :songs, :site_name, :string
    add_column :songs, :video_url, :string
    add_column :songs, :audio_url, :string
    add_column :songs, :height, :string
    add_column :songs, :width, :string
    add_column :songs, :image, :string
    add_column :songs, :mime_type, :string
    add_column :songs, :title, :string
    add_index :songs, :user_id

  end
end
