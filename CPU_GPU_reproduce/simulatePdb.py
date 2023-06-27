from simtk.openmm.app import *
from simtk.openmm import *
from simtk.unit import *
from sys import stdout
import time
import sys

input_platform = sys.argv[1]
nGPUs = int(sys.argv[2])

print(input_platform)
print(ngpus)

CUTOFF = 0.85
X_DIM = 8
Y_DIM = 8
Z_DIM = 8

pdb = PDBFile('test_888.pdb')

print(pdb.topology)
print(type(pdb.topology))

forcefield = ForceField('./lj.xml')#'amber14-all.xml', 'amber14/tip3pfb.xml')#, './lj.xml')
# system = forcefield.createSystem(pdb.topology, nonbondedMethod=PME, nonbondedCutoff=1*nanometer, constraints=HBonds)
system = forcefield.createSystem(pdb.topology, nonbondedMethod=CutoffPeriodic, nonbondedCutoff=CUTOFF*nanometer, constraints=None)

vec_x = vec3.Vec3(X_DIM*CUTOFF,0,0)
vec_y = vec3.Vec3(0,Y_DIM*CUTOFF,0)
vec_z = vec3.Vec3(0,0,Z_DIM*CUTOFF)

system.setDefaultPeriodicBoxVectors(vec_x, vec_y, vec_z)
box_vectors = system.getDefaultPeriodicBoxVectors()  
print(box_vectors)
# integrator = LangevinMiddleIntegrator(300*kelvin, 1/picosecond, 0.004*picoseconds)
integrator = VerletIntegrator(0.002*picoseconds)

platform = Platform.getPlatformByName(input_platform)
if input_platform == "CUDA":
  if ngpus == 1:
    properties = {'DeviceIndex': '0', 'Precision': 'single'}
  if ngpus == 2:
    properties = {'DeviceIndex': '0,1', 'Precision': 'single'}
  if ngpus == 4:
    properties = {'DeviceIndex': '0,1,2,3', 'Precision': 'single'}
elif input_platform == "CPU":
  properties = {'Precision': 'single'}
simulation = Simulation(pdb.topology, system, integrator, platform, properties)

#### single GPU
#platform = Platform.getPlatformByName('CUDA')
#properties = {'DeviceIndex': '0', 'Precision': 'single'}
#simulation = Simulation(pdb.topology, system, integrator, platform, properties)



# simulation = Simulation(pdb.topology, system, integrator)
simulation.context.setPositions(pdb.positions)


simulation.minimizeEnergy()
#simulation.reporters.append(PDBReporter('output.pdb', 1000))
#simulation.reporters.append(StateDataReporter(stdout, 1000, step=True, potentialEnergy=True, temperature=True))

# Start the timer
start_time = time.time()

simulation.step(100000)

# End the timer
end_time = time.time()

# Calculate the elapsed time
elapsed_time = end_time - start_time

# Print the elapsed time in seconds
print(f"Elapsed time: {elapsed_time:.6f} seconds")
print("Done!")

# simulation.reporters.append(PDBReporter('output.pdb', 1))
# simulation.reporters.append(StateDataReporter(stdout, 1, step=True, potentialEnergy=True, temperature=True))
# simulation.step(100)