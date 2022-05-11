// Testbench
module tb;
   localparam WIDTH = 8;  // Tested signal width
   localparam PERIOD = 10;  // Clock period
   localparam DFF_DELAY = 6;  // Delay after which flip flop sets output
   localparam INV_DELAY = DFF_DELAY+2;  // Delay after which inverter inverts signal
   localparam DEFAULT_OUTPUT_SKEW = 2;  // Default clocking block output skew (should be ignored)
   localparam OUTPUT_SKEW = 4;  // Clocking block output skew

   logic [WIDTH-1:0] D, A, Q;

   dff #(WIDTH, DFF_DELAY) dut1(.Q(A), .*);
   inv #(WIDTH, INV_DELAY) dut2(.*);

   logic clk = 1'b1;
   always #(PERIOD/2) clk = ~clk;

   always @(posedge clk) $display("[%0t]  ------------------  POSEDGE  ------------------", $time);

   default clocking cb @(posedge clk);
      default output #DEFAULT_OUTPUT_SKEW;  // Should be ignored
      output #OUTPUT_SKEW D;
   endclocking

   initial $monitor("[%0t] D=%b,   A=%b,   Q=%b", $time, D, A, Q);

   initial
      begin
         $display("\n================");
         $display("  output skew: #%0d", OUTPUT_SKEW);
         $display("================\n");
         cb.D <= '0;
         for (int i = 1; i <= WIDTH; i++) begin
            @(posedge clk)
            cb.D <= 1<<i;
         end 
         $finish;
      end

endmodule
