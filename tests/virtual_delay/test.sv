virtual class Delay;
    pure virtual task do_delay;
endclass

`define DELAY(dt) \
class Delay``dt extends Delay; \
    virtual task do_delay; \
        $write("Starting a #%0d delay\n", dt); \
        #dt \
        $write("Ended a #%0d delay\n", dt); \
    endtask \
endclass

`DELAY(10);
`DELAY(20);
`DELAY(40);
`DELAY(80);

module t;
    task printtime;
        $write("I'm at time %0t\n", $time);
    endtask

    initial begin
        Delay delay;
        Delay10 d10 = new;
        Delay20 d20 = new;
        Delay40 d40 = new;
        Delay80 d80 = new;
        printtime;
        delay = d10;
        delay.do_delay;
        printtime;
        delay = d20;
        delay.do_delay;
        printtime;
        delay = d40;
        delay.do_delay;
        printtime;
        delay = d80;
        delay.do_delay;
        printtime;
        $write("*-* All Finished *-*\n");
        $finish;
    end
endmodule
