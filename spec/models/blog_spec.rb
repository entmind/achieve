require 'rails_helper'

describe Blog do
	# タイトルと内容が存在すれば有効な状態であること。
	it "is valid with title" do
		blog = Blog.new(title: 'titletestあいうえお', content: 'contenttestあいうえお')
		expect(blog).to be_valid
	end

	# タイトルが存在しなければ無効であること。
	it "is invalid without a title" do
		blog = Blog.new
		expect(blog).not_to be_valid
	end

	# タイトルが存在しなければ無効であること。
	it "is valid with title" do
		blog = Blog.new
		blog.valid?
		expect(blog.errors[:title]).to include("を入力してください")
	end
end
