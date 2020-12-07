module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;

   initial begin
      fork
         begin
            $write("forked process\n");
         end
         begin
            $write("forked process\n");
         end
         begin
            $write("forked process\n");
         end
      join
      $write("main process\n");
      $write("*-* All Finished *-*\n");
      $finish;
   end
endmodule
