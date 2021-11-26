module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   event wake1;
   event wake2;
   event wake3;
   event finish;

   initial begin
      fork
         begin
            #1 $write("process 1\n");
            ->wake2;
            #1 @wake1 $write("process 1 again\n");
            ->wake3;
         end
         begin
            @wake2;
            #1 $write("process 2\n");
            ->wake3;
            @wake2 #1 $write("process 2 again\n");
            ->wake1;
         end
         begin
            @wake3 #1 $write("process 3\n");
            ->wake2;
            @wake3 $write("process 3 again\n");
            $write("*-* All Finished *-*\n");
            ->finish;
         end
         @finish $finish;
      join_none
   end
endmodule
