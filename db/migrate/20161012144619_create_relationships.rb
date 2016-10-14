class CreateRelationships < ActiveRecord::Migration
  # dive16で作成したよ。
  # そして、以下はユーザーを二度フォローできないようにするための対応ですよ。
  # add_index :relationships, [:followed_id, :followed_id], unique: true
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps null: false
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end