# Balanced Accumulation Model
This model is a framework for assessing biogeochemical recovery of terrestrial ecosystems from disturbance. 

The model represents terrestrial ecosystem C and N budgets in vegetation and soil. The model includes C and N in vegetation biomass, C and N in soil organic matter and associated microbes and fauna, and inorganic N. We assume a constant CO2 concentration available in the atmosphere, which makes the CO2 supply effectively infinite. In contrast, available inorganic N in the soil is ‘‘depletable’’ and must therefore be replenished from sources outside the ecosystem or through recycling from soil organic matter.  Inputs to the model are all parameter values, initial values for all state variables, and values for all driver variables for all time steps. Outputs from the model are all state and process variables for each time step.

The differential equations are solved numerically with a fourth-/fifth-order Runge–Kutta integrator with adapting time steps to optimize precision and computation time (Press and others 1986). The model is coded in Lazarus 2.0.12 (2020) Free Pascal and runs on a PC or Mac computer.

A detailed model description is presented in Rastetter et al, 2021. The BalancedAccumulation model equations are presented in the file, BalancedAccumulation.txt.

--------------------------------------------------------------------------

### Publications 
Rastetter, EB, GW Kling, GR Shaver, BC Crump, L Gough, and KL Griffin. 2021. Ecosystem recovery form disturbance is constrained by N cycle openness, vegetation-soil distribution, form of N losses, and the balance between vegetation and soil-microbial processes. Ecosystems 24:667-685. https://doi.org/10.1007/s10021-020-00542-3.

Rastetter, E. 2020. Model output, drivers and parameters for Ecosystem Recovery from Disturbance is Constrained by N Cycle Openness, Vegetation-Soil N Distribution, Form of N Losses, and the Balance Between Vegetation and Soil-Microbial Processes ver 1. Environmental Data Initiative. https://doi.org/10.6073/pasta/0af82d3c3d9d1710775cf9b1464ce70b (Accessed 2020-09-17).

--------------------------------------------------------------------------
### Code Instructions 
The BalancedAccumulation model is written for modelshell, a model develepment package, which is written in Lazarus/Free Pascal. Modelshell allows the user to create a model by making creating a plain text file description of the model. Modelshell provides a GUI interface, an integrator, file IO, and a simple graph. All output files created by modelshell are comma delimited text files.

Detailed instructions for compiling and running the model are in "Install and Run BalancedAccumulation.docx"

--------------------------------
### Funding 
This work was supported by the National Science Foundation through Grants DEB-1651722, DEB-1556772, PLR-1603560, DEB-1754835, OPP-1841608, ARC-1603302, and especially the Arctic LTER DEB-1637459. Any opinions, findings, and conclusions or recommendations expressed in this material are those of the authors and do not necessarily
reflect those of the National Science Foundation.
