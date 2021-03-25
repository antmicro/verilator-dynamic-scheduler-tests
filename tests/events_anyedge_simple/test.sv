module delay_anyedge ();
    reg flag_a;
    reg flag_b;
    logic clk = 1;
    initial
      forever
      begin
        #20;
        clk = ~clk;
      end
    always @(posedge clk)
    begin
        flag_b <= 1'b0;
        #5;
        flag_a <= 1'b1;
        #10;
        flag_b <= 1'b1;
    end
    always @(flag_a)
    begin
        if (flag_b !== 1'b0) $stop;
        #25;
        if (flag_b !== 1'b1) $stop;
        $finish;
    end
endmodule
