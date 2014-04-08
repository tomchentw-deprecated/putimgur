require! {
  buffertools
  through2
  request
}
buffertools.extend!

require! {
  Binding: '../models/binding'
}

function makeObject (token)
  token: token
  tokenBuf: new Buffer token
  tokenSwapped: false
  cache: void

const swapToken = !(object, chunk, enc, callback) -->
  if Buffer.isBuffer object.cache
    chunk = Buffer.concat [object.cache, chunk]
    object.cache = void
  const index = chunk.indexOf object.tokenBuf
  if -1 is index
    if object.tokenSwapped
      @push chunk
    else
      object.cache = chunk
    callback!
    return

  object.tokenSwapped = true

  ({albumDeleteHash}) <~! Binding.find where: object{token} .success
  @push chunk.slice 0, index
  @push new Buffer albumDeleteHash
  @push chunk.slice index+object.tokenBuf.length
  callback!

exports.pipe3 = !(req, res) ->
  res.json error: 'DELETE not passed' if 'DELETE' is req.method

  const token = (req.header 'Replacement' or '' ).match /^Token (\S+)/ .1
  const options = do
    url: "https://api.imgur.com/3/#{ req.originalUrl.replace /^\/3\//, '' }"
    method: req.method
    headers: do
      Authorization: req.header 'Authorization'
      'Content-Type': req.header 'Content-Type'

  req
    .pipe through2(allowHalfOpen: false, swapToken makeObject(token))
    .pipe request(options)
    .pipe res