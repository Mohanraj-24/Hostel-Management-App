const express = require("express");
const User = require("../models/user");
const authenticateJWT = require("./authenticateJWT");
const { DateTime } = require("luxon"); // Only DateTime needed from Luxon

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
    const { dateTime } = req.body;
    const rollNo = req.user.rollNo;
    const userTimeZone = "Asia/Kolkata"; // Adjust if needed

    const currentTime = DateTime.local().setZone(userTimeZone); // Use Luxon for time zone handling
    console.log(currentTime.toFormat("yyyy LLL dd HH:MM")); // Optional logging

    const user = await User.findOne({ rollNo });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    user.attendance.push(dateTime);
    await user.save();

    res.status(200).json({ message: "Attendance added successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// New route to update user preferences
userRouter.post("/api/updatePreference", authenticateJWT, async (req, res) => {
  try {
    const rollNo = req.user.rollNo;
    const { date, preference } = req.body;
    console.log(req.body);

    if (!rollNo || !date || typeof preference !== "boolean") {
      return res.status(400).json({ message: "Invalid request data" });
    }

    const user = await User.findOne({ rollNo });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Find the existing preference object for the given date (if any)
    const existingPreferenceIndex = user.preferences.findIndex(
      (pref) => pref.date.getTime() === Date.parse(date)
    );

    if (existingPreferenceIndex !== -1) {
      // Update existing preference
      user.preferences[existingPreferenceIndex].preference = preference;
    } else {
      // Create a new preference object
      user.preferences.push({ date: new Date(date), preference });
    }

    await user.save();

    res.status(200).json({ message: "Preference updated successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = userRouter;
