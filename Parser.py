import os
import csv

m5out = <full folder path of stats> #Ex."Z:\James\Documents\Masters\ECE562\Project\SimulationResults\\2021-04-11_22-11-11\stats"
myLines = []
csvFile = m5out + "<Name the CSV file>.csv" #Ex. ("Z:\James\Documents\Masters\ECE562\Project\SimulationResults\\2021-04-11_22-11-11\stats\\test2csv.csv")

fieldNames = ['File Name', \
              #'% Branches', \
              'Execution Time', \
              'ipc_Total', \
              #'system.cpu.iew.iewBranchMispredictRate', \
              'sim_inst', \
              'exec_refs', \
              'system.cpu.cpi', \
              'system.cpu.icache.overall_miss_rate::total',
              'system.cpu.dcache.overall_miss_rate::total',
              'system.l2.overall_miss_rate::total',
              'system.cpu.iew.iewExecLoadInsts',
              'system.cpu.iew.exec_branches'
              ]

'''
things to look
    - better expoites temporal locality
    - supposed to speed up simulation
    - AMAT of i and d cacches
    - associativity = 1
    - cache size 32kb and 128kb
    - block size 64 and 128
    - 32b 2 - 4 - 8 - 16
    - 128 
    
TODO run vanilla at 32k and 128k cache sizes

    32k

'''

#TODO :
fieldBuff = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]


def fieldParse(field, line, index, classType='int'):
    if field in line:
        buff = line.split()
        if classType == 'int':
            fieldBuff[index] = int(buff[1])
        elif classType == 'float':
            fieldBuff[index] = float(buff[1])
        else:
            print("please check type input")
        return buff


def Sorter(field, line):
    for row in line:
        if (row == 0):
            break
        else:
            if (field in row) and row != type(int):
                return row

index= 0
x=['']*50

with open(csvFile, 'w', newline='') as   output:
    writer = csv.writer(output)
    writer.writerow(fieldNames)
    for root, dirs, files in os.walk(m5out):
        for file in files:
            if file.endswith(".txt"):
                print(file)
                x[index] = file.strip('.txt')
                index = index + 1
               #print(x[index])
                with open(os.path.join(root, file)) as myFile:
                    for myLine in myFile:
                        #fieldParse("system.cpu.iew.iewBranchPercentage", \
                        #           myLine, fieldNames.index('% Branches') - 1, 'float')
                        fieldParse("host_seconds", myLine, fieldNames.index('Execution Time') - 1, 'float')
                        fieldParse("system.cpu.ipc_total", myLine, fieldNames.index('ipc_Total') - 1, 'float')
                        fieldParse("sim_insts", myLine, fieldNames.index('sim_inst') - 1)
                        fieldParse("system.cpu.iew.exec_refs", myLine, fieldNames.index('exec_refs') - 1)
                        fieldParse("system.cpu.cpi", myLine, fieldNames.index('system.cpu.cpi') - 1, 'float')
                        #fieldParse("system.cpu.iew.iewBranchMispredictRate", myLine, \
                        #           fieldNames.index('system.cpu.iew.iewBranchMispredictRate') - 1, 'float')
                        fieldParse("system.cpu.icache.overall_miss_rate::total", myLine, \
                                   fieldNames.index('system.cpu.icache.overall_miss_rate::total') - 1, 'float')
                        fieldParse("system.cpu.dcache.overall_miss_rate::total", myLine, \
                                   fieldNames.index('system.cpu.dcache.overall_miss_rate::total') - 1, 'float')
                        fieldParse("system.l2.overall_miss_rate::total", myLine, \
                                   fieldNames.index('system.l2.overall_miss_rate::total') - 1, 'float')
                        fieldParse("system.cpu.iew.iewExecLoadInsts", myLine, \
                                   fieldNames.index('system.cpu.iew.iewExecLoadInsts') - 1, 'float')
                        fieldParse("system.cpu.iew.exec_branches", myLine, \
                                   fieldNames.index('system.cpu.iew.exec_branches') - 1, 'float')


                writer.writerow([file,
                                 fieldBuff[0],
                                 fieldBuff[1],
                                 fieldBuff[2],
                                 fieldBuff[3],
                                 fieldBuff[4],
                                 fieldBuff[5],
                                 fieldBuff[6],
                                 fieldBuff[7],
                                 fieldBuff[8],
                                 fieldBuff[9],
                                 fieldBuff[10],
                                 fieldBuff[11],
                                 0])

line = [0] * 50
i = 0
#index = index-1
print(index)
sortedFields = [''] * (index)
index = 0
for file in x:
    if file != '':
        sortedFields[index] = file
        index = index + 1
    else:
        break

with open(csvFile, 'r', newline='') as output:
    reader = csv.reader(output)
    for rows in output:
        line[i] = rows
        i += 1

writeBuff = [None] * 50
'''
sortedFields = ['stats-a2time01-l2.txt',
                'stats-bitmnp01-l2.txt',
                'stats-cacheb01-l2.txt',
                'stats-libquantum-l2.txt',
                'stats-mcf-l2',
                'a2time01_1_stats.txt',
                'bitmnp01_1_stats.txt',
                'cacheb01_1_stats.txt',
                'libquantum_1_stats.txt',
                'MCF_1_stats.txt',
                'a2time01_2_stats.txt',
                'bitmnp01_2_stats.txt',
                'cacheb01_2_stats.txt',
                'libquantum_2_stats.txt',
                'MCF_2_stats.txt'
                ]
'''
i = 0
with open(csvFile, 'w', newline='') as output:
    writer = csv.writer(output)
    writer.writerow(fieldNames)
    for field in sortedFields:
        # print(field)
        writeBuff[i] = Sorter(field, line)
        buff = writeBuff[i]
        #print(buff.split(','))
        writer.writerow(buff.split(','))
        i += 1
