module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   int value = 0;
   event cont;

   initial begin
     $write("Starting with value == 0\n");
     @cont;
     #100;
     $write("Assigning 1 to value.\n");
     value = 1;
     #100;
     $write("Assigning 2 to value.\n");
     value = 2;
     @cont;
     #100;
     $write("Assigning 0 to value.\n");
     value = 0;
     @cont;
     #100;
     $write("Assigning 2 to value.\n");
     value = 2;
   end

   initial begin
     #10;
     $write("Waiting for value == 2...\n");
     ->cont;
     wait(value == 2);
     $write("Waited for value == 2.\n");
     #10;
     $write("Waiting for value < 2...\n");
     ->cont;
     wait(value < 2);
     $write("Waited for value < 2.\n");
     #10;
     $write("Waiting for value == 0...\n");
     wait(value == 0);
     $write("Waited for value == 0.\n");
     #10;
     $write("Waiting for 1 < value < 3...\n");
     ->cont;
     wait(value > 1 && value < 3);
     $write("Waited for 1 < value < 3.\n");
     $write("*-* All Finished *-*\n");
     $finish;
   end
endmodule
