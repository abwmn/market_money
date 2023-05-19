class ErrorMember
  attr_reader :message, :status, :code

  def initialize(exception)
    @message = exception.message

    case exception
    when ActiveRecord::RecordNotFound
      @status = :not_found
      @code = 404
    when ActiveRecord::RecordInvalid
      @status = :bad_request
      @code = 400
    else
      @status = :internal_server_error
      @code = 500
    end
  end
end
