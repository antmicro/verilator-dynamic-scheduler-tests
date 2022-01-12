module t;
  int val;
  always @val $write("[%0t] val=%0d\n", $time, val);
  
  initial begin
    val = 1;
    #10 val = 2;
    fork #5 val = 4; join_none
    val = #10 val + 1;
    val <= #10 val + 2;
    fork #5 val = 6; join_none
    #20 $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
