module t(/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;

   logic clk_copy;

   assign clk_copy = clk;

   initial begin
      $write("[%0t] start; clk == %b\n", $time, clk);
      @clk;
      $write("[%0t] any edge; clk == %b\n", $time, clk);
      @clk;
      $write("[%0t] any edge; clk == %b\n", $time, clk);
      @(negedge clk);
      $write("[%0t] negedge; clk == %b\n", $time, clk);
      @(negedge clk);
      $write("[%0t] negedge; clk == %b\n", $time, clk);
      @(posedge clk);
      $write("[%0t] posedge; clk == %b\n", $time, clk);
      @(posedge clk);
      $write("[%0t] posedge; clk == %b\n", $time, clk);
      @(posedge clk, negedge clk_copy);
      $write("[%0t] posedge or negedge; clk == %b\n", $time, clk);
      @(posedge clk or negedge clk_copy);
      $write("[%0t] posedge or negedge; clk == %b\n", $time, clk);
      $write("*-* All Finished *-*\n");
      $finish;
   end

endmodule
