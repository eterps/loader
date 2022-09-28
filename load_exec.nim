import posix

let MAP_ANONYMOUS {.importc: "MAP_ANONYMOUS", header: "<sys/mman.h>".}: cint

# load raw binary x86-64 instructions
let code = read_file("hello_rel.bin")

# create an executable buffer
let buf = mmap(nil, code.len, PROT_READ or PROT_WRITE or PROT_EXEC,
  MAP_PRIVATE or MAP_ANONYMOUS, -1, 0)

# copy machine code instructions to allocated buffer:
copy_mem(buf, code[0].unsafe_addr, code.len)

# bind address of machine code to function identifier:
let exec_code = cast[proc() {.nimcall.}](buf)

# call the function to execute the code
exec_code()

discard munmap(buf, code.len)
