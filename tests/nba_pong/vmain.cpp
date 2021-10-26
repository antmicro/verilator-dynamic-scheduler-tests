#include <verilated.h>
#include <Vtop.h>
#include <unistd.h>

vluint64_t main_time = 0;
vluint64_t new_time = 0;

double sc_time_stamp() {
	return main_time;
}

void sc_time_stamp(double n) {
	main_time = n;
}

int main(int argc, char *argv[]) {
	Verilated::commandArgs(argc, argv);

	Vtop *top = new Vtop;

	int clk_counter = 0;
	int no_action = 0;

	while (!Verilated::gotFinish() && clk_counter++ < 1000) {
		top->eval();
		top->first = ~top->first;
		main_time++;
	}

	top->final();
	delete top;

	return 0;
}
