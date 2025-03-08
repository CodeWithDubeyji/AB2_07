const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const userRoutes = require('./src/routes/userRoutes');
const requestRoutes = require('./src/routes/requestRoutes');
const uploadRoutes = require('./src/routes/uploadRoutes'); // Import upload routes

dotenv.config();

const app = express();

app.use(express.json());
app.use(cors());

const bloodInventoryRoutes = require('./src/routes/bloodInventory');
const liveDonorTrackingRoutes = require('./src/routes/liveDonorTracking');

app.use('/api/bloodInventory', bloodInventoryRoutes);
app.use('/api/campaigns', require('./src/routes/campaignRoutes'));
app.use('/api/users', userRoutes);
app.use('/api/requests', requestRoutes);
app.use('/api/live-donor-tracking', liveDonorTrackingRoutes);
app.use('/api/upload', uploadRoutes);
app.use('/api/request-history', require('./src/routes/requestHistoryRoutes'));

app.get('/', (req, res) => {
  res.send('Blood Request System API Running...');
});

module.exports = app;