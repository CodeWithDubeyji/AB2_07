const express = require("express");
const User = require("../models/UserModel");
const router = express.Router();

// Register a new user
router.post("/register", async (req, res) => {
  try {
    const user = new User(req.body);
    await user.save();
    res.status(201).json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get nearby donors
router.get("/nearby-donors", async (req, res) => {
    const { longitude, latitude, bloodType } = req.query;
    console.log("Query Params:", longitude, latitude, bloodType); // Debugging
  
    try {
        function getDistance(lat1, lon1, lat2, lon2) {
            const R = 6371; // Earth’s radius in km
            const dLat = (lat2 - lat1) * (Math.PI / 180);
            const dLon = (lon2 - lon1) * (Math.PI / 180);
            const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                      Math.cos(lat1 * (Math.PI / 180)) * Math.cos(lat2 * (Math.PI / 180)) *
                      Math.sin(dLon / 2) * Math.sin(dLon / 2);
            const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
            return R * c; // Distance in km
          }
          
          const donors = await User.find({ bloodType, availability: "Available" });
          const filteredDonors = donors
            .map(donor => ({
              ...donor._doc,
              distance: getDistance(latitude, longitude, donor.location.coordinates[1], donor.location.coordinates[0])
            }))
            .filter(donor => donor.distance <= 5) // 5km range
            .sort((a, b) => a.distance - b.distance);
          
          
          
  
      console.log("Found Donors:", donors); // Debugging
      res.json(filteredDonors);
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
