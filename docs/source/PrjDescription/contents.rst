Project description
===================

Given task
----------

In this exercise you calculate the viscous flow between two parallel paltes.

Such flow is described by the diffusion equation:

.. math::
   \frac{\partial u}{\partial t} = \nu \frac{\partial^{2}u}{\partial y^{2}}

Each plage is a distance L apart and the boundary conditions are :math:`u(y=0) = 0` and :math:`u(y=L) = 1`. The exact solution for this equation for any location in space and time can be written as:

.. math::
   u_{exact}(y,t) = \frac{y}{L} + \sum_{n=1}^{\infty } a_{n} sin\left ( n \pi \frac{y}{L} \right )exp\left [ -\nu \left ( \frac{n\pi}{L} \right )^{2} t \right ]

where the constants, :math:`a_{n}`, in the infinite series depend on the initial condition specified. For this project you must solve the flow for the following initial condition:

.. math::
   u(y)=\frac{y}{L} + sin\left ( \pi \frac{y}{L} \right )

The following combined implicit-explicit difference formulation (Combined Method A in section 4.2.5 in Tannehill, Anderson and Pletcher) should be used:

.. math::
   \frac{u^{n+1}_{j} - u^{n}_{j}}{\Delta t} = \frac{\nu}{\Delta y^{2}}\left [ \theta \left ( u^{n+1}_{j+1} - 2 u^{n+1}_{j} + u^{n+1}_{j-1} \right ) + (1-\theta)\left ( u^{n}_{j+1} - 2 u^{n}_{j} + u^{n}_{j-1} \right ) \right ]

First, non-dimensionalize :math:`t` and :math:`y` by :math:`\tau` and :math:`L`, respectively. Select an expression for :math:`\tau` that essentially removes :math:`\nu` from the governing flow equation. Write out the non-dimensional for this problem. You will numerically solve the non-dimensional form of the problem on a uniformly spaced mesh (i.e. constant :math:`\Delta y`) with jmax grid points (including the bottom and top wall).

Compute the time-dependent and steady state solution using a direct solution technique (i.e. non-iterative) at each time step. To do this, first rearrange the discretized equation (non-dimensional form) so that it is in tri-diagonal form. You will be able to solve for all jmax points simultaneously at each time step by writing a computer program which uses the Thomas Algorithm.
