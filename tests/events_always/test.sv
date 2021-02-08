// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2003 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0

module t(/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;

   event e1;
   event e2;

   int   cyc;

   int last_event;
   always @(e1) begin
      $write("[%0t] e1\n", $time);
      if (!e1.triggered) $stop;
      last_event[1] = 1;
   end

   always @(e2) begin
      $write("[%0t] e2\n", $time);
      last_event[2] = 1;
   end

   always @(posedge clk) begin
      $write("[%0t] cyc=%0d last_event=%5b\n", $time, cyc, last_event);
      cyc <= cyc + 1;
      if (cyc == 1) begin
         if (last_event != 0) $stop;
      end
      else if (cyc == 2) begin
         -> e1;
         if (!e1.triggered) $stop;
      end
      else if (cyc == 3) begin
         if (last_event != 32'b10) $stop;
         -> e2;
      end
      else if (cyc == 4) begin
         if (last_event != 32'b110) $stop;
      end
      else if (cyc == 5) begin
         $write("*-* All Finished *-*\n");
         $finish;
      end
   end

endmodule
