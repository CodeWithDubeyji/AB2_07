const app = require("./app");
const http = require("http");
const connectDB = require("./src/config/db");

connectDB();

const PORT = process.env.PORT || 5000;
const server = http.createServer(app);

server.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
