const express = require("express");
const router = express.Router();
const Campaign = require("../models/Campaign");


router.post("/addcampaign", async (req, res) => {
    try {
      const campaign = new Campaign(req.body);
      await campaign.save();
      res.status(201).json(campaign);
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  });
  router.get("/getallcampaign", async (req, res) => {
    try {
      const campaigns = await Campaign.find().sort({ startDate: 1 });
      res.json(campaigns);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  });

module.exports = router;
