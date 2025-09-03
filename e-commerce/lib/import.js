const fs = require("fs");
const admin = require("firebase-admin");

const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();


const products = JSON.parse(fs.readFileSync("lib/ecommerce_products.json", "utf8"));

const collectionName = "products";

products.forEach(async (product) => {
  try {
    await db.collection(collectionName).add(product);
    console.log( uploaded : ${product.name || "بدون اسم"}`);
  } catch (error) {
    console.error("Error :", error);
  }
});
