const express = require("express");
const User = require("../models/user");
const authenticateJWT = require("./authenticateJWT");

const userRouter = express.Router();

// Protected route to fetch user details
userRouter.get("/api/getUserData", authenticateJWT, async (req, res) => {
  try {
    const rollNo = req.user.rollNo;
    const user = await User.findOne({ rollNo });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
userRouter.post("/api/addAttendance", authenticateJWT, async (req, res) => {
  try {
    const { dateTime } = req.body; // Assuming dateTime is sent in the request body
    const rollNo = req.user.rollNo;

    // Find the user by rollNo
    const user = await User.findOne({ rollNo });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Add the received dateTime to user's attendance array
    user.attendance.push(dateTime);

    // Save the updated user document
    await user.save();

    res.status(200).json({ message: "Attendance added successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = userRouter;
