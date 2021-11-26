module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   event e1, e2;
   reg a=0;

   
   initial begin
    fork
     begin
         #1;
         $write("Will trigger the event in #100\n");
         #100;
         $write("triggering!\n");
         ->e1;
     end
     join
   end

   initial begin
     fork
     begin
         $write("Will wait for the event here...\n");
         @e1 a = 1;
         $write("Got the event!\n");
     end
     begin
        @e2;
        $write("*-* All Finished *-*\n");
        $finish;
     end
     join
   end
   
   always @(a) begin
     if (a) begin
         #100 ->e2;
     end
   end
   
endmodule
