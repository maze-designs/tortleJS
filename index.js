const ver = "TortleJS dev0.1"
const connect = require('connect')
const http = require('http')

const app = connect()

turtleStack = new Array()


class Turtle {
  constructor(ID) {
    this.ID = ID
    this.status = {}
    this.commandStack = ["move up", "move down", "move up", "move down", "move up", "move down"] // TODO: testing only
    this.settings = {
      emptyStackCommand: "wait 1"
    }
  }
}
turtleIdIndex = {}

const bodyParser = require('body-parser')
app.use(bodyParser.urlencoded({extended: true}))

app.use('/api/v1/agent', function(req, res){
  console.table(req.body)

  switch(req.body.ACTION) {
    case("register"):
      res.writeHead(201)
      res.end("registered turtle #" + req.body.ID)
      if(turtleIdIndex[req.body.ID] === undefined) {
        turtleStack.push(new Turtle(req.body.ID))
        turtleIdIndex[req.body.ID] = turtleStack.length - 1
      }
      console.log(turtleStack)
      console.log(turtleIdIndex)
      break

    case("status"):
      id = req.body.ID
      delete req.body.ID
      delete req.body.ACTION
      req.body.timestamp = Date.now()
      turtleStack[turtleIdIndex[id]].status = req.body
      res.writeHead(200)
       res.end("received status")
      break

    case("stack"):
      turtle = turtleStack[turtleIdIndex[req.body.ID]]
      let command = turtle.commandStack.length > 0 ? turtle.commandStack[0] : turtle.settings.emptyStackCommand
      if(turtle.commandStack.length > 0) { turtle.commandStack.shift() }
      res.writeHead(200)
      res.end(command)

      console.log(`sent <${command}> to turtle #${req.body.ID}`)
      console.log(turtleStack)
      break
  }
  console.log("----------------------------------------------------------")
})
const port = 6969
http.createServer(app).listen(port)
console.log(ver + " up at :" + port) // should be in a callback but whatever
