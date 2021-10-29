module delay_anyedge ();
    reg flag_a;
    reg flag_b;
    logic clk = 1;
    initial
      forever
      begin
        #20;
        clk = ~clk;
        $display("[%0t] clk=%0d", $time, clk);
      end
    always @(posedge clk)
    begin
        $display("[%0t] b <= 0", $time);
        flag_b <= 1'b0;
        #5;
        $display("[%0t] a <= 1", $time);
        flag_a <= 1'b1;
        #10;
        $display("[%0t] b <= 1", $time);
        flag_b <= 1'b1;
    end
    always @(flag_a)
    begin
        $display("[%0t] Checking if b == 0", $time);
        if (flag_b !== 1'b0) $stop;
        #25;
        $display("[%0t] Checking if b == 1", $time);
        if (flag_b !== 1'b1) $stop;
        #1;
        $finish;
    end
endmodule
