#!/bin/bash

#generate the POSCAR of HEA with H

for seed in {2..2}
do
  mkdir -p "seed${seed}"
  cd seed${seed}
  mkdir -p "Bulk"
  cd "Bulk"
  ~/Codes/ATOMSK/atomsk/src/atomsk --create bcc 3.165 W orient [111] [-1-12] [1-10] -duplicate 3 2 3 -select random 25% W -substitute W Ta -select random 33% W -substitute W Cr -select random 50% W -substitute W V -sort species pack POSCAR

  #python ../randomHEA-BCC-Tetra.py $RANDOM
  cp ../../BULK/INCAR ../../BULK/POTCAR ../../BULK/KPOINTS ../../BULK/scriptcuda .
  qsub scriptcuda > job    # run vasp
  cd ..
  mkdir -p "S110"
  cp Bulk/POSCAR S110
  cd S110
  awk 'BEGIN{getline; print; getline; print; getline; print; getline; print; getline; print $1,$2,$3+10;}{print}' POSCAR > tmp
  mv tmp POSCAR
  cp ../../SURFACE/INCAR ../../SURFACE/POTCAR ../../SURFACE/KPOINTS ../../SURFACE/scriptcuda .
  qsub scriptcuda > job    # run vasp
  cd ..
  cd ..
done
