module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   event eventA;
   event eventB;
   event eventC;
   event cont;

   initial begin
     @cont;
     #100;
     $write("Triggering event A!\n");
     ->eventA;
     @cont;
     #100;
     $write("Triggering event B!\n");
     ->eventB;
     @cont;
     #100;
     $write("Triggering event C!\n");
     ->eventC;
   end

   initial begin
     for (int i = 0; i < 3; i++) begin
        #100;
        $write("Waiting for event A, B, or C...\n");
        ->cont;
        @(eventA, eventB, eventC);
        $write("Got the event!\n");
     end
     $write("*-* All Finished *-*\n");
     $finish;
   end
endmodule
