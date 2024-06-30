const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");
const auth = require("../middleware/auth");
const authRouter = express.Router();

// Sign Up
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(422).json({ error: "Please fill all fields" });
    }

    const userExist = await User.findOne({ email });
    if (userExist) {
      return res
        .status(400)
        .json({ error: "User with the same email already exists!" });
    }

    const hashedPassword = await bcrypt.hash(password, 8);

    let user = new User({
      name,
      email,
      password: hashedPassword,
    });
    user = await user.save();
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// sign in
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(422).json({ error: "Please fill out all fields" });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(422)
        .json({ error: "User with this email does not exist!" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ error: "password is not correct!" });
    }

    const token = jwt.sign({ _id: user._id }, "passwordKey");
    res.json({ token, ...user._doc });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// token verification
authRouter.post("/tokenIsValid", auth, async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);

    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified._id);
    if (!user) return res.json(false);

    res.json(true);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// get user data
authRouter.get("/", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user._id);
    res.json({ ...user._doc, token: req.token });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = authRouter;
