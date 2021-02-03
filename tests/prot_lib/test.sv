`define DRIVE(sig) \
/* verilator lint_off WIDTH */ \
sig``_in <= {8{crc}}; \
/* verilator lint_on WIDTH */
`define CHECK(sig) \
if (cyc > 0 && sig``_in != sig``_out) begin \
   $display(`"%%Error (%m) sig``_in (0x%0x) != sig``_out (0x%0x)`", \
            sig``_in, sig``_out); \
     $stop; \
       end

module top(/*AUTOARG*/
      clk
   );
   input clk;
   localparam last_cyc = 10;

   generate
      for (genvar x = 0; x < 1; x = x + 1) begin: gen_loop
         integer cyc = 0;
         reg [63:0] crc = 64'h5aef0c8d_d70a4497;
         logic        s1_in;
         logic        s1_out;

         prot_lib
           prot_lib (
                   .s1_in,
                   .s1_out
                   );

         always @(posedge clk) begin
            $display("[%0t] %m, cyc=%0d, crc=%x",
                     $time, cyc, crc);
            cyc <= cyc + 1;
            crc <= {crc[62:0], crc[63]^crc[2]^crc[0]};
            `DRIVE(s1)
            $display("drive [%0t] %m, s1_in=%b, s1_out=%b", $time, s1_in, s1_out);
            if (x == 0 && cyc == last_cyc) begin
               $display("final cycle = %0d", cyc);
               $write("*-* All Finished *-*\n");
               $finish;
            end
         end


         always @(*) begin
            #1;
            $display("check [%0t] %m, s1_in=%b, s1_out=%b", $time, s1_in, s1_out);
            `CHECK(s1)
         end
      end
   endgenerate

endmodule
