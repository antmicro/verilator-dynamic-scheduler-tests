/* verilator lint_off INFINITELOOP */
module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   event ping;
   event pong;


   initial begin
       forever begin
           @ping;
           $write("ping\n");
           ->pong;
       end
   end

   initial begin
       int cnt;
       # 100;
       ->ping;

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
