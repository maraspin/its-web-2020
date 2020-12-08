// Simple snippet to show Content negotiation and basic DRY
// Not a perfect clean piece of code; just an example to be used during class

// Let's suppose these two are generared by some services out from here
let content = { hw:
                  { en: 'Hello World', it: 'Ciao Mondo' },
                hi:  
                  { en: 'Hello ITS', it: 'Ciao ITS' }
              }

// These could fit herein, as they belong to http layer
// IE they have little to do with the domain
let defaultContentType = "json"
let defaultTarget = "/en/hello-world"
let lan = 'en-CA'

// Should be in its own class - where it belongs... it depends
function prepareContent(content, language = 'en') {
  
  // Override example
  if (language == 'it') {
    lan = 'it-IT'
  }

  // More overrides could go here...
  return content[language];

}

// Attempt not to repeat ourselves (DRY) at every other route call
function dispatchContent(reply, content, format, lan) {

    // Default content
    let typer = 'application/json';
    let responseContent = { content: content };

    // Should we perform a conversion?
    if ('xml' == format) {
      typer = 'text/xml';
      responseContent = '<xml>' + content + '</xml>';
    }

    reply.header('Content-Language', lan).
        header('Content-Type', typer).
        send(responseContent)
}

const fastify = require('fastify')({
  logger: true
})


// Default route - redirects to most appropriate 
fastify.get('/', function (request, reply) {

  let typer = defaultContentType;

  let contents = request.headers['accept-type'];
  if (typeof contents !== 'undefined' && 
      contents.length > 0 && 
      !contents.includes("json")) {
    typer = "xml"
  }

  // Just as some major websites do - we redirect to local versions
  let languages = request.headers['accept-language'].toLowerCase().split(",");
  
  // We could use an improved version of the following to detect other languages
  languages.map(function(language) {if (language.includes("it")) {defaultTarget = "/it/hello-world"}}) 
  
  return reply.redirect(300,defaultTarget + '.' + typer);
})


// Actual routes - there's still too much logic (2 same exact calls at every route)
// DRY violation - not good - fixing is up to you
fastify.get('/en/hello-world.json', function (request, reply) {
  let replyContent = prepareContent(content.hw);
  dispatchContent(reply, replyContent, 'json', lan)
})

fastify.get('/en/hello-its.json', function (request, reply) {
  let replyContent = prepareContent(content.hi);
  dispatchContent(reply, replyContent, 'json', lan)
})

fastify.get('/en/hello-world.xml', function (request, reply) {
  let replyContent = prepareContent(content.hw);
  dispatchContent(reply, replyContent, 'xml', lan)
})

fastify.get('/en/hello-its.xml', function (request, reply) {
  let replyContent = prepareContent(content.hi);
  dispatchContent(reply, replyContent, 'xml', lan)
})

fastify.get('/it/hello-world.json', function (request, reply) {
  let replyContent = prepareContent(content.hw, 'it');
  dispatchContent(reply, replyContent, 'json', lan)
})

fastify.get('/it/hello-its.json', function (request, reply) {
  let replyContent = prepareContent(content.hi, 'it');
  dispatchContent(reply, replyContent, 'json', lan)
})

fastify.get('/it/hello-world.xml', function (request, reply) {
  let replyContent = prepareContent(content.hw, 'it');
  dispatchContent(reply, replyContent, 'xml', lan)
})

fastify.get('/it/hello-its.xml', function (request, reply) {
  let replyContent = prepareContent(content.hi, 'it');
  dispatchContent(reply, replyContent, 'xml', lan)
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