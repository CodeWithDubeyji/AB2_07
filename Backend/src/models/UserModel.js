const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema({
  name: String,
  email: String,
  phone: String,
  bloodType: String,
  location: { type: { type: String, enum: ["Point"], default: "Point" }, coordinates: [Number] },
  availability: { type: String, enum: ["Available", "Unavailable"], default: "Available" },
  createdAt: { type: Date, default: Date.now },
  donated : Number,
  request: Number
});

UserSchema.index({ location: "2dsphere" }); // Geospatial indexing

module.exports = mongoose.model("User", UserSchema);
