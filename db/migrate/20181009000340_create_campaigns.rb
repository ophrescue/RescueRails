class CreateCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns do |t|
      t.string :title
      t.integer :goal
      t.text :summary
      t.integer :created_by_user_id
      t.text :description
      t.string :primary_photo_file_name
      t.string :primary_photo_content_type
      t.integer :primary_photo_file_size
      t.datetime :primary_photo_updated_at
      t.string :left_photo_file_name
      t.string :left_photo_content_type
      t.integer :left_photo_file_size
      t.datetime :left_photo_updated_at
      t.string :middle_photo_file_name
      t.string :middle_photo_content_type
      t.integer :middle_photo_file_size
      t.datetime :middle_photo_updated_at
      t.string :right_photo_file_name
      t.string :right_photo_content_type
      t.integer :right_photo_file_size
      t.datetime :right_photo_updated_at
      t.timestamps
    end
  end
end
