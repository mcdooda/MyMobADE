# == Schema Information
#
# Table name: branches
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Branch < ActiveRecord::Base
  attr_accessible :id, :name
  has_many :branch_activities
  has_many :activity_caches, through: :branch_activities, source: :activity_cache
end
