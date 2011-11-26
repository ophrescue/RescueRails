class RenameConnectionAdoption < ActiveRecord::Migration
    def change
        rename_table :connections, :adoptions
    end 
end
