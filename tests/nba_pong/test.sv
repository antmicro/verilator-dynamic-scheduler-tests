module t (/*AUTOARG*/
   // Inputs
   first
   );

   input first;

   logic second = 0;

   always @(second) begin
       $write("pong\n");
   end

   integer cyc = 1;

   always @ (posedge first) begin
     $write("ping\n");
     second <= ~second;
     cyc++;
     if (cyc == 5)
         $finish;
   end

endmodule
