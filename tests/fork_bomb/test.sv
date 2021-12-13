module t;
    int counter = 0;

    // As Verilator doesn't support recursive calls, let's use macros to
    // generate functions for a deep call stack
    `define FORK2_END(i) \
    task fork2_``i; \
        $write("[%0t] at fork end\n", $time); \
        #1 counter++; \
    endtask

    `define FORK2(i, j) \
    task fork2_``i; \
        fork \
            begin \
                $write("[%0t] starting process [%0d]\n", $time, i); \
                #1 fork2_``j; \
                #1 $write("[%0t] ending process [%0d]\n", $time, i); \
            end \
            begin \
                $write("[%0t] starting process [%0d]\n", $time, i); \
                #1 fork2_``j; \
                #1 $write("[%0t] ending process [%0d]\n", $time, i); \
            end \
        join \
    endtask

    `FORK2_END(0);
    `FORK2(1, 0);
    `FORK2(2, 1);
    `FORK2(3, 2);
    `FORK2(4, 3);
    `FORK2(5, 4);
    `FORK2(6, 5);
    `FORK2(7, 6);
    `FORK2(8, 7);

    initial begin
        fork2_8;
        $write("---> counter = %0d\n", counter);
        $write("*-* All Finished *-*\n");
        $finish;
    end
endmodule
