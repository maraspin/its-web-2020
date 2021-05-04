// Simple snippet to show Content negotiation and basic DRY
// Not a perfect clean piece of code; just an example to be used during class
const fileUpload = require('fastify-file-upload')
const AWS = require('aws-sdk');

// Make sure you DO NOT COMMIT these values
// UNDER NO CIRCUMSTANCES!!!
const ID = '';
const SECRET = '';

// The name of the bucket that you have created
const BUCKET_NAME = 'its-pn-fex';

// Pick a unique name here (to avoid having colleagues overwriting it)
const imageName = 'YOURNAME-excellent.jpg'

const s3 = new AWS.S3({
    accessKeyId: ID,
    secretAccessKey: SECRET
});

const fastify = require('fastify')({
  logger: true
})
fastify.register(fileUpload)

// Default route - redirects to most appropriate 
fastify.get('/', function (request, reply) {
  return reply.redirect(301,'/view');
})

// Actual routes - there's still too much logic (2 same exact calls at every route)
// DRY violation - not good - fixing is up to you
fastify.get('/view', function (request, reply) {
  responseContent = "<html><title>Test</title><body><h1>My image</h1><img src=\"https://its-pn-fex.s3-eu-west-1.amazonaws.com/"+imageName+"\"><br><br><a href=\"/upload\">Update image</a></body></html>";
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
  
  // Setting up S3 upload parameters
   const params = {
    Bucket: BUCKET_NAME,
     Key: imageName,
     Body: image.data,
     ACL:'public-read',
     ContentType: image.mimetype
    };

    // Uploading files to the bucket
    s3.upload(params, function(err, data) {
        if (err) {
            throw err;
        }
        console.log(`File uploaded successfully. ${data.Location}`);
        return reply.redirect(301,'/view');
    });
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