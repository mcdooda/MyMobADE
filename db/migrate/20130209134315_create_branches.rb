class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.integer :id
      t.string :name

      t.timestamps
    end
  end
end
