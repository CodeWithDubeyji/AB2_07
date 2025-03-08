const app = require("./app");
const http = require("http");
const connectDB = require("./src/config/db");
const userRoutes = require("./src/routes/userRoutes");
const requestRoutes = require("./src/routes/requestRoutes");

connectDB();

const PORT = process.env.PORT || 5000;
const server = http.createServer(app);




server.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
