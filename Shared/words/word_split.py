#!/usr/bin/env python

import json

words = {
  3: [],
  4: [],
  5: [],
  6: [],
  7: [],
  8: [],
  9: []
}

with open('words.txt', 'r') as file:
  for line in file.readlines():
    word = line.replace('\n', '').strip()
    L = len(word)

    if L in words.keys():
      words[L].append(word)

for L in words.keys():
  serial = json.dumps(words[L])

  with open(f'words{L}.json', 'w') as file:
    file.write(serial)
