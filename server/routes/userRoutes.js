const express = require("express");
const {
  registerUser,
  loginUser,
  tokenVerficiation,
  currentUser,
  getUsers,
  updateUser,
  deleteUser,
} = require("../controllers/userController");
const validateToken = require("../middleware/validateTokenHandler");
const imageUpload = require("../middleware/imageUploadHandler");

const router = express.Router();

router.post("/register", imageUpload, registerUser);
router.post("/login", loginUser);
router.post("/token", validateToken, tokenVerficiation);
router.get("/current", validateToken, currentUser);
router.get("/", getUsers);
router.patch("/:id", validateToken, updateUser);
router.delete("/:id", validateToken, deleteUser);

module.exports = router;
