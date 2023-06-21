#每条肽段有一个Dot值，画出Dot值的分布直方图
import sys
import re
import matplotlib.pyplot as plt

f=open(sys.argv[1],"r")


str=f.read()
i=re.search("TITLE="+sys.argv[2],str).end()
i=i+re.search("CHARGE=",str[i:]).end()
i=i+re.search("\n",str[i:]).end()

Max1=0
Max2=0
x1=[]
y1=[]
x2=[]
y2=[]
while str[i:i+8]!="END IONS":
    while (str[i].isdigit())==False:
        i+=1
    j=i+re.search(" ",str[i:]).start()
    x1.append(float(str[i:j]))
    while str[j]==' ':
        j+=1
    y1.append(float(str[j:j+re.search("\n",str[j:]).start()]))
    Max1=max(Max1,y1[-1])
    i=j+re.search("\n",str[j:]).end()

f.close()

f=open(sys.argv[3],"r")
str=f.read()
i=re.search("Name: "+sys.argv[4],str).end()
i=i+re.search("NumPeaks:",str[i:]).end()
while str[i]==' ':
    i+=1

num=0
while str[i].isdigit():
    num=num*10+int(str[i])
    i+=1
for k in range(num):
    while (str[i].isdigit())==False:
        i+=1
    j=i+re.search("\t",str[i:]).start()
    x2.append(float(str[i:j]))
    while str[j]=='\t':
        j+=1
    y2.append(-float(str[j:j+re.search("\t",str[j:]).start()]))
    Max2=min(Max2,y2[-1])
    i=j+re.search("\n",str[j:]).end()

#离子强度的归一化：将最高峰都设为10000
for i in range(len(y1)):
    y1[i]=y1[i]/Max1*10000
for i in range(len(y2)):
    y2[i]=y2[i]/Max2*(-10000)

plt.vlines(x1,0,y1)
plt.vlines(x2,0,y2)
for i in range(len(x1)):
    j=0
    while True:
        if x1[i]-0.1<x2[j] and x2[j]<x1[i]+0.1:
            plt.vlines(x1[i],0,y1[i],colors='r') #匹配上的两条直线标为红色，未匹配上的直线标为蓝色
            break
        j+=1
        if j>=len(x2):
            break

for i in range(len(x2)):
    j=0
    while True:
        if x2[i]-0.1<x1[j] and x1[j]<x2[i]+0.1:
            plt.vlines(x2[i],0,y2[i],colors='r')
            break
        j+=1
        if j>=len(x1):
            break

plt.title('Dot='+sys.argv[6])
plt.savefig(sys.argv[5])
plt.close()

f.close()

