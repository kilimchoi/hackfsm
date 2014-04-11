class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :creator
      t.string :title
      t.string :typeOfResource
      t.string :dateCreated
      t.text :notes
      t.string :url
      t.timestamps
    end
  end
end
