class AddTranslatorFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :translator, :boolean, null: false, default: false
    add_column :users, :known_languages, :string, limit: 255
  end
end
