import posix

const
  MAP_ANONYMOUS = 0x20

var code = [                             # x86-64 function
  0x48'u8, 0xb8, 1, 0, 0, 0, 0, 0, 0, 0, # mov rax, 1
  0x48, 0xbf, 0x01, 0, 0, 0, 0, 0, 0, 0, # mov rdi, 1
  0x48, 0x8d, 0x35, 13, 0, 0, 0,         # lea rsi, [rel "!"]
  0x48, 0xba, 0x0e, 0, 0, 0, 0, 0, 0, 0, # mov rdx, 14
  0x0f, 0x05,                            # syscall
  0xc3,                                  # ret
  0x21]                                  # exclamation mark: "!"

# allocate memory buffer for executable machine code:
var mem = mmap(nil,
  code.len,
  PROT_READ or PROT_WRITE or PROT_EXEC,
  MAP_PRIVATE or MAP_ANONYMOUS,
  -1,
  0)

# copy machine code instructions to allocated buffer:
copy_mem(mem, addr code[0], code.len)

# bind address of machine code to function identifier:
var write_bang = cast[proc() {.nimcall.}](mem)

# call the function (writes '!' to stdout):
write_bang()

discard munmap(mem, code.len)
