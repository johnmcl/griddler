require 'iconv'

class Griddler::Email
  attr_accessor :to, :from, :body, :user, :comment

  def initialize(params)
    if params[:to]
      @to = extract_address(params[:to], config.to)
    end

    if params[:from]
      @from = extract_address(params[:from], :email)
    end

    @subject = params[:subject]

  end

  private

  def extract_address(address, type)
    parsed = EmailParser.parse_address(address)
    if type == :hash
      parsed
    else
      parsed[type]
    end
  end

  def extract_body(body_text)
    if params[:charsets]
      charsets = ActiveSupport::JSON.decode(params[:charsets])
      body_text = Iconv.new('utf-8', charsets['text']).
        iconv(body_text)
    end

    @body = EmailParser.extract_reply_body(text)
  end

  def config
    Griddler.configuration
  end
end
