const mongoose = require("mongoose");

const NotificationSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true }, // Who gets notified
  requestId: { type: mongoose.Schema.Types.ObjectId, ref: "BloodRequest", required: true }, // Link to request
  message: { type: String, required: true }, 
  read: { type: Boolean, default: false }, // Mark as read/unread
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model("Notification", NotificationSchema);
