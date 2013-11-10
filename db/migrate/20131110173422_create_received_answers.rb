class CreateReceivedAnswers < ActiveRecord::Migration
  def change
    create_table :received_answers do |t|
      t.integer :rock_session_id
      t.string :answer
      t.boolean :passed
      t.string :ip

      t.timestamps
    end
  end
end
