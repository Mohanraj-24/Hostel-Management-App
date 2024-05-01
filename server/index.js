// Import default
const express = require("express");
const mongoose = require("mongoose");
require("dotenv").config();

// Import from files
const authRouter = require("./routes/auth");
const userRouter = require("./routes/userRoutes");
//init
const app = express();
const PORT = 3000;
const DB =
  "mongodb+srv://Mohanraj:Mohan2004@cluster0.ogcmvth.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

app.use(express.json());
app.use(authRouter);
app.use(userRouter);

// const SECRET_KEY = process.env.SECRET_KEY;

//connections
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Listening at ${PORT}`);
});
