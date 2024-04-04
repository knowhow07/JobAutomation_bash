ecut=(100 200 500 1000) #seq
#ecut=$(seq 500 10 520)
#for i in {1..7..1}


for i in ${ecut[@]}
do #opening
    echo $i
    dir=jobs/ENCUT_$i
    mkdir -p ${dir}
    cp -r example/* ${dir}
    cd ${dir} 
    sed -i "s/replace_num/$i/g" INCAR #s/replace/g  s+replace+g
    sbatch sub_lh.sh # submit the jobs
    cd - > /dev/null  #avoid the output /scratch/nliu77/hec/automation/jobs for example
done #done

# grep: find the lines with the keywords
