class ErrorSerializer
  include JSONAPI::Serializer

  def initialize(error_object)
    @error_object = error_object
  end

  def serializer_validation
    {
      errors: [
        {
          details: @error_object.message
        }
      ]
    }
  end
end
