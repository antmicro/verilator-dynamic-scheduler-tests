module t(clk);
   input clk;

   integer cyc = 0;

   reg [7:0] a;
   reg [127:0] b;

   always @ (posedge clk) begin
      cyc <= cyc + 1;
      if (cyc == 0) begin
         a <= 8'hFF;
         a[7] <= 1'b0;
      end
      else if (cyc == 1) begin
         $write("a = %x\n", a);
         if (a != 8'h7F) $stop;
      end
      else if (cyc == 2) begin
         b <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
         b[127] <= 1'b0;
      end
      else if (cyc == 3) begin
         $write("b = %x\n", b);
         if (b != 128'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) $stop;
      end
      else if (cyc > 3) begin
         $write("*-* All Finished *-*\n");
         $finish;
      end
   end

endmodule

/*module t(clk);
   input clk;

   integer cyc = 0;

   reg [127:0] a;

   always @ (posedge clk) begin
      cyc <= cyc + 1;
      if (cyc == 0) begin
         a <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
         a[127] <= 1'b0;
      end
      else if (cyc == 1) begin
         $write("a = %x\n", a);
         if (a != 128'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) $stop;
      end
      else if (cyc > 1) begin
         $write("*-* All Finished *-*\n");
         $finish;
      end
   end

endmodule
*/
