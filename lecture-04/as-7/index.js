// Simple snippet to show Content negotiation and basic DRY
// Not a perfect clean piece of code; just an example to be used during class
const path = require('path')
const fs = require('fs');
 
const fastify = require('fastify')({
  logger: true
})
fastify.register(require('fastify-static'), {
  root: path.join(__dirname, 'uploads'),
  prefix: '/uploads/',
})

// Default route - redirects to most appropriate 
fastify.get('/', function (request, reply) {
  return reply.redirect(301,'/view');
})

fastify.get('/uploads/excellent.jpg', function (request, reply) {
  return reply.sendFile('excellent.jpg');
})

// Actual routes - there's still too much logic (2 same exact calls at every route)
// DRY violation - not good - fixing is up to you
fastify.get('/view', function (request, reply) {
  responseContent = "<html><title>Test</title><body><h1>My image</h1><img src=\"/uploads/excellent.jpg\"></body></html>";
  reply.type('text/html').send(responseContent)
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