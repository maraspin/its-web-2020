// Really simple snippet to show Accept / Content header usage
// before using, run: npm i fastify --save

const fastify = require('fastify')({
  logger: true
})

fastify.get('/', function (request, reply) {
  return fastify.notFound(request, reply)
})

fastify.get('/hello-world', function (request, reply) {
  
  console.log(request.headers)

  // Defaults are set
  let resource = { "reply": 'hello world' }
  let lan = 'en-CA'
  let typer = 'application/json'
  
  let languages = request.headers['accept-language'].split(",");
  console.log(languages)

  if (languages.includes("it-IT")) {
  	resource = { "reply": 'ciao mondo' }
  	lan = 'it-IT'
  }

  let type = request.headers['accept-type'];
  if (type == null) { type = '' }  

  if (type.includes("xml") && !type.includes("json")) {
  	resource = '<xml>' + resource.reply + '</xml>'
  	typer = 'text/xml'
  }
  
  console.log(resource)
  reply.header('Content-Language', lan).header('Content-Type', typer).send(resource)
})

fastify.get('/error', function (request, reply) {
  console.log(request.headers)
  reply
    .code(500)
    .header('Content-Type', 'application/json; charset=utf-8')
    .send({ hello: 'error' })
})

fastify.decorate('notFound', (request, reply) => {
  reply.code(404).type('text/html').send('Not Found')
})


fastify.listen(9000, '0.0.0.0', function (err, address) {
  if (err) {
    fastify.log.error(err)
    process.exit(1)
  }
  fastify.log.info(`server listening on ${address}`)
})
