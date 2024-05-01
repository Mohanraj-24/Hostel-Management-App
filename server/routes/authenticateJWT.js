const jwt = require("jsonwebtoken");

function authenticateJWT(req, res, next) {
  const token = req.header("Authorization");
  console.log(token);

  if (!token) {
    return res.status(401).json({ message: "Unauthorized" });
  }
  console.log(req.token);
  jwt.verify(token, process.env.SECRET_KEY, (err, user) => {
    if (err) {
      return res.status(403).json({ message: "Forbidden" });
    }
    req.user = user;
    next();
  });
}

module.exports = authenticateJWT;
