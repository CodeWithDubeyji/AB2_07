// src/controllers/liveDonorTrackingController.js
let io;

const initialize = (server) => {
    io = require('socket.io')(server, {
        cors: {
            origin: "*",
            methods: ["GET", "POST"]
        }
    });

    io.on('connection', (socket) => {
        console.log('A user connected');

        socket.on('disconnect', () => {
            console.log('User disconnected');
        });
    });
};

const updateLocation = (req, res) => {
    const { userId, location } = req.body;

    if (!io) {
        return res.status(500).send('Socket.IO not initialized');
    }

    // Emit the location update to all connected clients
    io.emit('locationUpdated', { userId, location });
    res.status(200).send({ userId, location });
};

module.exports = { initialize, updateLocation };