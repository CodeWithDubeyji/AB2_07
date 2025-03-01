const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");

dotenv.config();

const app = express();

app.use(express.json());
app.use(cors());

const bloodInventoryRoutes = require("./src/routes/bloodInventory");

app.use("/api/bloodInventory", bloodInventoryRoutes);

app.get("/", (req, res) => {
    res.send("Blood Request System API Running...");
});

module.exports = app;
