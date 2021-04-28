module t(/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;

   int cyc = 0;

   logic sig = 0;
   event ev;

   always @(posedge clk) begin
      cyc <= cyc + 1;
      if (cyc == 2) ->ev;
      else if (cyc == 4) sig = 1;
      else if (cyc == 6) begin
         $write("*-* All Finished *-*\n");
         $finish;
      end
   end

   initial begin
      @(posedge sig, ev);
      $write("[%0t] Got posedge sig or event\n", $time);
      @(posedge sig, ev);
      $write("[%0t] Got posedge sig or event\n", $time);
   end

endmodule
