
from operator import neg
import random

def max_array():
    test_print = False
    input_size = (1, 1000)
    input_range = (-1000, 1000)
    num_cases = 98

    cases = []

    for i in range(num_cases):
        input = []
        output = {}
        for _j in range(random.randint(input_size[0], input_size[1])):
            input.append(random.randint(input_range[0], input_range[1]))
        output["input"] = [input]
        output["output"] = max(input)
        cases.append(output)
    
    f = open("cases.txt", "w")
    f.write(str(cases))
    f.close()


def palindromes():
    num_cases = 90
    input_size = (1, 1000)

    cases = []

    for i in range(num_cases):
        case = {"input": ""}
        if random.random() < 0.5:
            for j in range(random.randint(input_size[0], input_size[1] / 2)):
                case["input"] += chr(random.randint(97, 122))
            case["input"] += case["input"][::-1]
            case["input"] = [case["input"]]
            case["output"] = "true"
            cases.append(case)
        else:
            for j in range(random.randint(input_size[0], input_size[1])):
                case["input"] += chr(random.randint(97, 122))
            case["input"] = [case["input"]]
            case["output"] = "false"
            cases.append(case)
    
    f = open("cases.txt", "w")
    f.write(str(cases))
    f.close()

def squares():
    num_cases = 90
    input_range = (1, 100000)

    cases = []

    for i in range(num_cases):
        case = {}

        if random.random() < 0.5:
            case["input"] = [random.randint(input_range[0], int(input_range[1]**0.5))**2]
            case["output"] = "true"
            cases.append(case)
        else:
            case["input"] = [random.randint(input_range[0], int(input_range[1]**0.5))]
            case["output"] = "false"
            for i in range(int(case["input"][0]**0.5)):
                if i * i == case["input"][0]:
                    case["output"] = "true"
                    break
                if i * i > case["input"][0]:
                    break
            cases.append(case)
        
    f = open("cases.txt", "w")
    f.write(str(cases))
    f.close()

def array_diff():
    num_cases = 96
    input_size = (2, 1000)
    input_range = (-1000, 1000)

    cases = []

    for i in range(num_cases):
        case = {}
        arr = []
        cmin = 0
        cmax = 0
        for j in range(random.randint(input_size[0], input_size[1])):
            num = random.randint(input_range[0], input_range[1])
            cmin = min(cmin, num)
            cmax = max(cmax, num)
            arr.append(num)
        case["input"] = [arr]
        case["output"] = cmax - cmin
        
        cases.append(case)
    
    f = open("cases.txt", "w")
    f.write(str(cases))
    f.close()

def negate_array():
    num_cases = 100
    input_size = (0, 1000)
    input_range = (-1000, 1000)

    cases = []

    for i in range(num_cases):
        case = {}
        arr = []
        ans = []
        for j in range(i):
            num = random.randint(input_range[0], input_range[1])
            ans.append(-num)
            arr.append(num)
        case["input"] = [arr]
        case["output"] = ans
        
        cases.append(case)
    
    f = open("cases.txt", "w")
    f.write(str(cases))
    f.close()

def main():
    random.seed(None)
    
    negate_array()

if __name__ == "__main__":
    main()