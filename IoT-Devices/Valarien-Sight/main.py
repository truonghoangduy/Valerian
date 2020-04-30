bytes_raw = []
fin = open("data.txt", "r")
lines = fin.readlines()
for line in lines:
    byte_line = line.split(' ')
    for byte in byte_line:
        try:
            b = int(byte)
            if b > -1 and b < 256:
                bytes_raw.append(b)
        except:
            None

fin.close()

bytes_arr = bytearray(bytes_raw)

fout = open("image.jpeg", "wb")

fout.write(bytes_arr)

fout.close()
