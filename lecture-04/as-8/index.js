// Simple snippet to show Content negotiation and basic DRY
// Not a perfect clean piece of code; just an example to be used during class
const path = require('path')
const fs = require('fs');
const fileUpload = require('fastify-file-upload')
 
const fastify = require('fastify')({
  logger: true
})
fastify.register(fileUpload)
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
  responseContent = "<html><title>Test</title><body><h1>My image</h1><img src=\"/uploads/excellent.jpg\"><br><br><a href=\"/upload\">Update image</a></body></html>";
  reply.type('text/html').send(responseContent)
})

fastify.get('/upload', function (request, reply) {
  let out = '<form action="/process" method="post" enctype="multipart/form-data">' + 
            '<input type="file" name="immagine"><br>' + '<input type="submit">' +
            '</form>'
  reply.type('text/html').send(out)          
})

fastify.post('/process', function (request, reply) {
  
  const files = request.raw.files
  console.log(files)
  const image = files.immagine
  console.log(image)

  fs.writeFile(path.join(__dirname, '/uploads/excellent.jpg'), image.data, function (err) {
    if (err) return console.log(err);
      console.log('Picture upload');
  });
  return reply.redirect(301,'/view');
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