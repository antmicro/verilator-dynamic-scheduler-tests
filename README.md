# Tests for Verilator with a Dynamic Scheduler

Copyright (c) 2020-2021 [Antmicro](https://www.antmicro.com)

This repostory holds set of tests of IEEE compliant scheduler in [Verilator](https://github.com/verilator/verilator).
The tests are run in a GitHub Actions CI, the results are published in [GitHub pages](https://antmicro.github.io/verilator-dynamic-scheduler-tests/report.html)

Usage:

```
$ python3 gen_robot.py
$ robot --noncritical should_fail --noncritical dist --noncritical opt robot_tests
```
