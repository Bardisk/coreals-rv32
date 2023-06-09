main:
  andi x5, x0, 0x0
	andi x6, x0, 0x0
	lui x2, 0x88888
	lw x3, 0x8(x6)
	sw x3, 0x4(x5)
	lw x1, 0x4(x0) 
nochange:
	lw x7, 0x1c(x0)
	beq x7, x3, cmd_add
	lui x1,0x55555
	slt x1,x1,x7
	bne x1,x0,nochange
	cmd_add:add x5, x5, x7
	add x6, x6, x2
	bne x6, x5, cmd_sub
	sub x0,x0,x0
	cmd_sub: sub x8,x6,x5
	sub x9,x6,x5
	jal x0, cmd_and
	and x0,x0,x0
cmd_and:
	and x10,x5,x7
	andi x11,x10,0x1 # x11 = 0x0
  bne x10,x11,cmd_or
  or x0,x0,x0
cmd_or:
	or x11,x11,x10 # x11 = 0x80000000
  ori x10,x11,0x1 # x10 = 0x80000001
  beq x11,x5,cmd_xor
  xor x0,x0,x0
cmd_xor:
	xor x12,x11,x10 # x12 = 0x00000001
  xori x12,x12,0x1 # x12 = 0x00000000
  bne x12,x11,cmd_srl
  addi x0,x0,0x0
cmd_srl:
	srli x5,x5,0x1 # x5 = 0x40000000
  beq x12,x0,cmd_sll
  sub x0,x0,x0
cmd_sll:
	slli x5,x5,0x1 # x5 = 0x80000000
  beq x5,x11,cmd_slt
  addi x0,x0,0x0
cmd_slt:
	slt x13,x0,x1 # x13 = 0x0
  sltu x14,x0,x5 # x14 = 0x1
  jal x0,main
