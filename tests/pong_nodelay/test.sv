module t;
   event ping;
   event pong;

   int cnt = 0;

   initial
       forever begin
           @ping $write("ping\n");
           ->pong;
       end

   initial
       forever begin
           @pong $write("pong\n");
           cnt++;
           if (cnt >= 10) begin
               $write("*-* All Finished *-*\n");
               $finish;
           end else ->ping;
       end

   initial #1 ->ping;
endmodule
