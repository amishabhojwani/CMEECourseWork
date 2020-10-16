#print hello once for every multiple of 3 within the range
for j in range(12):
    if j % 3==0:
        print('hello')

#print hello for each value divisible by 4 & 5 with remainder 3
for j in range(15):
    if j%5==3:
        print('hello')
    elif j%4==3:
        print('hello')

#print hello for every answer to z=z+3 (starting at z=0) while z is not 15
z=0
while z!=15:
    print('hello')
    z=z+3

#print hello in two specific circumstances
z=12
while z<100:
    if z==31:
        for k in range(7):
            print('hello')
    elif z == 18:
        print('hello')
    z=z+1