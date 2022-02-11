module delay_anyedge ();
    reg flag_a;
    reg flag_b;
    logic clk = 0;
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
        #10;
        $display("[%0t] a <= 1", $time);
        flag_a <= 1'b1;
        #20;
        $display("[%0t] b <= 1", $time);
        flag_b <= 1'b1;
    end
    always @(flag_a)
    begin
        $display("[%0t] Checking if b == 0", $time);
        if (flag_b !== 1'b0) $stop;
        #30;
        $display("[%0t] Checking if b == 1", $time);
        $display("[%0t] b == %b", $time, flag_b);
        if (flag_b !== 1'b1) $stop;
        #60;
        $finish;
    end
endmodule

