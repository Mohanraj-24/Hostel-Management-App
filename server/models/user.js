const mongoose = require('mongoose');

const userSchema = mongoose.Schema({
    rollNo:{
        required : true,
        type : String,
        trim : true
    },
    userName:{
        required : true,
        type : String,
        trim : true
    },
    firstName:{
        required : true,
        type : String,
        trim : true
    },
    lastName:{
        required : true,
        type : String,
        trim : true
    },
    email:{
        required : true,
        type : String,
        trim : true,
        validate : {
            validator : (value) =>{
                const re =/^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re);
            },
            message : "Please Enter Valid Email Address"
        },
    },
    password : {
        required : true,
        type : String
    },
    address : {
        type : String,
        default :''
    },
    phoneNumber : {
        required : true,
        type : String,
        trim : true,
        validate : {
            validator : (value) =>{
                return value.match(/\d/g).length===10;
            },
            message : "Please Enter Valid Phone Number"
        },
    },
    user : {
        type : String,
        default : 'user'
    },
    block : {
        required : true,
        type : String,
        trim : true
    },
    roomNo : {
        required : true,
        type : String,
        trim : true
    }
});
const User = mongoose.model('User',userSchema);
module.exports = User;