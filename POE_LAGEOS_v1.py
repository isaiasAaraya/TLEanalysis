from __future__ import division
import matplotlib.pyplot as plt
import numpy as np
import sys
import math
import os

file_to_open = "input/POE/LAGEOS1_POE_9621.txt"
def POE_READER():
    with open(file_to_open, 'r') as file_poe:
        jd_poe = []
        # POE oscuating elements
        ecc = []
        per_r = []
        inc = []
        raan = []
        argp = []
        time_pa = []
        n = []
        m = []
        nu = []
        a = []
        apo_r = []
        sidereal_op = []

        i=0

        for line in file_poe:
            line = line.strip()
            line = line.replace("}", "")
            line = line.replace("/", "")
            line = line.replace("\\", "")
            splitLine = line.split(" ")

            if i % 5 == 0:
                jd_poe.append(float(splitLine[0]))
                
            else:

                if i % 5 == 1:
                    ecc.append(float(splitLine[1]))
                    per_r.append(float(splitLine[3]))
                    inc.append(float(splitLine[5])*math.pi/180)


                if i % 5 == 2:
                    raan.append(float(splitLine[1])*math.pi/180)
                    argp.append(float(splitLine[4])*math.pi/180)
                    time_pa.append(float(splitLine[7]))

                if i % 5 == 3:
                    n.append(float(splitLine[2]))
                    m.append(float(splitLine[4])*math.pi/180)
                    nu.append(float(splitLine[6])*math.pi/180)
                    
                if i % 5 == 4:
                    a.append(float(splitLine[2]))
                    apo_r.append(float(splitLine[4]))
                    sidereal_op.append(float(splitLine[6]))

            i=i+1

        file_poe.close() # close the POE file

    return (ecc, inc, raan, argp, n, m, nu, a,jd_poe)

