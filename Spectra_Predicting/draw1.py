#画出Dot值分布直方图
import matplotlib.pyplot as plt
import numpy as np


x=[]
for i in range(101):
    x.append(i/100.0)

y=[0]*101
HEAD=1
for line in open("HLA_A0101_data/M20151015_HLA_A0101_1e8ceq_biorep1_techrep1.txt",'r'):
    if HEAD==1:
        HEAD=0
        continue
    t=line.split()
    y[int(float(t[3])*100)]+=1

plt.bar(x,y,0.01)

plt.savefig('HLA_A0101_data/HLA_A0101_result.jpg')
plt.close()
