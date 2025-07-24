#! /bin/bash -f

export CUDA_VISIBLE_DEVICES=0
TRAJECTORY_LENGTH=100 #ns

$AMBERHOME/bin/pmemd.cuda -O -i 2_min_1/min_1.in -o 2_min_1/min_1.out -p 1_build/box.prmtop -c 1_build/box.inpcrd  -ref 1_build/box.inpcrd -r 2_min_1/min_1.ncrst -inf 2_min_1/min_1.mdinfo 
$AMBERHOME/bin/pmemd.cuda -O -i 3_min_2/min_2.in -o 3_min_2/min_2.out -p 1_build/box.prmtop -c 2_min_1/min_1.ncrst -r 3_min_2/min_2.ncrst -inf 3_min_2/min_2.mdinfo 
$AMBERHOME/bin/pmemd.cuda -O -i 4_heat/heat.in -o 4_heat/heat.out -p 1_build/box.prmtop -c 3_min_2/min_2.ncrst -ref 3_min_2/min_2.ncrst -r 4_heat/heat.ncrst -x 4_heat/heat.nc -inf 4_heat/heat.mdinfo 
$AMBERHOME/bin/pmemd.cuda -O -i 5_equil/equil.in -o 5_equil/equil.out -p 1_build/box.prmtop -c 4_heat/heat.ncrst -r 5_equil/equil.ncrst -x 5_equil/equil.nc -inf 5_equil/equil.mdinfo
$AMBERHOME/bin/pmemd.cuda -O -i 6_run/run00001.in  -o 6_run/run00001.out -p 1_build/box.prmtop -c 5_equil/equil.ncrst -r 6_run/run00001.ncrst -x 6_run/run00001.nc -inf 6_run/run00001.mdinfo

# For the best control of process, the long MD trajectory consist of short simulations length of 1 ns with the same parameters
# This makes it easy to restart the specific MD step if some technical failure has occurred.
for (( md_step=1; md_step<=$TRAJECTORY_LENGTH - 1; md_step++ )); do 

    prefix_in="run$(printf "%05g" $md_step)"
    prefix_out="run$(printf "%05g" $((md_step + 1)))"       

    $AMBERHOME/bin/pmemd.cuda -O -i "6_run/${prefix_in}.in"  -o "6_run/${prefix_out}.out" -p "1_build/box.prmtop" -c "6_run/${prefix_in}.ncrst" -r "6_run/${prefix_out}.ncrst" -x "6_run/${prefix_out}.nc" -inf "6_run/${prefix_out}.mdinfo"
    cp "6_run/${prefix_in}.in"  "6_run/${prefix_out}.in" 

done
 
