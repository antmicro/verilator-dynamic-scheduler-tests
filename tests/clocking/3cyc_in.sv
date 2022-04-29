// Testbench
module tb;
   localparam WIDTH = 8;  // Tested signal width
   localparam PERIOD = 10;  // Clock period
   localparam DFF_DELAY = 1;  // Delay after which flip flop sets output
   localparam INV_DELAY = DFF_DELAY+2;  // Delay after which inverter inverts signal
   localparam INPUT_SKEW = 3*PERIOD-(DFF_DELAY+(INV_DELAY-DFF_DELAY)/2);  // Clocking block input skew
   localparam OUTPUT_SKEW = 2;  // Clocking block output skew

   logic [WIDTH-1:0] D, A, Q;

   dff #(WIDTH, DFF_DELAY) dut1(.Q(A), .*);
   inv #(WIDTH, INV_DELAY) dut2(.*);

   logic clk = 1'b1;
   always #(PERIOD/2) clk = ~clk;

   always @(posedge clk) $display("[%0t]  ------------------  POSEDGE  ------------------", $time);

   default clocking cb @(posedge clk);
      default input #INPUT_SKEW output #OUTPUT_SKEW;
      input Q; 
      output D;
   endclocking

   initial $monitor("[%0t] D=%b,\tA=%b,\tQ=%b,\tcb.Q=%b", $time, D, A, Q, cb.Q);

   initial
      begin
         $display("\n================");
         $display("  input skew: #%0d", INPUT_SKEW);
         $display("  output skew: #%0d", OUTPUT_SKEW);
         $display("================\n");
         cb.D <= '0;
         ##2
         for (int i = 1; i <= WIDTH; i++) begin
`ifdef VERILATOR
            @(posedge clk)
`else
            ##1
`endif
            cb.D <= 1<<i;
         end 
         ##4
         $finish;
      end

endmodule
