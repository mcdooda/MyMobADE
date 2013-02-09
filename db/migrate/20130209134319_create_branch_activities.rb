class CreateBranchActivities < ActiveRecord::Migration
  def change
    create_table :branch_activities do |t|
      t.integer :branch_id
      t.integer :activity_cache_id

      t.timestamps
    end
  end
end
