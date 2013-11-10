class CreateRockSessions < ActiveRecord::Migration
  def change
    create_table :rock_sessions do |t|
      t.belongs_to :received_session
      t.belongs_to :song

      t.timestamps
    end
  end
end
