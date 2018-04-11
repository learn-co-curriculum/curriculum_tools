#!/usr/bin/env python3

from optparse import OptionParser
import sys
import urllib.request
import json
import pprint

import pdb

# See whether CSV or JSON
parser = OptionParser()
parser.add_option("-c", "--csv", dest="should_csv", action="store_true")
(options, args) = parser.parse_args()

# Ensure track ID
if len(args) < 1:
    print("We require a track (Integer) id as argument")
    sys.exit()

# Query JSON endpoint
url = "https://learn.co/api/v1/tracks/" + args[0]

content = urllib.request.urlopen(url).read()
# content = open("test.json").read()
struc = json.loads(content)

# For accumulating paths
stack = []

def parse_obj_json(obj, output):
    if "children" in obj:
        if type(obj["children"]) is list and len(obj["children"]) > 0:
            output_key = obj.get("title")
            output[output_key] = {}
            [parse_obj_json(ch, output[output_key]) for ch in obj["children"]]
        elif type(obj["children"]) is list and len(obj["children"]) == 0:
            if not "children" in output:
                output["children"] = []

            output["children"].append({
                "title": obj.get("title"),
                "github_url": obj.get("github_url")
                })
            output["children"] = sorted(output["children"], key=lambda x: x["title"])
    return output

if options.should_csv:
    pass
else:
    print(json.dumps(parse_obj_json(struc, {}), sort_keys=True, indent=4))

