class Commands::Base
  attr_reader :text, :options
  def initialize(text, options = {})
    @text = text
    @options = ActiveSupport::HashWithIndifferentAccess.new(options)
  end

  def response
    {}
  end

  def uid
    options["user_id"]
  end

  def admin?
    uid.present? && admins.keys.include?(uid)
  end

  def token_valid?
    options["token"] == ENV["SLACK_AUTH_TOKEN"]
  end

  def admins
    {"U04TJHSHZ" => "Rebecca", "U03GQCTPX" => "Jason", "U03GR2VRX" => "Wendy"}
  end
end
