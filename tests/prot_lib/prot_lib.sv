/* verilator lint_off UNOPT */
/* verilator lint_off COMBDLY */
module prot_lib
   (
    input logic  s1_in,
    output logic s1_out
    );

   initial $display("created %m");

   always @(*) begin
      $display("lib [%0t] %m, s1_in=%b, s1_out=%b", $time, s1_in, s1_out);
      s1_out = s1_in;
   end

   final $display("destroying %m");

endmodule
