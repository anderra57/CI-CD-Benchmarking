const express = require("express");
const mongoose = require("mongoose");

const app = express();

app.set("view engine", "ejs");

app.use(express.urlencoded({ extended: false }));

// Connect to MongoDB
mongoose
  .connect("mongodb://mongo:27017/docker-node-mongo", { useNewUrlParser: true })
  .then(() => console.log("MongoDB Connected"))
  .catch((err) => console.log(err));

const Item = require("./models/Item");
// GET METHOD //
app.get("/", (req, res) => {
  Item.find()
    .then((items) => res.send({ items }))
    .catch((err) => res.status(404).json({ msg: "No items found" }));
});

// POST METHOD //
app.post("/item/add", (req, res) => {
  const newItem = new Item({
    name: req.body.name,
    message: req.body.message,
  });

  newItem.save().then((item) => res.redirect("/"));
});

// DELETE METHOD //
app.delete("/item/delete", (req, res) => {
  console.log ("Función de eliminación");
    Item.remove({
        name: req.body.name
    }, function(err) {
        if (err) return handleError(err);
        
    });
        res.sen
         res.send ("Elemento eliminado con  éxito!");
});

// PUT METHOD //
app.put("/item/put", (req, res) => {
  const item = new Item({
    name: req.body.name,
    message: req.body.message,
  });
  
  Item.updateOne({message: req.body.message}, item).then(
    () => {
      res.status(204).json({
        message: 'Thing updated successfully!'
      });
    }
  ).catch(
    (error) => {
      res.status(400).json({
        error: error
      });
    }
  );
});
const port = 3000;

app.listen(port, () => console.log("Server running..."));
