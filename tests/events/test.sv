module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   event e;

   initial begin
     #1 $write("Will trigger the event in #100\n");
     #100 $write("Triggering!\n");
     ->e;
     $write("Will wait for the event here...\n");
     @e $write("Got the event!\n");
     $write("*-* All Finished *-*\n");
     $finish;
   end

   initial begin
     $write("Will wait for the event here...\n");
     @e;
     $write("Got the event!\n");
     #1 $write("Will trigger the event in #100\n");
     #100 $write("Triggering!\n");
     ->e;
   end
endmodule
