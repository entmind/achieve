require 'rails_helper'

describe Contact do
  # name,email,contentがあれば有効な状態であること。
	it "is valid with name, email, content" do
		contact = Contact.new(name: 'nametestあいうえお', email: 'emailtest@abcde.com', content: 'contenttestあいうえお')
		expect(contact).to be_valid
	end

  # nameがなければ無効であること。
	it "is invalid without a name" do
		contact = Contact.new
		expect(contact).not_to be_valid
	end

  # nameがなければ無効であること。
	it "is valid with name" do
		contact = Contact.new
		contact.valid?
		expect(contact.errors[:name]).to include("を入力してください")
	end
	# emailがなければ無効であること。
	it "is valid with email" do
		contact = Contact.new
		contact.valid?
		expect(contact.errors[:email]).to include("を入力してください")
	end
	# nameがなければ無効であること。
	it "is valid with content" do
		contact = Contact.new
		contact.valid?
		expect(contact.errors[:content]).to include("を入力してください")
	end
end
