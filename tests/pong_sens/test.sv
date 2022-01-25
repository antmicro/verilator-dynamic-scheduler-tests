module t;
   event ping;
   event pong;

   int cnt = 0;

   always @ping
       begin
           $write("ping\n");
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

   initial ->ping;
endmodule
