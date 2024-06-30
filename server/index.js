const e = require("express");
const express = require("express");
const mongose = require("mongoose");
const authRouter = require("./routes/auth");

const PORT = process.env.PORT || 3000;
const app = express();

app.use(express.json());
app.use(authRouter);

const DB =
  "mongodb+srv://tareeqak:9ueSyaL1enUQ3jB5@tareeqak.rrfoolw.mongodb.net/tareeqak?retryWrites=true&w=majority&appName=Tareeqak";

mongose
  .connect(DB)
  .then(() => {
    console.log("DB connected");
  })
  .catch((err) => console.log(err));

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
