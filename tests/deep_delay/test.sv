module t;
    // As Verilator doesn't support recursive calls, let's use macros to
    // generate functions for a deep call stack
    `define DEEP_DELAY_END(i) \
    task deep_delay``i; \
        $write("[%0t] at depth %0d\n", $time, i); \
    endtask

    `define DEEP_DELAY(i, j) \
    task deep_delay``i; \
        $write("[%0t] entering depth %0d\n", $time, i); \
        #1 deep_delay``j(); \
        #1 $write("[%0t] leaving depth %0d\n", $time, i); \
    endtask

    `DEEP_DELAY_END(10);
    `DEEP_DELAY(9, 10);
    `DEEP_DELAY(8, 9);
    `DEEP_DELAY(7, 8);
    `DEEP_DELAY(6, 7);
    `DEEP_DELAY(5, 6);
    `DEEP_DELAY(4, 5);
    `DEEP_DELAY(3, 4);
    `DEEP_DELAY(2, 3);
    `DEEP_DELAY(1, 2);

    initial begin
        deep_delay1;
        $write("*-* All Finished *-*\n");
        $finish;
    end
endmodule
