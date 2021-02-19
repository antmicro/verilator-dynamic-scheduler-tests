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
    tags = {}
    for t in tests:
        results[t.get("name")] = t.findall("status")[0].get("status") == "PASS"
        tags[t.get("name")] = [e.text for e in t.findall("tags")[0].findall("tag")]

    return results, tags

base_results, base_tags = get_results(base)
new_results, new_tags = get_results(new)

new_pass = []
new_fail = []
new_tests = []
missing = []

tags = new_tags

# merge tags
for k in base_tags:
    if k not in tags:
        tags[k] = base_tags[k]

all_tests = list(set(list(base_results.keys()) + list(new_results.keys())))

col_size = 0

for t in all_tests:
    if t in base_results and not t in new_results:
        missing.append(t)
    elif t in new_results and not t in base_results:
        new_tests.append(t)
    elif new_results[t] and not base_results[t]:
        new_pass.append(t)
    elif base_results[t] and not new_results[t]:
        new_fail.append(t)
    else:
        # continue to skip the statement at the bottom
        continue

    col_size = max(col_size, len(t))

def dump(hdr, tests):
    print(hdr)
    for t in tests:
        print(f"  * {t:<{col_size}}\t[{', '.join(tags[t])}]")

dump("New tests:", new_tests)
dump("Missing tests:", missing)
dump("New passing tests:", new_pass)
dump("New failing tests:", new_fail)
