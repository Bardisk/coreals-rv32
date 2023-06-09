#!python
print("memory_initialization_radix=16;\nmemory_initialization_vector=")
with open("code.bin", "rb") as f:
  data = f.read(4)
  print(f"{int.from_bytes(data, byteorder='little'):08x}",end='')
  while True:
    data = f.read(4)
    if len(data) == 4:
      print(f",{int.from_bytes(data, byteorder='little'):08x}",end='')
    else:
      break
  print(';', end='')
  