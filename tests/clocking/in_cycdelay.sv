// Testbench
module tb;
   localparam WIDTH = 8;  // Tested signal width
   localparam PERIOD = 10;  // Clock period
   localparam DFF_DELAY = 1;  // Delay after which flip flop sets output
   localparam INV_DELAY = DFF_DELAY+2;  // Delay after which inverter inverts signal
   localparam INPUT_SKEW = PERIOD-(DFF_DELAY+(INV_DELAY-DFF_DELAY)/2);  // Clocking block input skew

   logic [WIDTH-1:0] D, A, Q;

   dff #(WIDTH, DFF_DELAY) dut1(.Q(A), .*);
   inv #(WIDTH, INV_DELAY) dut2(.*);

   logic clk = 1'b1;
   always #(PERIOD/2) clk = ~clk;

   always @(posedge clk) $display("[%0t]  ------------------  POSEDGE  ------------------", $time);

   default clocking cb @(posedge clk);
      default input #INPUT_SKEW;
      input Q; 
   endclocking

   initial $monitor("[%0t] D=%b,\tA=%b,\tQ=%b,\tcb.Q=%b", $time, D, A, Q, cb.Q);

   initial
      begin
         $display("\n================");
         $display("  input skew: #%0d", INPUT_SKEW);
         $display("================\n");
         D <= '0;
         ##2
         for (int i = 1; i <= WIDTH; i++) begin
            ##1 D <= 1<<i;
         end 
         ##4
         $finish;
      end

endmodule
