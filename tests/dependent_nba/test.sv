module t(clk);
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
