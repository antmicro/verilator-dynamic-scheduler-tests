module top (/*AUTOARG*/
   );
   logic clk;
   reg   ready;
   initial begin
      ready = 1'b0;
   end
   always @(posedge ready) begin
      if ((ready === 1'b1)) begin
         $write("*-* All Finished *-*\n");
         $finish;
      end
   end
   always @(posedge ready) begin
      if ((ready === 1'b0)) begin
         ready = 1'b1 ;
      end
   end
   always @(posedge clk) begin
      ready = 1'b1;
   end
   initial begin
      #10;
      clk = 0;
      #10;
      clk = 1;
      #10;
      clk = 0;
      #10;
      clk = 1;
      #10;
      clk = 0;
      #10;
      clk = 1;
      #10;
      clk = 0;
      #10;
      clk = 1;
   end
endmodule
