module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;
   int a = 0;
   int b = 0;
   int c = 0;
   event cont;

   initial begin
     $write("Starting with a == 0, b == 0, c == 0\n");
     @cont
     #100;
     $write("Assigning 1 to b.\n");
     b = 1;
     #100;
     $write("Assigning 2 to a.\n");
     a = 2;
     @cont
     #100;
     $write("Assigning 3 to c.\n");
     c = 3;
     #100;
     $write("Assigning 4 to c.\n");
     c = 4;
     @cont
     #100;
     $write("Assigning 5 to b.\n");
     b = 5;
   end

   initial begin
     #10
     $write("Waiting for a > b...\n");
     ->cont;
     wait(a > b);
     $write("Waited for a > b.\n");
     $write("Waiting for a + b < c...\n");
     ->cont;
     wait(a + b < c);
     $write("Waited for value a + b < c.\n");
     $write("Waiting for a < b && b > c...\n");
     ->cont;
     wait(a < b && b > c);
     $write("Waited for a < b && b > c.\n");
     $write("*-* All Finished *-*\n");
     $finish;
   end
endmodule
