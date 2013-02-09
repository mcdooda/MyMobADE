class CreateActivityCaches < ActiveRecord::Migration
  def change
    create_table :activity_caches do |t|
      t.integer :id
      t.string :name
      t.string :date
      t.string :begin_time
      t.string :duration
      t.string :teachers
      t.string :rooms

      t.timestamps
    end
  end
end
