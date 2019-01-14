PROGS=gcd loops print_arg emptyloop fibo_iter fib
CLANG_I386=clang-3.6 -m32
CLANG_BC=clang-3.6 -emit-llvm
LLVM_LINK=llvm-link-3.6

I386_O0_OBJS=$(patsubst %,%.i386.O0.o,$(PROGS))
I386_O2_OBJS=$(patsubst %,%.i386.O2.o,$(PROGS))
I386_O3_OBJS=$(patsubst %,%.i386.O3.o,$(PROGS))

BC_O0_OBJS=$(patsubst %,%.bc.O0.o,$(PROGS))
BC_O2_OBJS=$(patsubst %,%.bc.O2.o,$(PROGS))

SRCS=$(patsubst %,%.c,$(PROGS))
I386_OBJS=$(I386_O0_OBJS) $(I386_O2_OBJS) $(I386_O3_OBJS)
BC_OBJS=$(BC_O0_OBJS) $(BC_O2_OBJS)

all: main.i386.O0 main.i386.O2 main.i386.O3 main.bc.O0 main.bc.O2

$(I386_O3_OBJS): %.i386.O3.o: %.c
	$(CLANG_I386) $^ -O3 -c -o $@

$(I386_O2_OBJS): %.i386.O2.o: %.c
	$(CLANG_I386) $^ -O2 -c -o $@

$(I386_O0_OBJS): %.i386.O0.o: %.c
	$(CLANG_I386) $^ -O0 -c -o $@

$(BC_O2_OBJS): %.bc.O2.o: %.c
	$(CLANG_BC) $^ -O2 -c -o $@

$(BC_O0_OBJS): %.bc.O0.o: %.c
	$(CLANG_BC) $^ -O0 -c -o $@

main.i386.o: main.c
	$(CLANG_I386) $^ -O3 -c -o $@

main.bc.o: main.c
	$(CLANG_BC) $^ -O3 -c -o $@

main.i386.O0: $(I386_O0_OBJS) main.i386.o
	$(CLANG_I386) $^ -o $@

main.i386.O2: $(I386_O2_OBJS) main.i386.o
	$(CLANG_I386) $^ -o $@

main.i386.O3: $(I386_O3_OBJS) main.i386.o
	$(CLANG_I386) $^ -o $@

main.bc.O0: $(BC_O0_OBJS) main.bc.o
	$(LLVM_LINK) $^ -o $@

main.bc.O2: $(BC_O2_OBJS) main.bc.o
	$(LLVM_LINK) $^ -o $@

clean::
	rm -f main.i386* main.bc* $(I386_OBJS) $(BC_OBJS)
