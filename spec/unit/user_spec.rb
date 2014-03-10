require_relative '../test_helper.rb'

describe 'User' do

  describe '#image_url' do
    it 'should produce the right image link' do
      user = User.new(username: 'vise890@gmail.com')
      expect(user.image_url).to eq("http://www.gravatar.com/avatar/8d6f61601881ec2f053899a7732c59ba")
    end
  end

end
