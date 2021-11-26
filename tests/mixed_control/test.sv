module t(/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;

   int cyc = 0;

   logic sig1 = 0;
   logic sig2 = 1;
   event ev;

   always @(posedge clk) begin
      cyc <= cyc + 1;
      if (cyc == 2) ->ev;
      else if (cyc == 4) sig1 = 1;
      else if (cyc == 6) sig2 = 0;
      else if (cyc == 7) sig1 = 0;
      else if (cyc == 8) sig1 = 1;
      else if (cyc == 10) begin
         $write("*-* All Finished *-*\n");
         $finish;
      end
   end

   initial begin
      @(posedge sig1, ev)
      $write("[%0t] Got posedge sig1 or event\n", $time);
      @(posedge sig1, ev)
      $write("[%0t] Got posedge sig1 or event\n", $time);
      @(posedge sig1, negedge sig2)
      $write("[%0t] Got posedge sig1 or negedge sig2\n", $time);
      @(posedge sig1, negedge sig2)
      $write("[%0t] Got posedge sig1 or negedge sig2\n", $time);
   end

endmodule
