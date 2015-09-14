#render Commands.parse(params[:text], params.slice(:token, :uid)).response
module Commands
  def self.parse(message_text, options={})
    case message_text.downcase
    when /#pc (-?\w+) point/
      Commands::AwardPoints.new(message_text, options)
    when /#pc standings/
      Commands::Standings.new(message_text, options)
    when /#pc add student/
      Commands::Student.new(message_text, options)
    else
      Commands::Invalid.new(message_text, options)
    end
  end
end
