module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   int cnt;

   logic clk_generated = 0;
   int  cyc;

   initial begin
      $write("Simple 1\n");
      #50;
      $write("Simple 1 post delay\n");
   end

   initial begin
      #70;
      $write("Simple 2\n");
      #70;
      $write("Simple 2 post delay\n");
   end

   initial begin
      clk_generated = 1;
      forever begin
         #5 clk_generated = ~clk_generated;
      end
   end

   always @ (posedge clk_generated) begin
      cyc = cyc + 1;
      if (cyc % 2 == 0) begin
         $write("+\n");
      end else begin
         $write("-\n");
      end

      if (cyc > 20) begin
         $write("*-* All Finished *-*\n");
         $finish;
      end
   end

endmodule
