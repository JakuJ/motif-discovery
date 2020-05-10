import sys
import os
import math

m_0 = float(sys.argv[1])
n = 1
sum_of_squares = 0
sum = 0


def t_test(sum, sum_of_squares, n, m_0):
    return (sum / n - m_0) / (sum_of_squares / (n - 1)) * math.sqrt(n)

for line in sys.stdin:
    result = float(line)
    sum += result
    sum_of_squares += result ** 2
    if n != 1:
      print(t_test(sum, sum_of_squares, n, m_0))
    n += 1
