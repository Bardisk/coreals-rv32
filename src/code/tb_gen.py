#!python
# print("memory_initialization_radix=16\nmemory_initialization_vector=")
with open("code.bin", "rb") as f:
  data = f.read(4)
  print(f"inst = 32'h{int.from_bytes(data, byteorder='little'):08x};",end='\n#(CLK_PERIOD)\n')
  while True:
    data = f.read(4)
    if len(data) == 4:
      print(f"inst = 32'h{int.from_bytes(data, byteorder='little'):08x};",end='\n#(CLK_PERIOD)\n')
    else:
      break
#   print(';', end='')
  