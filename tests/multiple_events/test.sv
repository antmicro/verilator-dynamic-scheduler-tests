module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   event eventA;
   event eventB;
   event eventC;

   initial begin
     #1;
     $write("Triggering event A!\n");
     ->eventA;
     #1;
     $write("Triggering event B!\n");
     ->eventB;
     #1;
     $write("Triggering event C!\n");
     ->eventC;
   end

   initial begin
     for (int i = 0; i < 3; i++) begin
        $write("Waiting for event A, B, or C...\n");
        @(eventA, eventB, eventC);
        $write("Got the event!\n");
     end
     $write("*-* All Finished *-*\n");
     $finish;
   end
endmodule
