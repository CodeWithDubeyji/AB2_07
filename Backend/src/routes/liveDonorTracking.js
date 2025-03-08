// src/routes/liveDonorTracking.js
const express = require('express');
const { updateLocation } = require('../controllers/liveDonorTrackingController');

const router = express.Router();

router.post('/update-location', updateLocation);

module.exports = router;