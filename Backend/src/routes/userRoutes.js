const express = require("express");
const User = require("../models/UserModel");
const router = express.Router();
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const authenticate = require("../middelware/AuthMiddleware");
const Notification = require("../models/NotificationModel");

// Register a new user
router.post('/register' , async (request, response)=>{
    
    try {
         
        const {name ,   email,phone ,location, password  } = request.body;
       

        const existingUser = await User.findOne({name});

        if(existingUser){
            return response.status(400).json({message:"Username already exists"});
        }

        const existingEmail = await User.findOne({email});

        if(existingEmail){
            return response.status(400).json({message:"Email already exists"});
        }

      

        const hashedPassword = await bcrypt.hash(password ,10);

        const newUser = {
            name:name,
            phone:phone,
            location:location,
            email:email,
            password:hashedPassword,
            
        };

        const user = new User(newUser);
        await user.save();
        response.status(200).json({message:"User registered successfully"});
    }
    catch(error){

        response.status(500).json({message:"Something went wrong",error:error.message});

    }
});

router.post('/login' , async (request , response)=>{
    try{

        const {name , password} = request.body; 
     
        //saving user sent password and username in the variables 

        const user = await User.findOne({name});
       
        //now we'll find whether the user of  that particular username exists in 
        //User collection or not using findOne function and passing the username in it


        if(!user){
            return response.status(400).json({message:"User does not exist"});//if that particulat username is  not present then we'll print this
        }

        const isMatched = await bcrypt.compare(password, user.password);// else compare the password using bcrypt.compare

        if(!isMatched){
            return response.status(400).json({message:"invalid password"});
        }
        
        const token = jwt.sign({id:user._id,username:user.username,type:user.type}, "alphabyte",{expiresIn:'1hr'});

        response.status(200).json({message:'Token generated successfully',token:token});

        
    }
    catch(error){
        response.status(500).json({message:"Something went wrong",error:error.message});
    }


});

// Get nearby donors
router.get("/nearby-donors", async (req, res) => {
  try {
    const { longitude, latitude, bloodType } = req.query;

    if (!longitude || !latitude || !bloodType) {
      return res.status(400).json({ error: "Missing longitude, latitude, or bloodType" });
    }

    const lat = parseFloat(latitude);
    const lon = parseFloat(longitude);

    function getDistance(lat1, lon1, lat2, lon2) {
      const R = 6371; // Earth’s radius in km
      const dLat = (lat2 - lat1) * (Math.PI / 180);
      const dLon = (lon2 - lon1) * (Math.PI / 180);
      const a =
        Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(lat1 * (Math.PI / 180)) * Math.cos(lat2 * (Math.PI / 180)) *
        Math.sin(dLon / 2) * Math.sin(dLon / 2);
      const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
      return R * c; // Distance in km
    }

    const donors = await User.find({ bloodType, availability: "Available" });

    const filteredDonors = donors
      .filter(donor => donor.location && donor.location.coordinates)
      .map(donor => ({
        ...donor._doc,
        distance: getDistance(lat, lon, donor.location.coordinates[1], donor.location.coordinates[0])
      }))
      .filter(donor => donor.distance <= 5) // 5km range
      .sort((a, b) => a.distance - b.distance);

    res.json(filteredDonors);
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ error: err.message });
  }
});

  
  router.get("/notifications", authenticate, async (req, res) => {
    try {
      const notifications = await Notification.find({ userId: req.user._id, read: false });
      res.json(notifications);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  });
  

router.get("/users", async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
