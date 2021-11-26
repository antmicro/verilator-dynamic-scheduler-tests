module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   event cont;

   initial begin
      fork
         $write("forked process 1\n");
         begin
            @cont;
            $write("forked process 2\n");
            $write("*-* All Finished *-*\n");
            $finish;
         end
      join_any
      #1;
      $write("main process\n");
      ->cont;
   end
endmodule
