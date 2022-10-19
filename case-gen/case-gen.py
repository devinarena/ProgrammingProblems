
import random

def main():
    random.seed(None)

    test_print = False
    input_size = (1, 1000)
    input_range = (-1000, 1000)
    num_cases = 98

    cases = []

    for i in range(num_cases):
        input = []
        output = {}
        for _j in range(i+3):
            input.append(random.randint(input_range[0], input_range[1]))
        output["input"] = [input]
        output["output"] = sum(input)
        cases.append(output)
    
    f = open("cases.txt", "w")
    f.write(str(cases))
    f.close()
    


if __name__ == "__main__":
    main()