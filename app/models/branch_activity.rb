# == Schema Information
#
# Table name: branch_activities
#
#  id                :integer          not null, primary key
#  branch_id         :integer
#  activity_cache_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class BranchActivity < ActiveRecord::Base
  attr_accessible :activity_cache_id, :branch_id
  belongs_to :activity_cache
  belongs_to :branch
end
