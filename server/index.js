const express = require("express");
const mongose = require("mongoose");
const userRoutes = require("./routes/userRoutes");
const errorHandler = require("./middleware/errorHandler");

const PORT = process.env.PORT;
const app = express();

app.use(express.json());
app.use("/uploads/images", express.static("uploads"));
app.use("/api/users", userRoutes);
app.use(errorHandler);

const DB = process.env.DB;

mongose
  .connect(DB)
  .then(() => {
    console.log("DB connected");
  })
  .catch((err) => console.log(err));

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
