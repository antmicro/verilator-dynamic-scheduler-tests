module t;
    localparam N = 100;

    event events[N-1:0];

    initial begin
        for (int i = 0; i < N; i++) begin
            @events[i];
            $write("Triggered %d\n", i);
        end
        $write("*-* All Finished *-*\n");
        $finish;
    end

    initial begin
        for (int i = 0; i < N; i++)
            #1 ->events[i];
    end
endmodule
