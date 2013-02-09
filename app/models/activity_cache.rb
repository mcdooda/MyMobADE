# == Schema Information
#
# Table name: activity_caches
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  date       :string(255)
#  begin_time :string(255)
#  duration   :string(255)
#  teachers   :string(255)
#  rooms      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ActivityCache < ActiveRecord::Base
  attr_accessible :begin_time, :date, :duration, :id, :name, :rooms, :teachers
  has_many :branch_activities
  has_many :branches, through: :branch_activities
end
