class ValidationError extends Error
  constructor: (@field, @message) ->

@ValidationError = ValidationError
