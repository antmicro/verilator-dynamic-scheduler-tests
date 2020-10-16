module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   event m_event;

   initial begin
     #100;
     $write("Will trigger the event in #100\n");
     #100;
     $write("triggering!\n");
     ->m_event;
   end

   initial begin
     #10
     $write("Will wait for the event here...\n");
     @m_event;
     $write("Got the event!\n");
     $write("*-* All Finished *-*\n");
     $finish;
   end
endmodule
