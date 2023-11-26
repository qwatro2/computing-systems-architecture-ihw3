from random import seed, randint, choice

seed(142857)
chars = "qwertyuiopasdfghjklzxcvbnm1234567890"


def gen(min_length: int, max_length: int) -> tuple[int, str]:
    n = randint(3, 6)
    length = randint(min_length, max_length)
    res = ''.join(choice(chars) for _ in range(length))

    return n, res

def solve(n: int, res: str) -> tuple[bool, str]:
    CNT = 1
    BEGIN = 0

    for i in range(1, len(res)):
        if res[i] < res[i - 1]:
            CNT += 1

            if CNT == n:
                return res[BEGIN: i + 1]
        
        else:
            CNT = 1
            BEGIN = i
    
    return "not exists"


def make_test(min_length: int, max_length: int, test_number: int) -> None:
    n, a = gen(min_length, max_length)
    solution = solve(n, a)

    with open(f"./data/test_{test_number}.txt", 'w') as f:
        f.write(a)
    
    print(f'tf{test_number}: .asciz "../data/test_{test_number}.txt"')
    print(f"tn{test_number}: .word {n}")
    print(f'tr{test_number}: .asciz "../data/result_{test_number}.txt"')
    print(f'ta{test_number}: .asciz "{solution}"')

def print_test_asm(i: int):
    s = f'''
TEST{i}:
    la t0 tn{i}
    lw s0 (t0)
    la t0 answer_length
    sw a0 (t0)
    allocate_reg(a0, a0)  # allocate memory for answer
    sw a0 answer t0

    read(tf{i}, TEXT_SIZE)
    
    la	t0 descriptor
    sw  a0 (t0)
    la	t0 buffer
    sw  a1 (t0)
    
    solve(buffer, answer, s0)
    beqz a0 not_exists  # if not_exists, go to branch
    
    write(tr{i}, answer, s0)
    '''

    print(s)

def main():
    make_test(100, 500, 2)
    make_test(10230, 10240, 3)
    make_test(20, 40, 4)
    make_test(5000, 8000, 5)
    print_test_asm(2)
    print_test_asm(3)
    print_test_asm(4)
    print_test_asm(5)

if __name__ == "__main__":
    main()