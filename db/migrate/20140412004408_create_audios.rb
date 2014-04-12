class CreateAudios < ActiveRecord::Migration
  def change
    create_table :audios do |t|
      t.string :url
      t.string :filename
      t.integer :audio_id
      t.timestamps
    end
  end
end
