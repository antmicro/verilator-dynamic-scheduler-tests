module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   event m_event, m_event_2;
   reg a=0;

   
   initial begin
    fork
     begin
         #1;
         $write("Will trigger the event in #100\n");
         #100;
         $write("triggering!\n");
         ->m_event;
     end
     join
   end

   initial begin
     fork
     begin
         $write("Will wait for the event here...\n");
         @m_event;
         a = 1;
         $write("Got the event!\n");
     end
     begin
        @m_event_2;
        $write("*-* All Finished *-*\n");
        $finish;
     end
     join
   end
   
   always @(a) begin
     if(a) begin
           #100
         ->m_event_2;
        
     end
   end
   
endmodule
