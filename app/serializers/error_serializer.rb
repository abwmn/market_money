class ErrorSerializer
  def initialize(error_member)
    @error_member = error_member
  end

  def serialized_json
    {
      errors: 
      [
        status: @error_member.status,
        message: @error_member.message,
        code: @error_member.code
      ]
    }
  end
end
