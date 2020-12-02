module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   event wake1;
   event wake2;
   event wake3;

   initial begin
      fork
         begin
            #1000000;
            $write("process 1\n");
            ->wake2;
            @wake1;
            $write("process 1 again\n");
            ->wake3;
         end
         begin
            @wake2;
            $write("process 2\n");
            ->wake3;
            @wake2;
            $write("process 2 again\n");
            ->wake1;
         end
         begin
            @wake3;
            $write("process 3\n");
            ->wake2;
            @wake3;
            $write("process 3 again\n");
            $write("*-* All Finished *-*\n");
            $finish;
         end
      join_none
   end
endmodule
