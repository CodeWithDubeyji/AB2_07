const app = require("./app");
const http = require("http");
const connectDB = require("./src/config/db");
const userRoutes = require("./src/routes/userRoutes");
const requestRoutes = require("./src/routes/requestRoutes");
const cors = require("cors");
const express = require("express");

connectDB();

const PORT = process.env.PORT || 5000;
const server = http.createServer(app);

app.use(cors());
app.use(express.json());
app.use("/api/users", userRoutes);
app.use("/api/requests", requestRoutes);

server.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
