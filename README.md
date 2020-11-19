Tests for Verilator with a Dynamic Scheduler
============================================

Contents:
  * `tests` - contains dedicated tests for individual features of the dynamic scheduler
  * `test.sh` - runs a single dedicated test and reports results
  * `test_all.sh` - runs all the dedicated tests
  * `regression_tests.sh` - runs the built-in Verilator regression tests in a different way (with a timeout and lists the tests that fail differently) - this is because some of the built-in regression tests are expected to fail for now

Please refer to the CI configuration for more info about how to run the scripts.
