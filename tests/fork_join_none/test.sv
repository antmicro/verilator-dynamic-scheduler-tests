module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;

   initial begin
      fork
         begin
            #1;
            $write("forked process\n");
            $write("*-* All Finished *-*\n");
            $finish;
         end
      join_none
      $write("main process\n");
   end
endmodule
