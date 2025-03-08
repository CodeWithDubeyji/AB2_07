const jwt = require("jsonwebtoken");
const User = require("../models/UserModel"); // Import the User model

const authenticate = async (req, res, next) => {
  const token = req.header("x-auth-token");

  if (!token) {
    return res.status(401).json({ message: "No token, authorization denied" });
  }

  try {
    const decoded = jwt.verify(token, "alphabyte"); // Replace "alphabyte" with process.env.JWT_SECRET in production
    const user = await User.findById(decoded.id);
    if (!user) {
      return res.status(401).json({ error: "Invalid token. User not found." });
    }

    req.user = user; // Attach user data to request object
    next();
  } catch (error) {
    res.status(401).json({ error: "Invalid or expired token" });
  }
};

module.exports = authenticate;
