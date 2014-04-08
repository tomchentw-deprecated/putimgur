require! {
  request
}

exports.pipe3 = !(req, res) ->
  req
    .pipe request(req.url.replace /putimgur.com/, 'imgur.com')
    .pipe res