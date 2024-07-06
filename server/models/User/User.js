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

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a valid email address",
    },
  },
  password: {
    type: String,
    required: true,
  },
  userProps: userPropsSchema,
});

const User = mongoose.model("User", userSchema);
module.exports = User;
