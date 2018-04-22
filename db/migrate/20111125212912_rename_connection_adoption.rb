class RenameConnectionAdoption < ActiveRecord::Migration[4.2]
    def change
        rename_table :connections, :adoptions
    end
end
