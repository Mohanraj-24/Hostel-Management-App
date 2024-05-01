const express = require("express");
const User = require("../models/user");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");

const authRouter = express.Router();

authRouter.post("/api/signup", async (req, res) => {
  const {
    rollNo,
    firstName,
    lastName,
    email,
    password,
    phoneNumber,
    block,
    roomNo,
    faceData1,
    faceData2,
    faceData3,
  } = req.body;
  try {
    const existingUser = await User.findOne({ rollNo });
    console.log(req.body, req.params);
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same roll number already exists" });
    }

    const existingMail = await User.findOne({ email });
    if (existingMail) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists" });
    }

    const hashedPassword = await bcryptjs.hash(password, 8);
    const hashedFaceData1 = await bcryptjs.hash(faceData1, 16);
    const hashedFaceData2 = await bcryptjs.hash(faceData2, 16);
    const hashedFaceData3 = await bcryptjs.hash(faceData3, 16);

    let user = new User({
      rollNo,
      firstName,
      lastName,
      email,
      password: hashedPassword,
      phoneNumber,
      block,
      roomNo,
      faceData1: hashedFaceData1,
      faceData2: hashedFaceData2,
      faceData3: hashedFaceData3,
    });
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ Error: e.message });
  }
});
authRouter.post("/api/signin", async (req, res) => {
  const { rollNo, password } = req.body;
  try {
    const user = await User.findOne({ rollNo });
    console.log(req.body, req.param);
    if (!user) {
      return res
        .status(400)
        .json({ msg: "User with this roll number does not exist" });
    }
    const payload = {
      rollNo: rollNo,
    };
    const isMatch = await bcryptjs.compare(password, user.password);
    const token = jwt.sign(payload, process.env.SECRET_KEY);
    console.log(token);

    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect Password" });
    }

    res.json({ token, ...user._doc });
  } catch (e) {
    res.status(500).json({ Error: e.message });
  }
});

module.exports = authRouter;
