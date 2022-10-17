/**
 * @file mongo.js
 * @author Devin Arena
 * @description Helper for connecting to MongoDB.
 * @since 10/16/2022
 **/

const { MongoClient, ObjectId } = require("mongodb");

const uri = `mongodb+srv://${process.env.MONGODB_USER}:${process.env.MONGODB_PASS}@programmingproblems.5f303oa.mongodb.net/test`;

const client = new MongoClient(uri);

/**
 * Basic connection functionality.
 */
const dbConnect = async () => {
  try {
    await client.connect();
    console.log("Connected correctly to MongoDB");
  } catch (err) {
    console.log(err.stack);
  }
};

/**
 * Basic disconnection functionality.
 */
const dbDisconnect = async () => {
  try {
    await client.close();
    console.log("Disconnected from MongoDB");
  } catch (err) {
    console.log(err.stack);
  }
};

/**
 * Queries the database for all problems.
 */
const queryProblems = async () => {
  try {
    const database = client.db("problems");
    const collection = database.collection("problems");

    const problems = await collection.find().toArray();

    return problems;
  } catch (err) {
    console.log(err.stack);
    return [];
  }
};

/**
 * Gets a singular problem by its ID.
 *
 * @param id {number} The ID of the problem.
 * @param number {number} If the given ID was the problem's number instead.
 */
const getProblem = async (id, number = false) => {
  try {
    const database = client.db("problems");
    const collection = database.collection("problems");

    const problem = number
      ? await collection.findOne({ number: id })
      : await collection.findOne({ _id: ObjectId(id) });

    return problem;
  } catch (err) {
    console.log(err.stack);
    return undefined;
  }
};

module.exports = {
  dbConnect,
  dbDisconnect,
  queryProblems,
  getProblem,
};
