const express = require("express");
const mongoose = require("mongoose");
const { exec } = require('child_process');

const app = express();

app.set("view engine", "ejs");

app.use(express.urlencoded({ extended: false }));
app.use(express.json());

// Connect to MongoDB
mongoose
  .connect("mongodb://mongo:27017/docker-node-mongo", { useNewUrlParser: true })
  .then(() => console.log("MongoDB Connected"))
  .catch((err) => console.log(err));

const Item = require("./models/Item");

// DUMMY GET METHOD //
app.get('/app/:message', (req, res) => {
  exec(`/usr/bin/echo ${req.params.message}`, {timeout: 5000}, (error, stdout) => {
    if (error) return res.status(500).end();
    res.type('txt').send(stdout).end();
  });
});

// GET METHOD //
app.get("/", (req, res) => {
  Item.find()
    .then((items) => res.send({ items }))
    .catch((err) => res.status(404).json({ msg: "No items found" }));
});

// POST METHOD //
app.post("/item/add", (req, res) => {
  console.log(req.body.name);
  const newItem = new Item({
    name: req.body.name,
    message: req.body.message,
  });
  newItem.save().then((item) => res.redirect("/"));
});

// DELETE METHOD //
app.delete("/item/delete", (req, res) => {
  console.log("Función de eliminación");

  Item.remove(
    {
      name: req.body.name,
    },
    function (err) {
      if (err) return handleError(err);
    }
  );

  res.send("Elemento eliminado con  éxito!");
});

// PUT METHOD //

app.put("/item/put", (req, res) => {
  Item.findOneAndUpdate(
    { name: req.body.name },
    {
        $set: {
            name: req.body.name,
            message: req.body.message
        }
    },
    {
        upsert: true
    }
).then(result => { res.status(204).json('Updated') })
    .catch(error => console.error(error))
});

const port = 3000;

app.listen(port, () => {
  console.log(`Server express escuchando en http://localhost:${port}`);
});
