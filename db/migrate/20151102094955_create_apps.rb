class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name
      t.text   :ports
      t.text   :volumes
      t.string :slug
      t.string :state, default: :stopped #App::STOPPED
      t.string :author
      t.text   :description
      t.string :image
      t.string :app_type
      t.string :virtual_host

      t.timestamps null: false
    end
  end
end
