class Relationship < ActiveRecord::Base
  # dive16で作成したよ。
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end
