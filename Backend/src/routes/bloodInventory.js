const express = require('express')
const router = express.Router()
const BloodBank = require('../models/BloodBank')

router.post('/addBloodBank', async (req, res) => {
  try {
    const { name, coordinates, contact, email, address } = req.body

    const bloodBank = new BloodBank({
      name,
      location: { type: 'Point', coordinates },
      contact,
      email,
      address
    })

    await bloodBank.save()
    res
      .status(201)
      .json({ message: 'Blood bank added successfully', bloodBank })
  } catch (error) {
    res.status(500).json({ error: error.message })
  }
})

const BloodInventory = require('../models/BloodInventory')

router.post('/addBloodStock', async (req, res) => {
  try {
    const { bloodBankName, bloodType, quantity } = req.body

    const bloodBank = await BloodBank.findOne({ name: bloodBankName })

    if (!bloodBank) {
      return res.status(404).json({ message: 'Blood bank not found' })
    }

    const bloodStock = new BloodInventory({
      bloodBank: bloodBank._id,
      bloodType,
      quantity
    })

    await bloodStock.save()
    res.status(201).json({ message: 'Blood stock updated', bloodStock })
  } catch (error) {
    res.status(500).json({ error: error.message })
  }
})

router.get('/availableStock/:bloodType', async (req, res) => {
  try {
    const { bloodType } = req.params

    const stock = await BloodInventory.find({ bloodType }).populate(
      'bloodBank',
      'name location contact address'
    )

    if (stock.length === 0) {
      return res.status(404).json({ message: 'No stock available' })
    }

    res.json(stock)
  } catch (error) {
    res.status(500).json({ error: error.message })
  }
})

const getDistance = (lat1, lon1, lat2, lon2) => {
  const R = 6371;
  const dLat = (lat2 - lat1) * (Math.PI / 180);
  const dLon = (lon2 - lon1) * (Math.PI / 180);
  const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(lat1 * (Math.PI / 180)) * Math.cos(lat2 * (Math.PI / 180)) *
            Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
};

router.get('/nearestBloodBanks', async (req, res) => {
  try {
    const { bloodType, longitude, latitude } = req.query;

    if (!bloodType || !longitude || !latitude) {
      return res.status(400).json({ error: 'bloodType, longitude, and latitude are required' });
    }

    const allBanks = await BloodBank.find();

    const nearbyBanks = allBanks
      .map(bank => ({
        ...bank._doc,
        distance: getDistance(
          parseFloat(latitude), 
          parseFloat(longitude), 
          bank.location.coordinates[1], 
          bank.location.coordinates[0]
        )
      }))
      .filter(bank => bank.distance <= 5)
      .sort((a, b) => a.distance - b.distance);

    for (const bank of nearbyBanks) {
      const inventory = await BloodInventory.findOne({ bloodBank: bank._id, bloodType: bloodType });
      bank.inventory = inventory || null;
    }

    res.json(nearbyBanks);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});


module.exports = router
