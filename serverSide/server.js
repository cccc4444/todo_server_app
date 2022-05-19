let bodyParser = require('body-parser');
const { response } = require('express');
let app = require('express')();
let port = 3003;

app.use(bodyParser.json());

let todos = [
    {item: "покакать", priority: 0},
    {item: "покушать", priority: 1},
    {item: "чето там", priority: 2}
]

app.get('/', (request, response) => response.send({items: todos}))

app.post('/add', (request, response) => {
    if (request.body && request.body.item !== "") {
        todos.push(request.body);
        console.log(todos);
        response.send({items: todos});
    } else {
        response.status(400).send({message: "Todo item must have a title"})
    }
    
});

app.delete('/delete', (request, response) => {
    if (request.body && request.body.item != ""){
        todos.pop(request.body);
        console.log(todos);
        response.send({items: todos});
    }
    else {
        response.status(400).send({message: "Todo item must have a title"})
    }
});

app.listen(port, () => console.log(`Example app listening on port ${port}!`))