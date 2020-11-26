module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   event eventA;
   event eventB;
   event eventC;

   initial begin
     $write("Will trigger event A in #100\n");
     #100;
     $write("Triggering event A!\n");
     ->eventA;
     $write("Will trigger event B in #100\n");
     #100;
     $write("Triggering event B!\n");
     ->eventB;
     $write("Will trigger event C in #100\n");
     #100;
     $write("Triggering event C!\n");
     ->eventC;
   end

   initial begin
     for (int i = 0; i < 3; i++) begin
        #10
        $write("Waiting for event A, B, or C...\n");
        @(eventA, eventB, eventC);
        $write("Got the event!\n");
     end
     $write("*-* All Finished *-*\n");
     $finish;
   end
endmodule
