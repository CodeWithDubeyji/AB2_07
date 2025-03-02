const express = require("express");
const BloodRequest = require("../models/BloodRequest");
const router = express.Router();
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const authenticate = require('../middelware/AuthMiddleware');

// Create a new blood request
router.post("/request",authenticate, async (req, res) => {
  try {
    const request = new BloodRequest(req.body);
    await request.save();
    res.status(201).json(request);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get active blood requests
router.get("/active-requests",authenticate, async (req, res) => {
  try {
    const requests = await BloodRequest.find({ status: "Pending" }).populate("requesterId");
    res.json(requests);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
