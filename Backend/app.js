const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const http = require('http');

const userRoutes = require('./src/routes/userRoutes');
const requestRoutes = require('./src/routes/requestRoutes');
const uploadRoutes = require('./src/routes/uploadRoutes');
const bloodInventoryRoutes = require('./src/routes/bloodInventory');
const campaignRoutes = require('./src/routes/campaignRoutes');
const requestHistoryRoutes = require('./src/routes/requestHistoryRoutes');

dotenv.config();

const app = express();

// Middleware
app.use(express.json());
app.use(cors());

// Routes
app.use('/api/bloodInventory', bloodInventoryRoutes);
app.use('/api/campaigns', campaignRoutes);
app.use('/api/users', userRoutes);
app.use('/api/requests', requestRoutes);
app.use('/api/upload', uploadRoutes);
app.use('/api/request-history', requestHistoryRoutes);

app.get('/', (req, res) => {
    res.send('Blood Request System API Running...');
});
