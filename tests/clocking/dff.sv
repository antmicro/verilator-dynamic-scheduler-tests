// D flip flop
module dff #(
    parameter WIDTH = 8,
    parameter DELAY = 0
) (
    input logic clk,
    input logic [WIDTH-1:0] D, 
    output logic [WIDTH-1:0] Q
);
   always @(posedge clk) #DELAY Q = D;
endmodule
