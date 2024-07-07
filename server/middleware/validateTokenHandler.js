require("dotenv/config");
const jwt = require("jsonwebtoken");

const auth = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) {
      return res.status(401).send({ error: "No auth token, access denied" });
    }

    const verified = jwt.verify(token, process.env.SECRET);

    if (!verified) {
      return res
        .status(401)
        .send({ error: "Token verification failed, authorization denied" });
    }

    req.user = verified.id;
    req.token = token;
    next();
  } catch (error) {
    res.status(500).send({ error: "error.message" });
  }
};

module.exports = auth;
