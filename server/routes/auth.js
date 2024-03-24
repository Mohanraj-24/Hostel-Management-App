const express = require('express');
const User = require('../models/user');
const bcryptjs = require('bcryptjs');

const authRouter = express.Router();

authRouter.post("/api/signup", async(req,res) =>{
    const {userName, firstName, lastName, email, password, phoneNumber, block, roomNo} = req.body;
    try{
        const existingUser = await User.findOne({email});

        if(existingUser){
            return res.status(400).json({msg:"User with same email already exists"});
        }

        const hashedPassword = await bcryptjs.hash(password, 8);

        let user = new User({
            userName,
            firstName,
            lastName,
            email,
            password : hashedPassword,
            phoneNumber,
            block,
            roomNo,
        });
        user = await user.save();
        res.json(user);
    }
    catch(e){
        res.status(500).json({Error:e.message});
    }
});
module.exports = authRouter;