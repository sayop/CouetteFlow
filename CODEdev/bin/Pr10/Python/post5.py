#!/usr/bin/env python
import os
import sys
import numpy as np
import matplotlib.pyplot as plt

dataDir = '../'

# setup for RMS log data
rmsFile = 'RMSlog.dat'
rmsFile = os.path.join(dataDir,rmsFile)
rmsdata = np.loadtxt(rmsFile)

# setup for velocity profile data
num1 = 0
num2 = 200
num3 = 600
num4 = 1000
num5 = 7990
File1 = os.path.join(dataDir,'Data_%06d.dat' % (num1))
File2 = os.path.join(dataDir,'Data_%06d.dat' % (num2))
File3 = os.path.join(dataDir,'Data_%06d.dat' % (num3))
File4 = os.path.join(dataDir,'Data_%06d.dat' % (num4))
File5 = os.path.join(dataDir,'Data_%06d.dat' % (num5))
Data1 = np.loadtxt(File1)
Data2 = np.loadtxt(File2)
Data3 = np.loadtxt(File3)
Data4 = np.loadtxt(File4)
Data5 = np.loadtxt(File5)


# Plot for Velocity profiles
yp1      = Data1[:,3]
up1      = Data1[:,4]
up1exact = Data1[:,5]
yp2      = Data2[:,3]
up2      = Data2[:,4]
up2exact = Data2[:,5]
yp3      = Data3[:,3]
up3      = Data3[:,4]
up3exact = Data3[:,5]
yp4      = Data4[:,3]
up4      = Data4[:,4]
up4exact = Data4[:,5]
yp5      = Data5[:,3]
up5      = Data5[:,4]
up5exact = Data5[:,5]

MinX = 0.0
MaxX = 2.0
MinY = 0.0
MaxY = 1.0

p = plt.plot(up1,yp1, 'k-', label="Numerical @t' = 0.0")
p = plt.plot(up1exact,yp1, 'ko', label="Analytic @t' = 0.0")
p = plt.plot(up2,yp2, 'r-', label="Numerical @t' = 0.04")
p = plt.plot(up2exact,yp2, 'ro', label="Analytic @t' = 0.04")
p = plt.plot(up3,yp3, 'b-', label="Numerical @t' = 0.12")
p = plt.plot(up3exact,yp3, 'bo', label="Analytic @t' = 0.12")
p = plt.plot(up4,yp4, 'y-', label="Numerical @t' = 0.2")
p = plt.plot(up4exact,yp4, 'yo', label="Analytic @t' = 0.2")
p = plt.plot(up5,yp5, 'c-', label="Numerical @t' = 1.598")
p = plt.plot(up5exact,yp5, 'co', label="Analytic @t' = 1.598")
plt.setp(p, linewidth='1.0')
plt.axis([MinX,MaxX, MinY, MaxY])
plt.title('$\Theta = 0$', fontsize=16)
plt.xscale('linear')
plt.yscale('linear')
plt.xlabel('Non-dimensional axial velocity, u/u$_{top}$', fontsize=22)
plt.ylabel('Non-dimensional height, y/L', fontsize=22)
plt.grid(True)
ax = plt.gca()
xlabels = plt.getp(ax, 'xticklabels')
ylabels = plt.getp(ax, 'yticklabels')
plt.setp(xlabels, fontsize=18)
plt.setp(ylabels, fontsize=18)
plt.legend(
          loc='lower right',
          borderpad=0.25,
          handletextpad=0.25,
          borderaxespad=0.25,
          labelspacing=0.0,
          handlelength=2.0,
          numpoints=1)
legendText = plt.gca().get_legend().get_texts()
plt.setp(legendText, fontsize=15)
legend = plt.gca().get_legend()
legend.draw_frame(False)

pltFile = 'VelocityProfile.png'
fig = plt.gcf()
fig.set_size_inches(8,6)
plt.tight_layout()
plt.savefig(pltFile, format='png')
plt.close()

print "%s DONE!!" % (pltFile)

