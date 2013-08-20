module ControllerMacros
  def setup_devise
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
  end
end
