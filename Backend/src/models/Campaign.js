const mongoose = require("mongoose");

const campaignSchema = new mongoose.Schema({
  name: { type: String, required: true },
  status: { type: String, enum: ["Live", "Upcoming"], required: true },
  startDate: { type: Date, required: true },
  endDate: { type: Date, required: true },
  description: { type: String, required: true },
  location: {
    address: { type: String, required: true },
    coordinates: { type: [Number], required: true, },
  },
  organizer: {
    name: { type: String, required: true },
    contact: { type: String, required: true },
  },
  createdAt: { type: Date, default: Date.now },
});

campaignSchema.virtual("formattedStartDate").get(function () {
  return this.startDate.toLocaleDateString("en-US", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
});

campaignSchema.virtual("formattedEndDate").get(function () {
  return this.endDate.toLocaleDateString("en-US", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
});

const Campaign = mongoose.model("Campaign", campaignSchema);
module.exports = Campaign;
