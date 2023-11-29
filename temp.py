data_list = []
start_index = 20

while True:
    # 输入数据
    input_data = input("输入数据（或输入 'exit' 退出）: ")

    # 检查是否输入 'exit'
    if input_data.lower() == 'exit':
        break

    # 分割输入的数据
    EQ, Rd, Rs, Rm = map(int, input_data.split())

    # 转换为十六进制并去除前缀'0x'
    EQ = hex(EQ)[2:]
    Rd = hex(Rd)[2:]
    Rs = hex(Rs)[2:]
    Rm = hex(Rm)[2:]

    # 构建字符串并添加到列表
    result_str = f"INSTR_MEM[{start_index}] = {EQ}7f{Rd}0{Rs}f{Rm};"
    data_list.append(result_str)

    # 增加索引
    start_index += 1

# 输出所有数据
for data in data_list:
    print(data)
