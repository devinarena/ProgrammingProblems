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

  // Initialize a VM to run the test cases in.

  const sandbox = {
    console,
    Math,
  };
  sandbox[problem.function] = undefined;

  vm.createContext(sandbox);
  try {
    vm.runInContext(problem.function + " = " + code, sandbox);
  } catch (e) {
    return res.json({
      success: false,
      passed: [],
      total: problem.test_cases.length,
      input: problem.test_cases[0]["input"],
      output: e.message,
      expected: problem.test_cases[0]["expected"],
    });
  }

  // Run test cases
  const temp = console.log;
  const logs = [];
  console.log = function (message) {
    logs.push(message);
    temp.apply(console, arguments);
  };
  const passed = [];
  for (let i = 0; i < problem.test_cases.length; i++) {
    const test = problem.test_cases[i];
    let result;
    try {
      result = sandbox[problem.function](...test.input);
      console.log(...test.input);
    } catch (e) {
      return res.json({
        success: false,
        passed: passed,
        total: problem.test_cases.length,
        input: `${test.input}`,
        output: `${e.message}`,
        expected: `${test.output}`,
      });
    }
    if (problem.test_print) {
      if (logs.length < i + 1) {
        logs.push("No output");
      }
      if (`${logs[logs.length - 1]}` !== `${test.output}`) {
        return res.json({
          success: false,
          passed: passed,
          total: problem.test_cases.length,
          input: `${test.input}`,
          output: `${logs[logs.length - 1]}`,
          expected: `${test.output}`,
        });
      }
    } else {
      if (result !== test.output) {
        return res.json({
          success: false,
          passed: passed,
          total: problem.test_cases.length,
          input: `${test.input}`,
          output: `${result}`,
          expected: `${test.output}`,
        });
      }
    }
    passed.push(test);
  }
  console.log = temp;

  return res.status(200).json({
    success: true,
    passed: passed,
    total: problem.test_cases.length,
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
