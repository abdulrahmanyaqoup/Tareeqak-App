const mongoose = require("mongoose");

const userPropsSchema = new mongoose.Schema(
  {
    university: {
      type: String,
    },
    major: {
      type: String,
    },
    contact: {
      type: String,
    },
    image: {
      data: Buffer,
      type: String,
    },
  },
  { _id: false }
);

const UserProps = mongoose.model("UserProps", userPropsSchema);
module.exports = UserProps;
