import sys

# Set threshold equal to first command line argument
MIN_DEPTH = int(sys.argv[1])

length, covered = 0, 0
for line in sys.stdin:
    length += 1
    if int(line.split()[2]) >= MIN_DEPTH:
        covered +=1

# Print number of reads that satisfy threshold over the total
print(covered/length*100)
    
