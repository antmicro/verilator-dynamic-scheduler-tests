#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import xml.etree.ElementTree as et
import sys

def usage():
    print(f"Usage: {sys.argv[0]} <base_output.xml> <new_output.xml>")


try:
    base = et.parse(sys.argv[1])
    new = et.parse(sys.argv[2])
except:
    usage()
    sys.exit(1)


def get_results(data):
    tests = data.findall("suite/suite/test")
    results = {}
    for t in tests:
        results[t.get("name")] = t.findall("status")[0].get("status") == "PASS"

    return results

base_results = get_results(base)
new_results = get_results(new)

new_pass = []
new_fail = []
new_tests = []
missing = []


all_tests = list(set(list(base_results.keys()) + list(new_results.keys())))

for t in all_tests:
    if t in base_results and not t in new_results:
        missing.append(t)
    elif t in new_results and not t in base_results:
        new_tests.append(t)
    elif new_results[t] and not base_results[t]:
        new_pass.append(t)
    elif base_results[t] and not new_results[t]:
        new_fail.append(t)


def dump(hdr, tests):
    print(hdr)
    for t in tests:
        print(f"  * {t}")

dump("New tests:", new_tests)
dump("Missing tests:", missing)
dump("New passing tests:", new_pass)
dump("New failing tests:", new_fail)
