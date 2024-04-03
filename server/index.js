// import default
const express = require('express');

// import from files
const authRouter = require('./routes/auth');
const { Mongoose, mongo, default: mongoose } = require('mongoose');

//init
const app = express();
const PORT = 3000;
const DB = "mongodb+srv://Mohanraj:Mohan2004@cluster0.ogcmvth.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

app.use(express.json());
app.use(authRouter);

//connections
mongoose.connect(DB).then( () =>{
    console.log('Connection Successful');
}).catch ((e) => {
    console.log(e);
});

app.listen(PORT, "10.16.50.36" ,() => {
    console.log(`Listening at ${PORT}`)
});