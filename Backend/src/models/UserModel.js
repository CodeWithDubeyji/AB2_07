const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema({
  name: String,
  email: String,
  phone: Number,
  
  location: { type: { type: String, enum: ["Point"], default: "Point" }, coordinates: [Number] },
  availability: { type: String, enum: ["Available", "Unavailable"], default: "Available" },
  createdAt: { type: Date, default: Date.now },
  donated : {type : Number , defaut:0},
  request: {type : Number , default:0},
  bloodType : {type : String , required:true},
  password : {
    type:String,
    required:true
}
});

UserSchema.index({ location: "2dsphere" });

module.exports = mongoose.model("User", UserSchema);
