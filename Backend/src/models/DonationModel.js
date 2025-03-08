const DonationSchema = new mongoose.Schema({
    donorId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },  // Donor user
    requestId: { type: mongoose.Schema.Types.ObjectId, ref: "BloodRequest", required: true }, // Linked request
    bloodAmount: { type: Number, required: true },  // Blood donated in mL
    donatedAt: { type: Date, default: Date.now }
  });
  
  module.exports = mongoose.model("Donation", DonationSchema);
  