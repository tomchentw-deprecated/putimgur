require! {
  crypto
  Binding: '../models/binding'
}

exports.create = !(req, res) ->
  const binding = req.body
  (ex, buf) <-! crypto.randomBytes 32
  throw ex if ex

  binding.token = buf.toString 'hex'
  res.json result: Binding.create binding
