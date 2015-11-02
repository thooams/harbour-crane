class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name
      t.text   :ports
      t.text   :volumes
      t.string :slug
      t.integer :state, default: App.states[:stopped]
      t.string :author
      t.text   :description
      t.string :image
      t.integer:category, default: App.categories[:web]
      t.string :virtual_host

      t.timestamps null: false
    end
  end
end
