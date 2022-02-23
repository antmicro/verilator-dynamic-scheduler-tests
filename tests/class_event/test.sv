class EventClass;
    event e;
endclass

module t;
    EventClass ec = new;

    initial begin
        @ec.e;
        #1;
        $write("*-* All Finished *-*\n");
        $finish;
    end

    initial #1 ->ec.e;

    always @ec.e $write("triggered!\n");
endmodule
