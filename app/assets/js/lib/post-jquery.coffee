$.post = (url, data, callback) ->

  # omitted data argument
  if $.isFunction(data)
    callback = data
    data = { }

  $.ajax
    type: 'POST',
    url: url,
    data: data,
    success: callback,
    dataType: 'json',
    contentType:'application/json; charset=utf-8'
