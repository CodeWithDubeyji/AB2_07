const mongoose = require("mongoose");

const BloodBankSchema = new mongoose.Schema({
    name: { type: String, required: true },
    location: {
        type: { type: String, default: "Point" },
        coordinates: { type: [Number], required: true, }
    },
    contact: { type: String, required: true },
    email: { type: String },
    address: { type: String, required: true },
}, { timestamps: true });

BloodBankSchema.index({ location: "2dsphere" });

const BloodBank = mongoose.model("BloodBank", BloodBankSchema);

module.exports = BloodBank;
