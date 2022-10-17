/**
 * @file index.js
 * @author Devin Arena
 * @description API endpoints for submitting problems.
 * @since 10/16/2022
 **/

require("dotenv").config();

const vm = require("vm");
const express = require("express");
const {
  dbConnect,
  dbDisconnect,
  queryProblems,
  getProblem,
} = require("./mongo");
const app = express();

const PORT = process.env.PORT || 5000;

app.use(express.json());

const init = () => {
  dbConnect();
};

const getProblems = async (req, res) => {
  const problems = await queryProblems();
  return res.json(problems);
};

const solve = async (req, res) => {
  const { id, code } = req.body;

  const problem = await getProblem(id);
  console.log(problem);

  // Initialize a VM to run the test cases in.

  const sandbox = {
    console,
  };
  sandbox[problem.function] = undefined;

  vm.createContext(sandbox);
  vm.runInContext(problem.function + " = " + code, sandbox);

  // Run test cases
  const temp = console.log;
  const logs = [];
  console.log = function (message) {
    logs.push(message);
    temp.apply(console, arguments);
  };
  for (let i = 0; i < problem.test_cases.length; i++) {
    const test = problem.test_cases[i];
    const result = sandbox[problem.function](test.input);
    if (problem.test_print) {
      if (`${logs[logs.length - 1]}` !== `${test.output}`) {
        return res.json({
          success: false,
          message: `Test case failed for ${test.input} -> ${test.output}`,
        });
      }
    } else {
      if (result !== test.output) {
        return res.json({
          success: false,
          message: `Test case failed for ${test.input} -> ${test.output}`,
        });
      }
    }
  }
  console.log = temp;

  return res.status(200).json({
    success: true,
    message: "All test cases passed!",
  });
};

app.post("/solve", solve);

app.get("/problems", getProblems);

app.listen(PORT, () => {
  init();

  console.log(`Listening on port ${PORT}`);
});

// cleanup when app is closed
process.on("SIGINT", () => {
  dbDisconnect();
  process.exit();
});
