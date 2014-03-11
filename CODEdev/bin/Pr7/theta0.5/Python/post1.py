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
num1 = 500
File1 = os.path.join(dataDir,'Data_%06d.dat' % (num1))
Data1 = np.loadtxt(File1)


# Plot for Velocity profiles
yp1      = Data1[:,3]
up1      = Data1[:,4]
up1exact = Data1[:,5]

MinX = 0.0
MaxX = 2.0
MinY = 0.0
MaxY = 1.0

p = plt.plot(up1,yp1, 'k-', label="Numerical @t' = 0.0")
p = plt.plot(up1exact,yp1, 'ko', label="Analytic @t' = 0.0")
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

