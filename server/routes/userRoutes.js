const express = require("express");
const {
  registerUser,
  loginUser,
  currentUser,
  getUsers,
  updateUser,
  deleteUser,
} = require("../controllers/userController");
const validateToken = require("../middleware/validateTokenHandler");
const imageUpload = require("../middleware/imageUploadHandler");
const errorHandler = require("../middleware/errorHandler");

const router = express.Router();

router.post("/register", imageUpload, registerUser);
router.post("/login", loginUser);
router.get("/current", validateToken, currentUser);
router.get("/", getUsers);
router.patch("/update/:id", validateToken, imageUpload, updateUser);
router.delete("/delete/:id", validateToken, deleteUser);

module.exports = router;
