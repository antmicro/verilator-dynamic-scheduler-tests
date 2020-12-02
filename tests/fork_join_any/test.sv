module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   event cont;

   initial begin
      fork
         begin
            $write("forked process 1\n");
         end
         begin
            @cont;
            $write("forked process 2\n");
            $write("*-* All Finished *-*\n");
            $finish;
         end
      join_any
      $write("main process\n");
      ->cont;
   end
endmodule
