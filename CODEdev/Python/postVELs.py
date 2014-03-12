#!/usr/bin/env python
import os
import sys
import numpy as np
import matplotlib.pyplot as plt
import glob

dataDir = '../'
plotDir = './plots'

theta = 0
dt = 0.0002

fileList = []
fileList = glob.glob(os.path.join(dataDir, "Data_*.dat"))

nIter = []
for File in fileList:
   c, k = File.split("Data_")
   k, c = k.split(".dat")

   nIter.append(int(k))

nIter = np.array(nIter)
fileList = np.array(fileList)
sortIndex = np.argsort(nIter)
nIter = nIter[sortIndex]
fileList = fileList[sortIndex]


for n in xrange(len(fileList)):
   File = fileList[n]
   time = dt * nIter[n]

   Data = np.loadtxt(File)
   yp      = Data[:,3]
   up      = Data[:,4]
   upexact = Data[:,5]

   MinX = 0.0
   MaxX = 2.0
   MinY = 0.0
   MaxY = 1.0

   p = plt.plot(up,yp, 'k-', label="Numerical solution")
   p = plt.plot(upexact,yp, 'ro', label="Analytic solution")
   plt.setp(p, linewidth='1.0')
   plt.axis([MinX,MaxX, MinY, MaxY])
   plt.title('$\Theta = %s$, dt = %s, time = %s, iteration = %s' % (theta, dt, time, nIter[n]), fontsize=16)
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
   
   pltFile = 'Velocity_%6.6i.png' % (nIter[n])
   pltFile = os.path.join(plotDir, pltFile)
   fig = plt.gcf()
   fig.set_size_inches(8,6)
   plt.tight_layout()
   plt.savefig(pltFile, format='png')
   plt.close()

   print "%s DONE!!" % (pltFile)

