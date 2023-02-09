class ErrorSerializer
  def self.error_json(error)
    {
      message: "The query could not be completed",
      errors: [error.message]
    }
  end

  def self.empty_database_error
    {
      message: "The query could not be completed",
      errors: ["There are no merchants in the database"]
    }
  end

  def self.query_error
    {
      data: {}
    }
  end
end