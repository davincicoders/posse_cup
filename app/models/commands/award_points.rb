class Commands::AwardPoints < Commands::Base
  include ActionView::Helpers::TextHelper

  def response
    error_message || point_award
  end

  def error_message
    return unauthorized unless admin?
    return invalid_token unless token_valid?
    return invalid_amount unless amount_valid?
    return invalid_posse unless posse
    nil
  end

  def posse
    Rails.logger.info posse_name
    if posse_name.to_s.start_with?("<@")
      Student.find_by(slack_uid: posse_name.match(/<@(.+)>/)[1]).try(:posse)
    else
      Posse.find_by(name: posse_name)
    end
  end

  def message_parts
    Hash[[:award, :reason].zip(text.split(" for "))]
  end

  def reason
    message_parts[:reason]
  end

  def posse_name
    message_parts[:award].split(" to ")[1]
  end

  def amount
    text.split[1].to_i
  end

  def amount_valid?
    amount != 0
  end

  def invalid_amount
    {"json" => {
                "text" => "Sorry, that amount isn't valid. Please use format '#PC 30 points to Staff'"
               },
     "status" => 200
    }
  end

  def invalid_posse
    if posse_name.nil?
      {"json" => {"text" => "No posse name provided, please use format '30 points to Staff'."}, "status" => 200}
    else
      {"json" => {"text" => "Sorry, posse #{posse_name} could not be found"}, "status" => 200}
    end
  end

  def unauthorized
    { "json" => {"error" => "User not authorized."}, "status" => 401 }
  end

  def invalid_token
    { "json" => {"error" => "Invalid Token."}, "status" => 401 }
  end

  def point_award
    pa = posse.point_awards.new(amount: amount, creator: admins[uid], reason: reason)
    if pa.save
      {"json" => {"status" => "success", "current_score" => posse.current_score, "text" => success_message},
          "status" => 200}
    else
      {"json" => {"status" => "failure", "errors" => pa.errors.full_messages},
          "status" => 200}
    end
  end

  def success_message
    "#{pluralize(amount, 'point')} awarded to #{posse.name} posse! Current score: #{posse.current_score}."
  end
end
