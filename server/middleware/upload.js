// uploadMiddleware.js
const multer = require("multer");
const path = require("path");
const { v4: uuidv4 } = require("uuid");
const sharpMulter = require("sharp-multer");

// optional function to return new File Name
const generateImageName = (og_filename, options) => {
  const uuid = uuidv4();
  const newname = uuid + "." + options.fileFormat;
  return newname;
};

const storage = sharpMulter({
  destination: (req, file, callback) => callback(null, "uploads/"),

  imageOptions: {
    fileFormat: "webp",
    quality: 80,
  },

  filename: generateImageName,
});

const upload = multer({
  storage: storage,
});

module.exports = upload.single("image"); // Export the middleware for a single image
