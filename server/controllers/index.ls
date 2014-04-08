require! {
  request
}

exports.pipe3 = !(req, res) ->
  const newUrl = "https://api.imgur.com/3/#{ req.originalUrl.replace /^\/3\//, '' }"
  req
    .pipe request[req.method.toLowerCase!](newUrl)
    .pipe res