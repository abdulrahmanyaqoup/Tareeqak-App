const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const upload = require("../middleware/upload");
const User = require("../models/User/User");
const UserProps = require("../models/User/UserProps");
const auth = require("../middleware/auth");
const authRouter = express.Router();

// Sign Up
authRouter.post("/api/signup", upload, async (req, res) => {
  try {
    const { name, email, password, university, major, contact } = req.body;

    if (!name || !email || !password) {
      res.status(400);
      throw new Error("All fields are mandatory!");
    }

    const userExist = await User.findOne({ email });
    if (userExist) {
      return res
        .status(400)
        .json({ error: "User with the same email already exists!" });
    }

    const hashedPassword = await bcrypt.hash(password, 8);
    const imagePath = req.file ? req.file.path : undefined;

    const userProps = new UserProps({
      university,
      major,
      contact,
      image: imagePath,
    });

    let user = new User({
      name,
      email,
      password: hashedPassword,
      userProps: userProps,
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
authRouter.post("/api/user/tokenIsValid", auth, async (req, res) => {
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
authRouter.get("/api/user", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user._id);
    res.json({ ...user._doc, token: req.token });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get all users
authRouter.get("/api/users", async (req, res) => {
  try {
    const users = await User.find({}, "name userProps");
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update user
authRouter.patch("/api/user/:id", upload, auth, async (req, res) => {
  try {
    if (req.user._id !== req.params.id) {
      return res.status(401).json({ error: "Unauthorized" });
    }

    const updates = { ...req.body };
    if (updates.userProps && Object.keys(updates.userProps).length === 0) {
      delete updates.userProps;
    }

    const userExist = await User.findOne({ email: updates.email });
    if (userExist) {
      return res
        .status(400)
        .json({ error: "User with the same email already exists!" });
    }

    if (updates.name) {
      if (updates.name.length === 0) {
        return res.status(401).json({ error: "name can't be empty" });
      }
    }

    if (updates.password) {
      if (updates.password.length > 0) {
        updates.password = await bcrypt.hash(updates.password, 8);
      } else {
        return res.status(401).json({ error: "password can't be empty" });
      }
    }

    if (req.file) {
      const mimeType = req.file.mimetype;
      if (
        !["image/jpeg", "image/jpg", "image/png", "image/webp"].includes(
          mimeType
        )
      ) {
        return res.status(422).json({
          error:
            "Unsupported image format. Allowed formats are: jpg, jpeg, png, webp.",
        });
      }

      updates.userProps.image = req.file.buffer;
    }

    const user = await User.findByIdAndUpdate(
      req.params.id,
      updates,
      { $set: updates },
      { new: true }
    );

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete user
authRouter.delete("/api/user/:id", auth, async (req, res) => {
  try {
    if (req.user._id !== req.params.id) {
      return res.status(401).json({ error: "Unauthorized" });
    }

    const deletedUser = await User.findByIdAndDelete(req.params.id);
    if (!deletedUser) {
      return res.status(404).json({ error: "User not found" });
    }
    res.json({ message: "User deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = authRouter;
