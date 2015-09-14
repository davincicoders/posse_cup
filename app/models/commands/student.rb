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
    if text =~ /#pc Add student (.*) \((.*)\) to the (.*) posse/i
      student_name = $1
      student_login = $2
      posse_name = $3
      slack_login = student_login.match(/\@(\w+)/)[1]
      Rails.logger.info "Name: #{student_name}, #{student_login}, #{slack_login}, #{posse_name}"
      posse = Posse.where(name: posse_name).first_or_create
      Student.where(slack_uid: slack_login).first_or_create do |student|
        student.name = student_name
        student.posse = posse
      end
      {"json" => {"status" => "200", "text" => "#{student_name} added to the #{posse.name} posse."}}
    else
      {"json" => {"status" => "200", "text" => "Try: #pc Add student Joe Smith (@joesmith) to the Foo posse"}}
    end
  end

  def success_message
    "#{pluralize(amount, 'point')} awarded to #{posse.name} posse! Current score: #{posse.current_score}."
  end
end
