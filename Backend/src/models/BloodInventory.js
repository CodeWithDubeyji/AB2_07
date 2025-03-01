const mongoose = require("mongoose");
const BloodInventorySchema = new mongoose.Schema({
    bloodBank: { type: mongoose.Schema.Types.ObjectId, ref: "BloodBank", required: true }, 
    bloodType: { type: String, required: true, enum: ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"] },
    quantity: { type: Number, required: true, min: 0 },
    lastUpdated: { type: Date, default: Date.now } 
}, { timestamps: true });

const BloodInventory = mongoose.model("BloodInventory", BloodInventorySchema);

module.exports = BloodInventory;
