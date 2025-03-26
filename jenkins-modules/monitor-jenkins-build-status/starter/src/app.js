const express = require("express");
const app = express();

app.get("/", (req, res) => {
    res.status(200).send("Hello from Jenkins CI!");
});

module.exports = app;

if (require.main === module) {
    const port = process.env.PORT || 3000;
    app.listen(port, () => {
        console.log(`Server running on port ${port}`);
    });
}
