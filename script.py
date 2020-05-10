import sys
import os
import math

m_0 = sys.argv[0]
n = 0
sum_of_squares = 0
sum = 0

def t_test(sum, sum_of_squares, n, m_0): 
  return (sum/n - m_0)/(sum_of_squares/(n-1))*math.sqrt(n)

for line in sys.stdin:
  result = float(line)
  sum += result
  sum_of_squares += result**2
  n += 1
  sys.stdout.write(str(t_test(sum, sum_of_squares, n, m_0)))
