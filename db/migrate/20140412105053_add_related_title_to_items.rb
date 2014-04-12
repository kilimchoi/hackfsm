class AddRelatedTitleToItems < ActiveRecord::Migration
  def change
    add_column :items, :relatedTitle, :string
    add_column :items, :identifier, :string
  end
end
