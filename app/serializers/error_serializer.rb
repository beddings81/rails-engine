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
      errors: ["The database is empty"]
    }
  end

  def self.query_error
    {
      data: {}
    }
  end

  def self.price_error
    {
      errors: {}
    }
  end
end