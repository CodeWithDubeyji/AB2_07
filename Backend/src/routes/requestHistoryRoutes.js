// src/routes/requestHistoryRoutes.js
const express = require('express');
const authenticate = require('../middelware/AuthMiddleware')
const BloodRequest = require('../models/BloodRequest');

const router = express.Router();

// Get request history for a specific user
router.get('/history/',authenticate,  (req, res) => {
    const userId = req.user._id;
    BloodRequest.find({requesterId: userId})
    .then((requests) => {
        res.json(requests);
    })
});

module.exports = router;