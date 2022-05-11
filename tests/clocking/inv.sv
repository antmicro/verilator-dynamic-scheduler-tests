// Delayed inverter
module inv #(
    parameter WIDTH = 8,
    parameter DELAY = 0
) (
    input logic clk,
    input logic [WIDTH-1:0] A, 
    output logic [WIDTH-1:0] Q
);
   always @(posedge clk) #DELAY Q = ~A;
endmodule
