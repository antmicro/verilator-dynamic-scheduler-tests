virtual class Delay;
    pure virtual task do_delay;
    pure virtual task do_sth;
endclass

`define DELAY(dt) \
class Delay``dt extends Delay; \
    virtual task do_delay; \
        $write("Starting a #%0d delay\n", dt); \
        #dt \
        $write("Ended a #%0d delay\n", dt); \
    endtask \
    virtual task do_sth; \
        $write("Task with no delay\n"); \
    endtask \
endclass

class NoDelay extends Delay;
    virtual task do_delay;
        $write("Task with no delay\n");
    endtask
    virtual task do_sth;
        $write("Task with no delay\n");
    endtask
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
        NoDelay dNo = new;
        printtime;
        delay = d10;
        delay.do_delay;
        delay.do_sth;
        printtime;
        delay = d20;
        delay.do_delay;
        delay.do_sth;
        printtime;
        delay = d40;
        delay.do_delay;
        delay.do_sth;
        printtime;
        delay = d80;
        delay.do_delay;
        delay.do_sth;
        printtime;
        delay = dNo;
        delay.do_delay;
        delay.do_sth;
        printtime;
        $write("*-* All Finished *-*\n");
        $finish;
    end
endmodule
