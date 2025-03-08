const express = require("express");
const BloodRequest = require("../models/BloodRequest");
const router = express.Router();
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const authenticate = require('../middelware/AuthMiddleware');
const axios = require('axios');
const Notification = require("../models/NotificationModel");
const User = require("../models/UserModel");

router.post("/request", authenticate, async (req, res) => {
  try {
    // `req.user` should contain the authenticated user's details from the `authenticate` middleware
    const requesterId = req.user._id; 

    // Create new blood request
    const request = new BloodRequest({
      ...req.body, 
      requesterId // Set the requester ID automatically
    });

    await request.save();
    
    const lat = parseFloat(req.body.hospital.location.coordinates[1]);
        const lon = parseFloat(req.body.hospital.location.coordinates[0]);
       const bloodType = req.body.bloodType;
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
    
        const donors = await User.find({  bloodType , availability: "Available" });
    
        const filteredDonors = donors
          .filter(donor => donor.location && donor.location.coordinates)
          .map(donor => ({
            ...donor._doc,
            distance: getDistance(lat, lon, donor.location.coordinates[1], donor.location.coordinates[0])
          }))
          .filter(donor => donor.distance <= 5) // 5km range
          .sort((a, b) => a.distance - b.distance);


    const notifications = filteredDonors.map((user) => ({
      userId: user._id,
      requestId: request._id,
      message: `Urgent! Blood type ${req.body.bloodType} needed at ${req.body.hospital.name}.`,
      createdAt: new Date()
    }));

    await Notification.insertMany(notifications);
    res.status(201).json({ request, message: "Blood request posted and notifications sent!" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});


router.get("/active-requests",authenticate, async (req, res) => {
  try {
    const requests = await BloodRequest.find({ status: "Pending" }).populate("requesterId");
    res.json(requests);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
