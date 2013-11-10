class AddSongParams < ActiveRecord::Migration
  def change
    change_table :songs do |t|
      t.string :item
      t.text :description
      t.boolean :is_preview
      t.string :site_name
      t.string :kind
      t.string :url
      t.string :video_url
      t.string :audio_url
      t.string :height
      t.string :width
      t.string :image
      t.string :mime_type

    end
    add_index :songs, :user_id
  end
end
