#!/bin/bash

#generate the POSCAR of HEA with H

for seed in {21..30}
do
  mkdir -p "seed${seed}"
  cd seed${seed}
  mkdir -p "Bulk"
  cd "Bulk"
  ~/codes/atomsk --create bcc 3.165 W orient [111] [-1-12] [1-10] -duplicate 3 2 3 -select random 25% W -substitute W Ta -select random 33% W -substitute W Cr -select random 50% W -substitute W V -sort species pack POSCAR
  #cp CONTCAR POSCAR
  #python ../../coordinate.py
  #mv "Cartesian_POSCAR" POSCAR
  #cp POSCAR POSCAR.orig
  cp ../../BULK/INCAR ../../BULK/POTCAR ../../BULK/KPOINTS ../../BULK/scriptcuda .
  qsub scriptcuda > job    # run vasp
  cd ..
  #mkdir -p "S110"
  #cp Bulk/Cartesian_POSCAR S110/POSCAR
  #cd S110
  #awk 'BEGIN{getline; print; getline; print; getline; print; getline; print; getline; print $1,$2,$3+10;}{print}' POSCAR > tmp
  #mv tmp POSCAR
  #cp ../../SURFACE/INCAR ../../SURFACE/POTCAR ../../SURFACE/KPOINTS ../../SURFACE/scriptcuda .
  #qsub scriptcuda > job    # run vasp
  #cd ..
  #mkdir -p "SFE"
  #cp Bulk/Cartesian_POSCAR SFE/POSCAR
  #cd SFE
  #awk 'BEGIN{getline; print; getline; print; getline; print; getline; print; getline; print $1,$2,$3+10;getline;print;getline;print;print "Selective dynamics";getline;print;}{if($3>6.0) {print $1+1.37,$2,$3, "F","F","T";} else{print $1,$2,$3,"F","F","T";}}' POSCAR > tmp
  #mv tmp POSCAR
  #cp ../../SURFACE/INCAR ../../SURFACE/POTCAR ../../SURFACE/KPOINTS ../../SURFACE/scriptcuda .
  #qsub scriptcuda > job    # run vasp
  #cd ..
  cd ..
done
