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

# Plot for RMS log
nIter = rmsdata[:,0]
RMSerrUS = rmsdata[:,1]
RMSerrSS = rmsdata[:,2]

MinX = min(nIter)
MaxX = max(nIter)
MinY = min(min(RMSerrUS),min(RMSerrSS))
MaxY = max(max(RMSerrUS),max(RMSerrSS))

p = plt.plot(nIter,RMSerrUS, 'r-', label='RMS$_{Unsteady}$')
p = plt.plot(nIter,RMSerrSS, 'b--', label='RMS$_{Steady}$')
plt.title("$\Theta = 0.5$ and jmax = 51", fontsize=16)
plt.setp(p, linewidth='1.0')
plt.axis([MinX,MaxX, MinY, MaxY])
plt.xscale('linear')
plt.yscale('log')
plt.xlabel('Number of iteration', fontsize=22)
plt.ylabel('RMS error', fontsize=22)
plt.grid(True)
ax = plt.gca()
xlabels = plt.getp(ax, 'xticklabels')
ylabels = plt.getp(ax, 'yticklabels')
plt.setp(xlabels, fontsize=18)
plt.setp(ylabels, fontsize=18)
plt.legend(
          loc='upper right',
          borderpad=0.25,
          handletextpad=0.25,
          borderaxespad=0.25,
          labelspacing=0.0,
          handlelength=2.0,
          numpoints=1)
legendText = plt.gca().get_legend().get_texts()
plt.setp(legendText, fontsize=18)
legend = plt.gca().get_legend()
legend.draw_frame(False)

pltFile = 'RMSlog.png'
fig = plt.gcf()
fig.set_size_inches(8,5)
plt.tight_layout()
plt.savefig(pltFile, format='png')
plt.close()

print "%s DONE!!" % (pltFile)
