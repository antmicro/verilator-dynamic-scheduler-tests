module t;
   logic clk;
   int   cyc = 0;

   initial begin
       forever begin
           #1 clk = 1'b1;
           #1 clk = 1'b0;
       end
   end

   always @(negedge clk) begin
      $write("[%0t] negedge; clk == %b\n", $time, clk);
   end

   always @(posedge clk) begin
      cyc <= cyc + 1;
      $write("[%0t] posedge; clk == %b\n", $time, clk);
      if (cyc == 10) begin
         $write("*-* All Finished *-*\n");
         $finish;
      end
   end

endmodule
