const express = require("express");
const BloodRequest = require("../models/BloodRequest");
const router = express.Router();

// Create a new blood request
router.post("/request", async (req, res) => {
  try {
    const request = new BloodRequest(req.body);
    await request.save();
    res.status(201).json(request);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get active blood requests
router.get("/active-requests", async (req, res) => {
  try {
    const requests = await BloodRequest.find({ status: "Pending" }).populate("requesterId");
    res.json(requests);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
