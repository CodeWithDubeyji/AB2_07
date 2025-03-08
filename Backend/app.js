const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");

dotenv.config();

const app = express();

app.use(express.json());
app.use(cors());

const bloodInventoryRoutes = require("./src/routes/bloodInventory");

app.use("/api/bloodInventory", bloodInventoryRoutes);
const PORT = process.env.PORT || 5000;
const server = http.createServer(app);
app.use("/api/campaigns", require("./src/routes/campaignRoutes"));
app.use("/api/users", userRoutes);
app.use("/api/requests", requestRoutes);

app.get("/", (req, res) => {
    res.send("Blood Request System API Running...");
});

module.exports = app;
