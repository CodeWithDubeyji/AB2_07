const mongoose = require("mongoose");

const BloodRequestSchema = new mongoose.Schema({
  requesterId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  bloodType: String,
  urgency: { type: String, enum: ["High", "Medium", "Low"], required: true },
  hospital: {
    name: String,
    location: { type: { type: String, enum: ["Point"], default: "Point" }, coordinates: [Number] }
  },
  status: { type: String, enum: ["Pending", "Accepted", "Completed"], default: "Pending" },
  assignedDonorId: { type: mongoose.Schema.Types.ObjectId, ref: "User", default: null },
  createdAt: { type: Date, default: Date.now }
});

BloodRequestSchema.index({ "hospital.location": "2dsphere" });

module.exports = mongoose.model("BloodRequest", BloodRequestSchema);
