const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");

dotenv.config();

const app = express();

app.use(express.json());
app.use(cors());

// const userRoutes = require("./routes/userRoutes");
// const requestRoutes = require("./routes/requestRoutes");

// // Use Routes
// app.use("/api/users", userRoutes);
// app.use("/api/requests", requestRoutes);

app.get("/", (req, res) => {
    res.send("Blood Request System API Running...");
});

module.exports = app;
