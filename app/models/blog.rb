class Blog < ActiveRecord::Base
    validates :title, presence: true    # dive02で追記したよ。

    belongs_to :user
    # dive15で追記したよ。「dependent: :destroy」は、Blogモデルが削除されたら紐づくコメントも削除する。
    has_many :comments, dependent: :destroy
end
