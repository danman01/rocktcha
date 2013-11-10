class CreateReceivedSessions < ActiveRecord::Migration
  def change
    create_table :received_sessions do |t|
      t.string :session_id
      t.string :ip

      t.timestamps
    end
  end
end
