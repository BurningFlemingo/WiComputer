with open("wic.hex") as f: 
    formatted: str = "";
    for line in f: 
        line = line.strip("\n")
        for i in range(0, len(line), 2): 
            token: str = 'x"' + line[i:i+2] + '",'
            formatted += token;
    print(formatted)
            
