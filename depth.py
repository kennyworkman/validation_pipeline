import sys

"""Adjust to preferred value"""
MIN_DEPTH = 30

text = open('temp_depth.txt', 'r')
lines = text.readlines()
length = 0
covered = 0
for line in lines:
    length += 1
    if int(line.split()[2]) >= MIN_DEPTH:
        covered += 1
text.close()

print(covered/length*100)
