<div align="justify">

# MD simulation of nucleosome core particle (NCP)

This repository contains the scripts and data for setup and running MD simulation of nucleosome with full-length histone
tails

### System requirements

Key packages and programs:

- [Amber Molecular Dynamics Package](https://ambermd.org/) (>=20)


### Run MD simulation

The following example of starting this protocol is for (Amber ff19SB / GBneck2). The scripts are for a local GPU
machine; it is straightforward to adapt them for a remote cluster (either GPU or CPU).

```code-block:: bash
    
    ## 2. run production trajectory
    cd md_setup/md_protocol/GBneck2/ff19SB/wt/equil+production/  
    bash build_box_prod.sh
    bash run_job_prod.sh
```

</div>



