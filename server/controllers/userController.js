const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User/User");
const asyncHandler = require("express-async-handler");

//@desc Register a user
//@route POST /api/users/register
//@access public
const registerUser = asyncHandler(async (req, res) => {
  try {
    const { name, email, password, university, major, contact } = req.body;

    const userExist = await User.findOne({ email });
    if (userExist) {
      res.status(400).json({ msg: "User with the same email already exists!" });
    }

    const hashedPassword = await bcrypt.hash(password, 8);
    const imagePath = req.file ? req.file.path : undefined;

    let user = new User({
      name,
      email,
      password: hashedPassword,
      userProps: {
        university,
        major,
        contact,
        image: imagePath,
      },
    });
    user = await user.save();
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

//@desc Login user
//@route POST /api/users/login
//@access public
const loginUser = asyncHandler(async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email) {
      res.status(400).json({ msg: "Please enter your email!" });
    }

    if (!password) {
      res.status(400).json({ msg: "Please enter your password!" });
    }

    const user = await User.findOne({ email });
    if (!user) {
      res.status(404).json({ msg: "User not found!" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      res.status(403).json({ msg: "Password is incorrect!" });
    }

    const token = jwt.sign({ _id: user._id }, process.env.SECRET);
    res.json({ token, ...user._doc });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

//@desc Curret user
//@route POST /api/users/current
//@access private
const currentUser = asyncHandler(async (req, res) => {
  try {
    const user = await User.findById(req.user._id);
    res.json({ ...user._doc, token: req.token });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

//@desc Get users
//@route GET /api/users
//@access public
const getUsers = asyncHandler(async (req, res) => {
  try {
    const users = await User.find({}, "name userProps");
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

//@desc Update user
//@route PATCH /api/users
//@access private
const updateUser = asyncHandler(async (req, res) => {
  try {
    const { name, email, password, university, major, contact } = req.body;

    let hashedPassword;
    if (password) {
      hashedPassword = await bcrypt.hash(password, 12);
    }
    const imagePath = req.file ? req.file.path : undefined;

    const updates = {
      name,
      email,
      password: hashedPassword,
      userProps: {
        university,
        major,
        contact,
        image: imagePath,
      },
    };

    const user = await User.findByIdAndUpdate(req.params.id, { $set: updates });

    if (!user) {
      res.status(404).json({ error: "User not found" });
    }

    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

//@desc Delete users
//@route DELETE /api/users
//@access private
const deleteUser = asyncHandler(async (req, res) => {
  try {
    if (req.user._id !== req.params.id) {
      res.status(401).json({ error: "Unauthorized" });
    }

    const deletedUser = await User.findByIdAndDelete(req.params.id);
    if (!deletedUser) {
      res.status(404).json({ error: "User not found" });
    }
    res.json({ message: "User deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = {
  registerUser,
  loginUser,
  currentUser,
  getUsers,
  updateUser,
  deleteUser,
};
