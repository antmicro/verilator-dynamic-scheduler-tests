module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   int value = 0;

   initial begin
     $write("Starting with value == 0\n");
     #100;
     $write("Assigning 1 to value.\n");
     value = 1;
     #100;
     $write("Assigning 2 to value.\n");
     value = 2;
     #100;
     $write("Assigning 4 to value.\n");
     value = 4;
     #100;
     $write("Assigning 2 to value.\n");
     value = 2;
   end

   initial begin
     #10
     $write("Waiting for value == 2...\n");
     wait(value == 2);
     $write("Waited for value == 2.\n");
     $write("Waiting for value > 3...\n");
     wait(value > 3);
     $write("Waited for value > 3.\n");
     $write("Waiting for value == 4...\n");
     wait(value == 4);
     $write("Waited for value == 4.\n");
     $write("Waiting for 1 < value < 3...\n");
     wait(value > 1 && value < 3);
     $write("Waited for 1 < value < 3.\n");
     $write("*-* All Finished *-*\n");
     $finish;
   end
endmodule
