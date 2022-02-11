module t;
   /* verilator lint_off UNOPTFLAT */
   logic clk = 0;
   int   cyc = 0;

   always #1 clk = ~clk;

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
