module t;

  int count = 0;

  function void f();
    fork
      begin
        $write("forked process\n");
        count++;
      end
      begin
        $write("forked process\n");
        count++;
      end
      begin
        $write("forked process\n");
        count++;
      end
    join_none
  endfunction
  initial begin    
    f();
    f();
    f();
    wait(count == 9);
    $write("*-* All Finished *-*\n");
    $finish();
  end
endmodule
