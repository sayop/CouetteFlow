#!/usr/bin/env python
import os
import sys
import numpy as np
import matplotlib.pyplot as plt

dataDir = '../data'
File = 'PeakRMS.dat'
File =  os.path.join(dataDir,File)
data = np.loadtxt(File)

dy = data[:,0]
rms1 = data[:,1]  # dt = 0.000625
rms2 = data[:,2]  # dt = 0.0002

MinX = min(dy)
MaxX = 2 * max(dy)
MinY = 0.5 * min(min(rms1),min(rms2))
MaxY = max(max(rms1),max(rms2))

p = plt.plot(dy,rms1, 'r-o', label='Peak RMS$_{NSS}$, $\Delta t$ = 0.000625')
p = plt.plot(dy,rms2, 'b--o', label='Peak RMS$_{NSS}$, $\Delta t$ = 0.0002')
plt.title("$\Theta = 0$", fontsize=16)
plt.setp(p, linewidth='1.0')
plt.axis([MinX,MaxX, MinY, MaxY])
plt.xscale('log')
plt.yscale('log')
plt.xlabel("dy'", fontsize=22)
plt.ylabel('Peak RMS$_{NSS}$', fontsize=22)
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
plt.setp(legendText, fontsize=18)
legend = plt.gca().get_legend()
legend.draw_frame(False)

pltFile = 'peakRMS.png'
fig = plt.gcf()
fig.set_size_inches(8,5)
plt.tight_layout()
plt.savefig(pltFile, format='png')
plt.close()

print "%s DONE!!" % (pltFile)
