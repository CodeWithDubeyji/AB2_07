const app = require('./app'); // Import the Express app
const http = require('http');
const connectDB = require('./src/config/db');
const { initialize } = require('./src/controllers/liveDonorTrackingController');

// Connect to the database
connectDB();

const PORT = process.env.PORT || 5000;

const server = http.createServer(app);

initialize(server);

server.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});