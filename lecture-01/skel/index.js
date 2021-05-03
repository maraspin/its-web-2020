// Include e attiva il framework Fastify
const fastify = require('fastify')({
  logger: true
})

// Ogni rotta viene gestita come segue...
// In questo caso le richieste per http://wa.its:3000/ vengono gestite dalla seguente...
fastify.get('/', function (request, reply) {
  reply.send({ hello: 'world' })
})

// Il server viene di seguito effettivamente avviato
// in ascolto sulla porta 3000 e sull'interfaccia "speciale" 0.0.0.0 
// (ovvero tutte le interfacce)
fastify.listen(3000, "0.0.0.0", function (err, address) {
  if (err) {
    fastify.log.error(err)
    process.exit(1)
  }
  fastify.log.info("server listening on ${address}")
})
