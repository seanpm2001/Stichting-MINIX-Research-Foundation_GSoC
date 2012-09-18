#!/usr/bin/env bash

ARGS="-fault-rand-seed=123 -fault-functions fault_test_corrupt_pointer -fault-prob-global=1000 -fault-prob-corrupt-pointer=1000"
OUTPUT_FROM=fault_test_corrupt_pointer_start
OUTPUT_TO=fault_test_corrupt_pointer_end
RAND_SEED=123
