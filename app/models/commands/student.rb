class Commands::Student < Commands::Base
  include ActionView::Helpers::TextHelper

  def response
    error_message || create_student
  end

  def error_message
    return unauthorized unless admin?
    return invalid_token unless token_valid?
    nil
  end

  def unauthorized
    { "json" => {"error" => "User not authorized."}, "status" => 401 }
  end

  def invalid_token
    { "json" => {"error" => "Invalid Token."}, "status" => 401 }
  end

  def create_student
    if text =~ /#pc Add student (.*) \(\@.*\) to the (.*) posse/i
      student_name = $1
      student_login = $2
      posse_name = $3
      Rails.logger.info "Name: #{student_name}, #{student_login}, #{posse_name}"
    end
    # if pa.save
    #   {"json" => {"status" => "success", "current_score" => posse.current_score, "text" => success_message},
    #       "status" => 200}
    # else
    #   {"json" => {"status" => "failure", "errors" => pa.errors.full_messages},
    #       "status" => 200}
    # end
    {"json" => {"status" => "200", "text" => "Um, ok"}}
  end

  def success_message
    "#{pluralize(amount, 'point')} awarded to #{posse.name} posse! Current score: #{posse.current_score}."
  end
end
