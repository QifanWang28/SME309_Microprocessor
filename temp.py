with open('input.txt', 'r') as file:
    # 读取所有行
    lines = file.readlines()


# 打印所有行
for line in lines:
    if line != '\n':
        print("repeat_part = [repeat_part," + line[:-2]+"];\n", end='')
    else:
        print()
    
