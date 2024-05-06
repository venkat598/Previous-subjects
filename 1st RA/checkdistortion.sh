#!/bin/bash

# Specify the number of seeds
num_seeds=30

# Specify the number of iterations to check for stabilization
stabilization_iterations=5

# Function to check stabilization of distortion values
check_stabilization() {
  local seed=$1
  local distortion_dir=$2
  local distortion_type=$3

  distortion_values=()

  # Run the distortion calculation for the current seed
  distortion_value=$(tail -n 1 "strain/strain_${seed}/${distortion_dir}/OUTCAR" | awk '{print $NF}')
  distortion_values+=("$distortion_value")

  # Check if the distortion values have stabilized
  num_prev_values=${#distortion_values[@]}
  if ((num_prev_values >= stabilization_iterations)); then
    for ((i = num_prev_values - 1; i >= num_prev_values - stabilization_iterations + 1; i--)); do
      if [ "${distortion_values[$i]}" != "${distortion_values[$i - 1]}" ]; then
        return 1
      fi
    done
  fi

  return 0
}

# Loop through each seed
for ((seed = 1; seed <= num_seeds; seed++)); do
  echo "Checking convergence for seed $seed"

  # Check convergence for e_xyz
  e_xyz_dir="e_xyz"
  if ! check_stabilization "$seed" "$e_xyz_dir" "e_xyz"; then
    echo "Convergence not achieved for seed $seed - e_xyz"
  fi

  # Check convergence for v_xyz
  v_xyz_dir="v_xyz"
  if ! check_stabilization "$seed" "$v_xyz_dir" "v_xyz"; then
    echo "Convergence not achieved for seed $seed - v_xyz"
  fi
done
