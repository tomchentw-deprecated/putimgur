require! {
  './server'
}
require! {
  '../controllers/binding'
  '../controllers/index'
}

server.post '/api/1/bindings' binding.create

server.post '/3/*' index.pipe3
