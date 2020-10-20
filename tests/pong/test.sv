/* verilator lint_off INFINITELOOP */
module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   event ping;
   event pong;

   initial begin
      # 100;
       ->pong;

       forever begin
           $write("ping\n");
           @ping;
           ->pong;
       end
   end

   initial begin
       int cnt;
       forever begin
           @pong;
           $write("pong\n");
           cnt++;
           if (cnt >= 10) begin
               $write("*-* All Finished *-*\n");
               $finish;
           end else begin
               ->ping;
           end
       end
   end
endmodule
