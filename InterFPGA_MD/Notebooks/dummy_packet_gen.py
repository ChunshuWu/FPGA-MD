import numpy as np

# the entire array should have the length of multiples of 512
def gen_dummy_packet(num_particles, start, depth):
    arr = np.zeros((depth, 16), dtype=np.uint32)
    for j in range(16):
        arr[0][j] = num_particles
    for i in range(1, depth):
        for j in range(16):
            arr[i][j] = i+start
    return arr.flatten()
    
