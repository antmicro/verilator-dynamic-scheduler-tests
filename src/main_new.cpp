#include <verilated.h>
#include <Vtop.h>

uint64_t main_time = 0;
double sc_time_stamp() { return main_time; }

int main(int argc, char *argv[]) {
    Verilated::commandArgs(argc, argv);
    Vtop *top = new Vtop;
    while (!Verilated::gotFinish()) {
        top->eval();
        main_time = top->nextTimeSlot();
    }
    top->final();
    delete top;
    return 0;
}
