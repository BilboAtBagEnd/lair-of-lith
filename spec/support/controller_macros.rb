module ControllerMacros
  def setup_devise
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
  end
end

module FeatureMacros
  def setup_warden
    include Warden::Test::Helpers
    Warden.test_mode!
  end
end
